Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932993AbeALLQh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 06:16:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when user helper is enabled
References: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
        <5A589428.7020502@broadcom.com>
Date: Fri, 12 Jan 2018 13:16:33 +0200
In-Reply-To: <5A589428.7020502@broadcom.com> (Arend van Spriel's message of
        "Fri, 12 Jan 2018 11:55:36 +0100")
Message-ID: <87a7xjs4xa.fsf@kamboji.qca.qualcomm.com> (sfid-20180112_121641_695143_2E668840)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 1/12/2018 8:44 AM, Wright Feng wrote:
>> For legacy chips without CLM blob files, kernel with user helper function
>> returns -EAGAIN when we request_firmware() for blob file.

_Why_ is the -EAGAIN returned? Is it because of user space, due to
timing when loading the brcmfmac module or what? You should explain the
problem in detail in the commit log and why this is the right approach
to fix the problem.

Based on the commit log to me this still looks like a random attempt to
workaround a bug, not a proper fix.

>> In this case, brcmf_bus_started gets error and failed to bring up
>> legacy chips. Because of that, we should continue with CLM data
>> currently present in firmware if getting -EAGAIN when doing
>> request_firmware().
>>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>> ---
>> v2: remove retry from patch v1
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> index 6a59d06..0baab4c 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> @@ -182,7 +182,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>>
>>   	err = request_firmware(&clm, clm_name, dev);
>>   	if (err) {
>> -		if (err == -ENOENT) {
>> +		if (err == -ENOENT || err == -EAGAIN) {
>>   			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
>>   			return 0;
>>   		}
>
> Why don't we just fall-back to "CLM in firmware" regardless of the
> error code?

Indeed, I was thinking the same.

-- 
Kalle Valo
