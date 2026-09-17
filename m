Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9297643D503;
	Thu, 17 Sep 2026 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635411; cv=none; b=KDkN5+Iv4w/mGLqadI3633xmxI/ebXXN0dRHzLOcCChekO6cXadoUBwIqpcR0ZjlBt3JHo1JFZlwvbWYwSt+MJiOzKiyE9DCyTGUxL6CkSdl6Gn4p4q38k12Oua67kq/3RzMQqan4fCTtxThm8tCTmcJTBWTAGSPBkWl2sxbKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635411; c=relaxed/simple;
	bh=s5u2AyGTEY7qVivI6JscsmSZSmPFDoG29XJMQntgNm0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d/Am0pst1wUAV3dXNHsl3OcD7VIShaTWdiQPOvd8EFa6b20e2tJvLHpSC4UxVF3k9sGJx5kRs4jkVQdqkB4K/RZ7tBcyUkofLd86c67KgVRD8vEXaIUZ77DR6EWRRaBUPft9iUQsa1iM7Jhk9vleProxauHOGj8f1+yF+XP+k5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: ath9k: reject short WMI command responses
In-Reply-To: <8c2dbacf-63ec-428c-b283-50198579cb89@oss.qualcomm.com>
References: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
 <8c2dbacf-63ec-428c-b283-50198579cb89@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 10:56:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87cxucuugu.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jeff Johnson <jeff.johnson@oss.qualcomm.com> writes:

> On 8/14/2026 12:58 AM, Pengpeng Hou wrote:
>> ath9k_wmi_rsp_callback() removes the validated WMI header and copies
>> the number of bytes expected by the waiting command into its response
>> buffer. A device response shorter than that expectation can therefore
>> be read beyond the skb payload.
>> 
>> Record -EMSGSIZE for a short response, complete the waiter, and return
>> the stored status from the command path. This also prevents callers from
>> consuming stale response bytes as a successful reply.
>> 
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
>> ---
>> Changes since v1: https://lore.kernel.org/all/20260704011405.55089-1-pengpeng@iscas.ac.cn/
>> - return a stored response error to the waiting command
>> - retain acceptance of replies longer than the requested prefix
>> - recheck callback synchronization under the existing WMI lock
>> 
>> The WMI callback and waiter synchronization were reviewed statically; no
>> ath9k firmware fault injection was performed.
>> 
>>  drivers/net/wireless/ath/ath9k/wmi.c | 17 +++++++++++++++--
>>  drivers/net/wireless/ath/ath9k/wmi.h |  1 +
>>  2 files changed, 16 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
>> index 284e8c13b043..06d9975f9717 100644
>> --- a/drivers/net/wireless/ath/ath9k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
>> @@ -206,8 +206,16 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
>>  {
>>  	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
>>  
>> -	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
>> +	if (wmi->cmd_rsp_buf && wmi->cmd_rsp_len) {
>> +		if (skb->len < wmi->cmd_rsp_len) {
>> +			wmi->cmd_rsp_status = -EMSGSIZE;
>
> my review agent notes that if this path is taken that there is no debug
> message alerting this. see my suggestion on dealing with this below...

I think you're being pedantic here. I'm pretty sure there's no real
hardware that does this; merging this is meant to protect against a
USB device pretending to be an ath9k_htc and trying to exploit the
kernel. So I think it's fine to merge as-is.

-Toke
