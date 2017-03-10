Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35670 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964814AbdCJJfr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 04:35:47 -0500
Received: by mail-qk0-f178.google.com with SMTP id v125so155851288qkh.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 01:35:41 -0800 (PST)
Subject: Re: [PATCH v2 2/4] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-2-hdegoede@redhat.com>
 <33689f32-1bf8-98f8-df65-278de097e435@broadcom.com>
 <738d049d-4e90-8a5d-e5c0-d037085a064c@redhat.com>
 <d0bec61e-4481-42b9-fcdd-d6a8f8f3524e@broadcom.com>
 <edc0f67d-59d7-437c-2588-e895217577cd@broadcom.com>
 <d6e96a5e-863b-5054-f370-117c10c7ce2b@redhat.com>
 <51624320-cbde-65e4-ee24-a4df8c7935d6@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f467a979-7a86-127f-4828-30f15dcd5512@broadcom.com> (sfid-20170310_104853_720580_53CDFE7C)
Date: Fri, 10 Mar 2017 10:35:32 +0100
MIME-Version: 1.0
In-Reply-To: <51624320-cbde-65e4-ee24-a4df8c7935d6@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-3-2017 9:08, Hans de Goede wrote:
> Hi,
> 
> On 08-03-17 12:16, Hans de Goede wrote:
>> Hi,
>>
>> On 08-03-17 11:15, Arend Van Spriel wrote:
>>> On 8-3-2017 10:26, Arend Van Spriel wrote:
>>>> On 8-3-2017 9:24, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 07-03-17 11:03, Arend Van Spriel wrote:
>>>>>>
>>>>>>
>>>>>> On 27-2-2017 22:45, Hans de Goede wrote:
>>>>>>> The firmware responding with -EBUSY when trying to add an extra
>>>>>>> virtual-if
>>>>>>> is a normal thing, do not print an error for this.
>>>>>>
>>>>>> This may be something we need to look into. It seems to me the
>>>>>> interface
>>>>>> combinations needs to be fixed so we do not try to provision
>>>>>> firmware.
>>>>>> Can you explain the scenario here?
>>>>>
>>>>> I'm not doing anything special just connecting to my isp provided
>>>>> accesspoint
>>>>> using NetworkManager.
>>>>
>>>> Ok. So it is probably the P2P_DEVICE interface as that is the only
>>>> interface being created in that scenario. Can you provide a log with
>>>> brcmfmac driver debug=0x1416.
>>>
>>> I guess you are seeing this with 43362. Is that correct?
> 
> Attached is a dmesg log from the brcmfmac driver build with debugging
> enabled and brcmfmac.debug set to 0x1416.

I suspect the P2P_DEVICE interface is assigned the same address as
wlp1s0. Can you apply the change below and create the log again.

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
b/drivers/ne
index de19c7c..43fa9f45 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2158,7 +2158,8 @@ struct wireless_dev *brcmf_p2p_add_vif(struct
wiphy *wiphy
        if (brcmf_cfg80211_vif_event_armed(cfg))
                return ERR_PTR(-EBUSY);

-       brcmf_dbg(INFO, "adding vif \"%s\" (type=%d)\n", name, type);
+       brcmf_dbg(INFO, "adding vif \"%s\" (type=%d, addr=%pM)\n", name,
type,
+                 params->macaddr);

        switch (type) {
        case NL80211_IFTYPE_P2P_CLIENT:
