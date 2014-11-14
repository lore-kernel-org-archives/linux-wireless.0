Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51700 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378AbaKNLAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 06:00:51 -0500
Received: by mail-vc0-f178.google.com with SMTP id hq12so5282943vcb.23
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 03:00:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5465D217.2050107@rempel-privat.de>
References: <1415941631-24140-1-git-send-email-yeohchunyeow@gmail.com>
	<5465C333.7030704@rempel-privat.de>
	<CAEFj987ng6Jxa4u3+Z+0oGFX7LUnkLPP96bBrCSnSetjU+YjpQ@mail.gmail.com>
	<5465D217.2050107@rempel-privat.de>
Date: Fri, 14 Nov 2014 19:00:50 +0800
Message-ID: <CAEFj986fsGDtJVkGXJLZ+_a9rt9XPG=QfKWtq9Ofba_3Qu0BCA@mail.gmail.com> (sfid-20141114_120055_192649_59A8F90B)
Subject: Re: [PATCH] ath9k_htc: turn on software mgmt crypto for secured mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately, I don't have any docs for this. Any others?

---
ChunYeow

On Fri, Nov 14, 2014 at 5:57 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 14.11.2014 um 10:06 schrieb Yeoh Chun-Yeow:
>> On Fri, Nov 14, 2014 at 4:54 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>> Am 14.11.2014 um 06:07 schrieb Chun-Yeow Yeoh:
>>>> Secured mesh encrypts the unicast mgmt frame using the same
>>>> key that used for encrypting the unicast data frame. The patch
>>>> "ath9k_htc_firmware: fix the offset of CCMP header for mesh
>>>> data frame" applied to open-ath9k-htc-firmware allows the
>>>> ath9k_htc to be loaded without "nohwcrypt=1". Unfortunately,
>>>> this is not working and we still need CCMP encryption of
>>>> management frames to be done in software. Fix this.
>>>>
>>>> This patch is tested with the following hardwares:
>>>> - TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
>>>> - AR9271 802.11n
>>>>
>>>> and managed to work with peer mesh STA equipped with ath9k.
>>>>
>>>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>>> index 689ac99..d3f65a2 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>>> @@ -1447,7 +1447,8 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
>>>>                       key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>>>>                       if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
>>>>                               key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
>>>> -                     if (priv->ah->sw_mgmt_crypto &&
>>>> +                     if ((vif->type == NL80211_IFTYPE_MESH_POINT ||
>>>> +                          priv->ah->sw_mgmt_crypto) &&
>>>>                           key->cipher == WLAN_CIPHER_SUITE_CCMP)
>>>>                               key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
>>>>                       ret = 0;
>>>>
>>>
>>>
>>> Hmm.. may be we should generally do it here:
>>>         if ((vif->type == NL80211_IFTYPE_ADHOC ||
>>>              vif->type == NL80211_IFTYPE_MESH_POINT) &&
>>>             (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
>>>              key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
>>>             !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
>>>
>>
>> Not so sure doing here is correctly. It is a pairwise key for unicast
>> management frame, right?
>
> yes.
> this code is identical to ath9k, so i will move it to common. This is
> the reason of my doubts.
>
>>> or probably set "sw_mgmt_crypto = true" in ath9k_hw_init_mfp() for all
>>> usb devices?
>>
>> All ath9k USB devices don't have MFP support?
>
> Hmm... do you have docs?
>
> --
> Regards,
> Oleksij
>
