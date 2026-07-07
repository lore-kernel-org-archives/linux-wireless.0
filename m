Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC33A1C9
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783435612; cv=none; b=V1oTfkL3L2A6Yx8z6WJLlck01DCp0jxMk9gAOf/bplcy01COy4fLXNoXcBLWz0cvbU+KoU1n+g4oaYDfU04oVy9yValAFH5+Ug9yYxxLXGEFRdVZMGJu7kInOddy0geP4Xd0u0eCpNP46zOukx2HTMrHZa69TkUD2jeT1pKOLfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783435612; c=relaxed/simple;
	bh=sQivW2Zp72ACivnnfajY3oMecyV+TQ05SmB+ANg4rwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C5p4akeNoPgdLihbPA+ff+BpajJ+QY7Aid2F3fmYZG27K/qrdjFBYecm8rC00M4D1C3yK468IR1CkWmzg4NU9CdKPJ1pwLP3EUsUQKvf/phxrZL/qgq9QL3hGtlW6ba1W5zPa0LCuZRQc3/id4aFg+SPk+Itwq8b1hKhjxkyZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=BSLLeQgA; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="BSLLeQgA"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B856E2C3034
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 14:38:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C4BD4AC0076;
	Tue,  7 Jul 2026 14:38:48 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.38.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id A228313C2B0;
	Tue,  7 Jul 2026 07:38:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A228313C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1783435126;
	bh=sQivW2Zp72ACivnnfajY3oMecyV+TQ05SmB+ANg4rwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BSLLeQgAIg39p0dMYSJ5blF5Valw0Al3HBQ4l325r4F3d3g6uZdGKt4NVR7lMKBCn
	 gQmiS3hZTxZZwivuqlF+oXDyb2DQ9FGobWlqSPCRJTOBavSQYiOZsf2sXk9LmWn4n9
	 y4O96v3PVTYhKtgbXCEdvPFCR1cEw5lKFynv8ov8=
Message-ID: <d39f212a-5161-4d00-bc38-bcdc5fee2658@candelatech.com>
Date: Tue, 7 Jul 2026 07:38:39 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: reinit wiphy work entries on runaway
 drain
To: Cen Zhang <zzzccc427@gmail.com>, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, baijiaju1990@gmail.com
References: <20260707134925.106972-1-zzzccc427@gmail.com>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <20260707134925.106972-1-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1783435129-5AQR00P3Cyri
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1783435129;5AQR00P3Cyri;<greearb@candelatech.com>;42964693c53d782159cd6d1d1559cb6f
X-PPE-TRUSTED: V=1;DIR=OUT;

On 7/7/26 06:49, Cen Zhang wrote:
> cfg80211_process_wiphy_works() has a runaway guard for the process-all
> case. When the guard fires, it drops the remaining queued work by
> reinitializing rdev->wiphy_work_list.

Even this likely leaves the system in a bad state since requested work
items would be skipped.  Probably should also increase runaway_limit quite
a bit as well (that has worked OK for me), maybe remove it entirely.

Thanks,
Ben

> 
> That only resets the list head. The queued struct wiphy_work entries are
> embedded in their owners, and their entry fields still point at the old
> list neighbors. Later queue or cancel checks can then see a work item as
> listed even though the rdev list has been cleared.
> 
> Drain the remaining list with list_del_init() under wiphy_work_lock
> instead of reinitializing only the head. This keeps the existing WARN and
> drop behavior while leaving each work item in the same state as normal
> wiphy work removal.
> 
> Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>   net/wireless/core.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 3dcf63b04c41..a7e011ed455d 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -1278,8 +1278,14 @@ void cfg80211_process_wiphy_works(struct cfg80211_registered_device *rdev,
>   		if (wk == end)
>   			break;
>   
> -		if (WARN_ON(--runaway_limit == 0))
> -			INIT_LIST_HEAD(&rdev->wiphy_work_list);
> +		if (WARN_ON(--runaway_limit == 0)) {
> +			while (!list_empty(&rdev->wiphy_work_list)) {
> +				wk = list_first_entry(&rdev->wiphy_work_list,
> +						      struct wiphy_work,
> +						      entry);
> +				list_del_init(&wk->entry);
> +			}
> +		}
>   	}
>   	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
>   }

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

