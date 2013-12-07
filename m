Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64596 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab3LGQtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 11:49:18 -0500
Received: from [192.168.1.138] ([93.218.116.213]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LfC4q-1VE6Vw2rSi-00okBd for
 <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 17:49:17 +0100
Message-ID: <52A35189.7010804@rempel-privat.de> (sfid-20131207_174924_535159_9B1DB469)
Date: Sat, 07 Dec 2013 17:49:13 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Mathy <vanhoefm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Pau Koning <paukoning@gmail.com>, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
References: <5294E4C5.4050301@cs.kuleuven.be> <52950812.20001@rempel-privat.de> <5295EF41.8040709@cs.kuleuven.be> <CANiGF999jHN3+5QuNVAkVk_hHxZ6LkPxWB3jW9yoJGbfno7M9A@mail.gmail.com> <52972749.70200@gmail.com> <20131206162919.GE13285@tuxdriver.com> <CAFXAJYzO5ifSYbiN7xqV5Sr+3CFrZsaqc2dg0bt-JB0EUxFRdQ@mail.gmail.com>
In-Reply-To: <CAFXAJYzO5ifSYbiN7xqV5Sr+3CFrZsaqc2dg0bt-JB0EUxFRdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have only one doubt in this patch.
It will overwrite original MAC. If you wont to restore it, then you need
to reload module.

If no body against it, i can live it too.

Am 06.12.2013 21:30, schrieb Mathy:
> It was renamed to make it clear the function now changes both the
> BSSID and MAC registers.
> 
> On Fri, Dec 6, 2013 at 5:29 PM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Thu, Nov 28, 2013 at 12:21:45PM +0100, Mathy Vanhoef wrote:
>>> Third time's the charm?
>>> --
>>> From: "Mathy Vanhoef" <vanhoefm@gmail.com>
>>>
>>> Pick the MAC address of the first virtual interface as the new hardware MAC
>>> address. Set BSSID mask according to this MAC address. This fixes CVE-2013-4579.
>>>
>>> Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
>>> ---
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> index d441045..84359c3 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> @@ -147,21 +147,26 @@ static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
>>>       struct ath9k_vif_iter_data *iter_data = data;
>>>       int i;
>>>
>>> -     for (i = 0; i < ETH_ALEN; i++)
>>> -             iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
>>> +     if (iter_data->hw_macaddr != NULL) {
>>> +             for (i = 0; i < ETH_ALEN; i++)
>>> +                     iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
>>> +     } else {
>>> +             iter_data->hw_macaddr = mac;
>>> +     }
>>>  }
>>>
>>> -static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
>>> +static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
>>>                                    struct ieee80211_vif *vif)
>>>  {
>>
>> I'm not sure I see the point of renaming this function -- just
>> personal preference?
>>
>>>       struct ath_common *common = ath9k_hw_common(priv->ah);
>>>       struct ath9k_vif_iter_data iter_data;
>>>
>>>       /*
>>> -      * Use the hardware MAC address as reference, the hardware uses it
>>> -      * together with the BSSID mask when matching addresses.
>>> +      * Pick the MAC address of the first interface as the new hardware
>>> +      * MAC address. The hardware will use it together with the BSSID mask
>>> +      * when matching addresses.
>>>        */
>>> -     iter_data.hw_macaddr = common->macaddr;
>>> +     iter_data.hw_macaddr = NULL;
>>>       memset(&iter_data.mask, 0xff, ETH_ALEN);
>>>
>>>       if (vif)
>>> @@ -173,6 +178,10 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
>>>               ath9k_htc_bssid_iter, &iter_data);
>>>
>>>       memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
>>> +
>>> +     if (iter_data.hw_macaddr)
>>> +             memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
>>> +
>>>       ath_hw_setbssidmask(common);
>>>  }
>>>
>>> @@ -1083,7 +1092,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>>>               goto out;
>>>       }
>>>
>>> -     ath9k_htc_set_bssid_mask(priv, vif);
>>> +     ath9k_htc_set_mac_bssid_mask(priv, vif);
>>>
>>>       priv->vif_slot |= (1 << avp->index);
>>>       priv->nvifs++;
>>> @@ -1148,7 +1157,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
>>>
>>>       ath9k_htc_set_opmode(priv);
>>>
>>> -     ath9k_htc_set_bssid_mask(priv, vif);
>>> +     ath9k_htc_set_mac_bssid_mask(priv, vif);
>>>
>>>       /*
>>>        * Stop ANI only if there are no associated station interfaces.
>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>> index b6aad69..99ab0aa 100644
>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>> @@ -885,8 +885,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
>>>       struct ath_common *common = ath9k_hw_common(ah);
>>>
>>>       /*
>>> -      * Use the hardware MAC address as reference, the hardware uses it
>>> -      * together with the BSSID mask when matching addresses.
>>> +      * Pick the MAC address of the first interface as the new hardware
>>> +      * MAC address. The hardware will use it together with the BSSID mask
>>> +      * when matching addresses.
>>>        */
>>>       memset(iter_data, 0, sizeof(*iter_data));
>>>       memset(&iter_data->mask, 0xff, ETH_ALEN);
>>>
>>>
>>>
>>>
>>
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.


-- 
Regards,
Oleksij
