Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0109.outbound.protection.outlook.com ([104.47.37.109]:33664
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750748AbdI2GTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 02:19:09 -0400
Subject: Re: [PATCH] brcmfmac: return -EPERM when getting error in vendor
 command handler
To: Franky Lin <franky.lin@broadcom.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>
References: <1504510473-13549-1-git-send-email-wright.feng@cypress.com>
 <CA+8PC_fV70z-ELAEWgg0Q3MM6N7niHozeDh-PWNLYmJ7YY-mVQ@mail.gmail.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <0078099e-9520-b89e-3759-cb7d0726ed7e@cypress.com> (sfid-20170929_081920_688965_6B50BC17)
Date: Fri, 29 Sep 2017 14:18:59 +0800
MIME-Version: 1.0
In-Reply-To: <CA+8PC_fV70z-ELAEWgg0Q3MM6N7niHozeDh-PWNLYmJ7YY-mVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Franky,

On 2017/9/6 上午 04:02, Franky Lin wrote:
> On Mon, Sep 4, 2017 at 12:34 AM, Wright Feng <wright.feng@cypress.com> wrote:
>> Firmware returns proprietary error code when getting error in
>> fil_cmd_data_set or fil_cmd_data_get. The vendor tools or
>> utilities which uses libnl may stuck in some commands when wl is down.
>> For example, issue "scan" command after issuing "down" command, the
>> "scan" command will be the blocking call and stuck as no response from
>> libnl. It is caused by that firmware returns BCME_NOTUP(-4) when wl
>> is down, but the -4 is -EINTR in Linux kernel, so libnl catches the error
>> and not passes to upper layer.
>> Because of that, the driver should return Linux error code instead of the
>> proprietary error code, and the tools or utilities need to get the real
>> firmware error code by command "bcmerror" or "bcmerrorstr" after receiving
>> the error.
>>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
>> index 8eff275..2b88ba1 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
>> @@ -80,8 +80,12 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
>>          else
>>                  ret = brcmf_fil_cmd_data_get(ifp, cmdhdr->cmd, dcmd_buf,
>>                                               ret_len);
>> -       if (ret != 0)
>> +
>> +       if (ret != 0) {
>> +               brcmf_dbg(INFO, "error(%d), return -EPERM\n", ret);
>> +               ret = -EPERM;
>>                  goto exit;
>> +       }
> 
> It would be better to handle the conversion in brcmf_fil_cmd_data so
> everyone can benefit. Also please try to assign an appropriate error
Thanks for the suggestion and sorry for replying the mail lately.(We got 
some mail server issue a couple days ago.)

I will move the conversion to 
brcmf_proto_bcdc_query_dcmd/brcmf_proto_bcdc_set_dcmd for bcdc
and
brcmf_msgbuf_query_dcmd for msgbuf.
> code when possible to provide more information to the upper layer. For
> this case "ENETDOWN" seems to be a better fit for BCME_NOTUP.
One more thing I need your suggestion.
Some of firmware error codes do not have proper error code mapping to 
Linux, like "BCME_NOTUP", "BCME_ERROR", "BCME_NOTAP", "BCME_NOTSTA", 
"BCME_ASSOCIATED"...
Is that okay using -EIO for those errors which do have proper mapping 
error code? Or do you know the error code for the generic error?

Regards,
Wright
> 
> Thanks,
> Franky
> 
>>          wr_pointer = dcmd_buf;
>>          while (ret_len > 0) {
>> --
>> 1.9.1
>>
