Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0067.outbound.protection.outlook.com ([104.47.37.67]:8224
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756600AbdELRsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 13:48:02 -0400
Subject: Re: [v6] qtnfmac: introduce new FullMAC driver for Quantenna chipsets
To: Kalle Valo <kvalo@codeaurora.org>, Joe Perches <joe@perches.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        "hwang@quantenna.com" <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
 <20170512151854.6F16A60953@smtp.codeaurora.org>
 <87shkap0e5.fsf@kamboji.qca.qualcomm.com>
 <1494603783.2028.21.camel@perches.com> <87bmqy6nff.fsf@purkki.adurom.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <603e7b39-ae58-536e-8d15-4c0e6456c370@quantenna.com> (sfid-20170512_194819_125592_0BFDB86B)
Date: Fri, 12 May 2017 10:47:55 -0700
MIME-Version: 1.0
In-Reply-To: <87bmqy6nff.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2017 09:37 AM, Kalle Valo wrote:
> 
> External Email
> 
> 
> Joe Perches <joe@perches.com> writes:
> 
>> On Fri, 2017-05-12 at 15:20 +0000, Kalle Valo wrote:
>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>> Here's the diff between v5 and v6:
>>
>> trivia:
>>
>>> diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
>> []
>>> @@ -93,9 +94,11 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
>>>
>>>       qtnf_scan_done(vif->mac, true);
>>>
>>> -    if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
>>> -            pr_err("failed to change interface type\n");
>>> -            return -EFAULT;
>>> +    ret = qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
>>> +    if (ret) {
>>> +            pr_err("VIF%u.%u: failed to change VIF type: %d\n",
>>> +                   vif->mac->macid, vif->vifid, ret);
>>
>> It might make sense to add vif_<level> macros or functions
>> to make sure the vif->mac->macid, vif->vifid are emitted
>> consistently and simplify the calls
>>
>> For instance:
>>                vif_err(vif, "failed to change VIF type %d\n", ret);
>>
>> etc...
> 
> Yeah, I was thinking the same.
> 
>> Not necessarily in this patch, maybe in a future one.
> 
> Exactly, that's easy to do in a separate patch after the driver is
> merged.

Added to tasks queue, thanks. Admittedly, there would have been much 
less typing in V6 if done this way right away.

> 
> --
> Kalle Valo
> 
