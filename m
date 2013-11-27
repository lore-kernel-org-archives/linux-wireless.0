Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes2.cs.kuleuven.be ([134.58.40.2]:59459 "EHLO
	hermes2.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3K0NME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 08:12:04 -0500
Received: from hermes2.cs.kuleuven.be. (localhost [127.0.0.1])
	by hermes2.cs.kuleuven.be.  with ESMTP id rARDC1cN029582
	for <linux-wireless@vger.kernel.org>; Wed, 27 Nov 2013 14:12:01 +0100
Received: (from defang@localhost)
	by hermes2.cs.kuleuven.be. (8.14.4/8.14.4/Submit) id rARDAhnC029556
	for <linux-wireless@vger.kernel.org>; Wed, 27 Nov 2013 14:10:43 +0100
Message-ID: <5295EF41.8040709@cs.kuleuven.be> (sfid-20131127_141209_764781_E163528D)
Date: Wed, 27 Nov 2013 14:10:25 +0100
From: Mathy Vanhoef <mathy.vanhoef@cs.kuleuven.be>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
References: <5294E4C5.4050301@cs.kuleuven.be> <52950812.20001@rempel-privat.de>
In-Reply-To: <52950812.20001@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

It appears something went wrong with tabs/spaces when sending the patch over mail. It should work this time.

--
From: "Mathy Vanhoef" <Mathy.Vanhoef@cs.kuleuven.be>

Pick the MAC address of the first virtual interface as the new hardware MAC
address. Set BSSID mask according to this MAC address. This fixes CVE-2013-4579.

Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
---
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d441045..84359c3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -147,21 +147,26 @@ static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_vif_iter_data *iter_data = data;
 	int i;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	if (iter_data->hw_macaddr != NULL) {
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	} else {
+		iter_data->hw_macaddr = mac;
+	}
 }
 
-static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
+static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
 				     struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_vif_iter_data iter_data;
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
-	iter_data.hw_macaddr = common->macaddr;
+	iter_data.hw_macaddr = NULL;
 	memset(&iter_data.mask, 0xff, ETH_ALEN);
 
 	if (vif)
@@ -173,6 +178,10 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
 		ath9k_htc_bssid_iter, &iter_data);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.hw_macaddr)
+		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+
 	ath_hw_setbssidmask(common);
 }
 
@@ -1083,7 +1092,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
@@ -1148,7 +1157,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_opmode(priv);
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	/*
 	 * Stop ANI only if there are no associated station interfaces.
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b6aad69..99ab0aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -885,8 +885,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	memset(&iter_data->mask, 0xff, ETH_ALEN);



On 26/11/2013 21:44, Oleksij Rempel wrote:
> Hi Mathy,
> 
> thank you for your work!
> suddenly this patch do not apply on top of
>  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> can you please update it.
> 
> 
> Am 26.11.2013 19:13, schrieb Mathy Vanhoef:
>> From: "Mathy Vanhoef" <Mathy.Vanhoef@cs.kuleuven.be>
>>
>> Pick the MAC address of the first virtual interface as the new hardware MAC
>> address. Set BSSID mask according to this MAC address. This fixes
>> CVE-2013-4579.
>>
>> Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
>> ---
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> index d441045..84359c3 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> @@ -147,21 +147,26 @@ static void ath9k_htc_bssid_iter(void *data, u8
>> *mac, struct ieee80211_vif *vif)
>>      struct ath9k_vif_iter_data *iter_data = data;
>>      int i;
>>  
>> -    for (i = 0; i < ETH_ALEN; i++)
>> -        iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
>> +    if (iter_data->hw_macaddr != NULL) {
>> +        for (i = 0; i < ETH_ALEN; i++)
>> +            iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
>> +    } else {
>> +        iter_data->hw_macaddr = mac;
>> +    }
>>  }
>>  
>> -static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
>> +static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
>>                       struct ieee80211_vif *vif)
>>  {
>>      struct ath_common *common = ath9k_hw_common(priv->ah);
>>      struct ath9k_vif_iter_data iter_data;
>>  
>>      /*
>> -     * Use the hardware MAC address as reference, the hardware uses it
>> -     * together with the BSSID mask when matching addresses.
>> +     * Pick the MAC address of the first interface as the new hardware
>> +     * MAC address. The hardware will use it together with the BSSID mask
>> +     * when matching addresses.
>>       */
>> -    iter_data.hw_macaddr = common->macaddr;
>> +    iter_data.hw_macaddr = NULL;
>>      memset(&iter_data.mask, 0xff, ETH_ALEN);
>>  
>>      if (vif)
>> @@ -173,6 +178,10 @@ static void ath9k_htc_set_bssid_mask(struct
>> ath9k_htc_priv *priv,
>>          ath9k_htc_bssid_iter, &iter_data);
>>  
>>      memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
>> +
>> +    if (iter_data.hw_macaddr)
>> +        memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
>> +
>>      ath_hw_setbssidmask(common);
>>  }
>>  
>> @@ -1083,7 +1092,7 @@ static int ath9k_htc_add_interface(struct
>> ieee80211_hw *hw,
>>          goto out;
>>      }
>>  
>> -    ath9k_htc_set_bssid_mask(priv, vif);
>> +    ath9k_htc_set_mac_bssid_mask(priv, vif);
>>  
>>      priv->vif_slot |= (1 << avp->index);
>>      priv->nvifs++;
>> @@ -1148,7 +1157,7 @@ static void ath9k_htc_remove_interface(struct
>> ieee80211_hw *hw,
>>  
>>      ath9k_htc_set_opmode(priv);
>>  
>> -    ath9k_htc_set_bssid_mask(priv, vif);
>> +    ath9k_htc_set_mac_bssid_mask(priv, vif);
>>  
>>      /*
>>       * Stop ANI only if there are no associated station interfaces.
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
>> b/drivers/net/wireless/ath/ath9k/main.c
>> index b6aad69..99ab0aa 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -885,8 +885,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
>>      struct ath_common *common = ath9k_hw_common(ah);
>>  
>>      /*
>> -     * Use the hardware MAC address as reference, the hardware uses it
>> -     * together with the BSSID mask when matching addresses.
>> +     * Pick the MAC address of the first interface as the new hardware
>> +     * MAC address. The hardware will use it together with the BSSID mask
>> +     * when matching addresses.
>>       */
>>      memset(iter_data, 0, sizeof(*iter_data));
>>      memset(&iter_data->mask, 0xff, ETH_ALEN);
>>
>>
>> Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
