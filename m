Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:47298 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754806AbeEXElZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 00:41:25 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Johannes Berg <johannes@sipsolutions.net>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
 <1526637270.3805.15.camel@sipsolutions.net>
 <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
 <1527069018.3759.15.camel@sipsolutions.net>
 <988f350d-a6eb-1733-4a2f-43a87053e96a@codeaurora.org>
 <1527071997.3759.18.camel@sipsolutions.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <b94186ea-e76e-1940-365b-4ca72abad77f@dd-wrt.com> (sfid-20180524_064130_897823_F2A2CB45)
Date: Thu, 24 May 2018 06:41:20 +0200
MIME-Version: 1.0
In-Reply-To: <1527071997.3759.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 23.05.2018 um 12:39 schrieb Johannes Berg:
> On Wed, 2018-05-23 at 16:09 +0530, Manikanta Pubbisetty wrote:
>>>>>> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
>>>>>> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
>>>>>> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
>>>>>> + *     operations in the BSS.
>>>>> Based on the name and initial description, this sounds equivalent to
>>>>> just turning off SW_CRYPTO_CONTROL. I think that's not the intent, but
>>>>> would need some renaming.
>>>> I can rename it to something which is very specific to VLAN support on
>>>> sw crypto controlled devices if that is okay.
>>> I don't think that makes sense. If we split the capability of AP_VLAN
>>> and AP_VLAN_FOR_4ADDR at the "root", then we don't need to play with all
>>> these things. Yes, this is slightly awkward for userspace, and perhaps
>>> with the interface combination checks, but I'd like you to look at that.
>>>
>> Makes sense, I had this thought to split the VLAN and 4-addr
>> functionality, but since we need to fiddle with userspace, I refrained.
>> Anyways, I will check all the possibilities of splitting these
>> functionalities.
> I'm not sure we really have to - it's likely that wpa_s/hostapd don't
> check the capabilities?
mmh not sure. it might not check the capabilitiy, but it sets the 
interface type to IFTYPE_AP_VLAN
for wds sta interfaces. that might collide

see the following snippet taken from hostapd code

static int i802_set_wds_sta(void *priv, const u8 *addr, int aid, int val,
                             const char *bridge_ifname, char *ifname_wds)
{
         struct i802_bss *bss = priv;
         struct wpa_driver_nl80211_data *drv = bss->drv;
         char name[IFNAMSIZ + 1];

         os_snprintf(name, sizeof(name), "%s.sta%d", bss->ifname, aid);
         if (ifname_wds)
                 os_strlcpy(ifname_wds, name, IFNAMSIZ + 1);

         wpa_printf(MSG_DEBUG, "nl80211: Set WDS STA addr=" MACSTR
                    " aid=%d val=%d name=%s", MAC2STR(addr), aid, val, 
name);
         if (val) {
                 if (!if_nametoindex(name)) {
                         if (nl80211_create_iface(drv, name,
NL80211_IFTYPE_AP_VLAN,
                                                  bss->addr, 1, NULL, 
NULL, 0) <
                             0)
                                 return -1;
                         if (bridge_ifname &&
linux_br_add_if(drv->global->ioctl_sock,
                                             bridge_ifname, name) < 0)
                                 return -1;
                 }
                 if (linux_set_iface_flags(drv->global->ioctl_sock, 
name, 1)) {
                         wpa_printf(MSG_ERROR, "nl80211: Failed to set 
WDS STA "
                                    "interface %s up", name);
                 }
                 return i802_set_sta_vlan(priv, addr, name, 0);
         } else {
                 if (bridge_ifname)
linux_br_del_if(drv->global->ioctl_sock, bridge_ifname,
                                         name);

                 i802_set_sta_vlan(priv, addr, bss->ifname, 0);
                 nl80211_remove_iface(drv, if_nametoindex(name));
                 return 0;
         }
}


>
> johannes
>
