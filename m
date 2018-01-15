Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0134.outbound.protection.outlook.com ([104.47.36.134]:53061
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755309AbeAOKKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 05:10:02 -0500
Subject: Re: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when
 user helper is enabled
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
 <5A589428.7020502@broadcom.com> <87a7xjs4xa.fsf@kamboji.qca.qualcomm.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <713a8666-8b72-9198-03a3-a3656c5cb84d@cypress.com> (sfid-20180115_111007_903250_A26A64ED)
Date: Mon, 15 Jan 2018 18:09:35 +0800
MIME-Version: 1.0
In-Reply-To: <87a7xjs4xa.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018/1/12 下午 07:16, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> On 1/12/2018 8:44 AM, Wright Feng wrote:
>>> For legacy chips without CLM blob files, kernel with user helper function
>>> returns -EAGAIN when we request_firmware() for blob file.
> 
> _Why_ is the -EAGAIN returned? Is it because of user space, due to
> timing when loading the brcmfmac module or what? You should explain the
> problem in detail in the commit log and why this is the right approach
> to fix the problem.
> 
> Based on the commit log to me this still looks like a random attempt to
> workaround a bug, not a proper fix.
> 

It is not about the timing issue, it is about "the clm blob is not
existence in firmware path for legacy firmware with CLM data built-in" 
and the -ENOENT error is transferred to -EAGAIN in firmware_class.c.

Here is explanation of -EAGAIN returned in detail.
In drivers/base/firmware_class.c:__fw_state_wait_common, it returns
-ENOENT to indicate the clm_blob file is not found via user helper.
However, in drivers/base/firmware_class.c:_request_firmware_load, all
errors with fw status aborted are transferred to:

1. -ERESTARTSYS: The signal is pending and the task is interruptible.
Before 76098b36b5db ("firmware: send -EINTR on signal abort on fallback
mechanism"), all errors with fw status aborted are transferred to
-EAGAIN.

2. -EAGAIN: All others fw status aborted(include -ENOENT) except for
-ERESTARTSYS.

And that's why I handle -EAGAIN error to let driver using CLM data in
firmware.

>>> In this case, brcmf_bus_started gets error and failed to bring up
>>> legacy chips. Because of that, we should continue with CLM data
>>> currently present in firmware if getting -EAGAIN when doing
>>> request_firmware().
>>>
>>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>>> ---
>>> v2: remove retry from patch v1
>>> ---
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>> index 6a59d06..0baab4c 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>> @@ -182,7 +182,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>>>
>>>    	err = request_firmware(&clm, clm_name, dev);
>>>    	if (err) {
>>> -		if (err == -ENOENT) {
>>> +		if (err == -ENOENT || err == -EAGAIN) {
>>>    			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
>>>    			return 0;
>>>    		}
>>
>> Why don't we just fall-back to "CLM in firmware" regardless of the
>> error code?
> 
> Indeed, I was thinking the same.
> 
For the firmwares with CLM data built-in, it is okay to continue the
bringing-up flow.
But when users put clm_blob file to firmware path, the corresponding
firmware may not have CLM data built-in. If we fall-back to use empty
CLM data in firmware when hitting other errors like "-ENOMEM" or
"-EINTR", the country code revision will be null and users will meet
error when trying to connect to access point.
It is fine to fall-back to "CLM in firmware" regardless of the error
code, but it would be better to print error log to indicate the error if
the returned error codes are not what we expected.


Please let me know your opinion of below commit log and diff, if it is
okay to you, I will post Patch v3 later.



For legacy chips without CLM blob files, kernel with user helper
function returns -EAGAIN when we request_firmware() for blob file. So,
it got failed when bring up legacy chips. We expect the CLM blob files
is not existence in firmware path, however the -ENOENT error is
transferred to -EAGAIN in firmware_class.c.
Because of that, we continue with CLM data currently present in
firmware if getting error in doing request_firmware().

---
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 12 
++++++------
  1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 6a59d06..aaab0e6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -182,12 +182,12 @@ static int brcmf_c_process_clm_blob(struct 
brcmf_if *ifp)

  	err = request_firmware(&clm, clm_name, dev);
  	if (err) {
-		if (err == -ENOENT) {
-			brcmf_dbg(INFO, "continue with CLM data currently present in 
firmware\n");
-			return 0;
-		}
-		brcmf_err("request CLM blob file failed (%d)\n", err);
-		return err;
+		if (err == -ENOENT || err == -EAGAIN)
+			brcmf_info("continue with CLM data in FW\n");
+		else
+			brcmf_err("request clm_blob failed(%d) continue with CLM data in FW\n",
+				  err);
+		return 0;
  	}

  	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, GFP_KERNEL);
-- 
