Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51427 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2HaPYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 11:24:41 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so5691518obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2012 08:24:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=kzUW=PTRMDpxVf-pQVdozC5U_g-GPyFQ+vkRTFhe1dw@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<CAJ-Vmo=kzUW=PTRMDpxVf-pQVdozC5U_g-GPyFQ+vkRTFhe1dw@mail.gmail.com>
Date: Fri, 31 Aug 2012 23:24:40 +0800
Message-ID: <CAEFj985FB5PhGRqWfzpsN46Y1YdAw42w+_u4EBzUfP1vjswCnQ@mail.gmail.com> (sfid-20120831_172454_721098_0F8714BB)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Adrian

Appreciate your testing on this.

---
Chun-Yeow

On Fri, Aug 31, 2012 at 2:58 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hiya,
>
> This is cool stuff - but as I don't think MFP is enabled in any
> hardware pre-AR9280, I think it's worth doing a lot more testing
> before flipping this on.
>
> But very cool indeed. I'll see what it'll take to get it enabled in
> the FreeBSD atheros HAL for these chips.
>
>
>
> Adrian
>
> On 28 August 2012 02:34, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>> This patch provides the support of hardware encyrption for
>> management frame, including the support of AES CMAC. This
>> patch is tested with the following chipsets:
>> - AR5213A
>> - AR5413
>> - AR2413/AR2414
>>
>> Beside, this patch also extends the IBSS RSN to mesh.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/base.c         |    4 +++-
>>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |    7 +++++--
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>> index a0a202d..084162e 100644
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -2446,7 +2446,9 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
>>         hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>>                         IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>>                         IEEE80211_HW_SIGNAL_DBM |
>> -                       IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>> +                       IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>> +                       IEEE80211_HW_MFP_CAPABLE |
>> +                       IEEE80211_HW_SUPPORTS_PER_STA_GTK;
>>
>>         hw->wiphy->interface_modes =
>>                 BIT(NL80211_IFTYPE_AP) |
>> diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
>> index df61a09..7f78caa 100644
>> --- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
>> +++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
>> @@ -489,7 +489,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>         if (ath5k_modparam_nohwcrypt)
>>                 return -EOPNOTSUPP;
>>
>> -       if (vif->type == NL80211_IFTYPE_ADHOC &&
>> +       if ((vif->type == NL80211_IFTYPE_ADHOC ||
>> +            vif->type == NL80211_IFTYPE_MESH_POINT) &&
>>             (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
>>              key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
>>             !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
>> @@ -502,6 +503,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>         case WLAN_CIPHER_SUITE_WEP104:
>>         case WLAN_CIPHER_SUITE_TKIP:
>>                 break;
>> +       case WLAN_CIPHER_SUITE_AES_CMAC:
>>         case WLAN_CIPHER_SUITE_CCMP:
>>                 if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
>>                         break;
>> @@ -522,7 +524,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>                         key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>>                         if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
>>                                 key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
>> -                       if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
>> +                       if (key->cipher == WLAN_CIPHER_SUITE_CCMP &&
>> +                           !(common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM))
>>                                 key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
>>                         ret = 0;
>>                 }
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
