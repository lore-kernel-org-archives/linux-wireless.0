Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34430 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbcHJTMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:12:15 -0400
Received: by mail-pf0-f173.google.com with SMTP id p64so18664625pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2016 12:12:14 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: shut down AP and set IBSS mode only on primary
 interface
To: Wright Feng <wefe@cypress.com>,
	"brcm80211-dev-list.pdl@broadcom.com"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"franky.lin@broadcom.com" <franky.lin@broadcom.com>,
	"hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	Chi-Hsien Lin <chln@cypress.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <20160810080100.GA10783@cypress.com>
 <4d60ec5e-6462-372a-2d3c-5770493e7e98@broadcom.com>
 <DM5PR06MB28258E50D25AE4221558BA28D91D0@DM5PR06MB2825.namprd06.prod.outlook.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cab5a204-3487-ebe6-7e82-ca6dbb04ff40@broadcom.com> (sfid-20160810_211229_424701_FE0C4864)
Date: Wed, 10 Aug 2016 12:15:10 +0200
MIME-Version: 1.0
In-Reply-To: <DM5PR06MB28258E50D25AE4221558BA28D91D0@DM5PR06MB2825.namprd06.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-8-2016 11:44, Wright Feng wrote:
> Hi Arend,
> 
> Thanks for the reply.
> 
> On 10-8-2016 10:26, Arend Van Spriel wrote:
>> On 10-8-2016 10:01, Wright Feng wrote:
>>> When stopping hostap on virtual interface, driver will set INFRA and
>>> AP mode that may affect the functionality on primary interface. For
>>> example, if we create and stop hostapd on virtual interface then
>>> association cannot work on primary interface because INFRA mode has
>> been set to IBSS.
>>> Hence we shut down AP and set IBSS mode only on primary interface.
>>
>> What is actually the use-case here. Can you elaborate? BRCMF_C_DOWN
>> command turns out to be effectively bring the whole stack down and not just
>> the supplied interface. I suppose you are hitting that issue here as well, right?
> We want to use AP mode to let client connecting in AP+STA mode with 43438 wi-fi chip.
> After that, the AP mode will be stopped, and wpa_supplicant cannot associate to the access point.
> I describe the steps in detail as below.
> 1. Create virtual interface and set mode to __ap
> 2. start wpa_supplicant on primary interface and connect to wireless router.
> 3. start hostap daemon on virtual interface and let client connecting.
> 4. stop hostap daemon
> 5. wpa_supplicant cannot associate to access point normally.
> 
> Like you said, the issue may be hit by BRCMF_C_DOWN and same as BRCMF_C_SET_INFRA
> BRCMF_C_SET_INFRA is not just for the supplied interface either. The default bss will be changed in firmware and let firmware uses IBSS mode to join.
> About BRCMF_C_DOWN, driver will set BRCMF_C_UP command to bring device back up so it can be used again.
> However, there is no way to set INFRA mode back except starting AP mode again.

Ok.

>>
>> Regards,
>> Arend
>>
>>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>>> ---
>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5
>> ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git
>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index 2628d5e..0687ab9 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -4716,6 +4716,8 @@ exit:
>>>
>>>  static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct
>>> net_device *ndev)  {
>>> +       struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
>>> +       struct net_device *primary_ndev = cfg_to_ndev(cfg);
>>>         struct brcmf_if *ifp = netdev_priv(ndev);
>>>         s32 err;
>>>         struct brcmf_fil_bss_enable_le bss_enable; @@ -4723,7 +4725,8
>>> @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct
>>> net_device *ndev)
>>>
>>>         brcmf_dbg(TRACE, "Enter\n");
>>>
>>> -       if (ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) {
>>> +       if ((ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) &&
>>> +           (ndev == primary_ndev)) {
>>>                 /* Due to most likely deauths outstanding we sleep */
>>>                 /* first to make sure they get processed by fw. */
>>>                 msleep(400);
>>> --
>>> 1.9.1
>>>
>>>
>>> This message and any attachments may contain Cypress (or its subsidiaries)
>> confidential information. If it has been received in error, please advise the
>> sender and immediately delete this message.
>>>
> 
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

Is there any way for you to get rid of this foot note. It may keep Kalle
from taking this patch. Other option is to take this patch through our
internal tree.

Regards,
Arend
