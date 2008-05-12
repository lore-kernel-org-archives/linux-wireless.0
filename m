Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:56532 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYELLzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 07:55:19 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1846368fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 04:55:17 -0700 (PDT)
Message-ID: <8704f27d0805120455h7def292cx6775bb09dfd464bc@mail.gmail.com> (sfid-20080512_135526_070196_98072405)
Date: Mon, 12 May 2008 14:55:17 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <8704f27d0805120213w197327b0r2fa490df1e5399d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
	 <1210271472.30724.43.camel@carrot.hep.upenn.edu>
	 <8704f27d0805081149wa91072en32ce8912ba1a14ff@mail.gmail.com>
	 <8704f27d0805120213w197327b0r2fa490df1e5399d1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I could reproduce the bug here. The patch below should solve the
issue. In any case, this patch is not meant to be pushed, it's debug
only.
Final and clean patch will come soon.

On Mon, May 12, 2008 at 12:13 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> here is the patch I promised last week, can you please try it ?
>  You might have some trouble to apply since my code base slightly
>  differs from yours.
>
>  --------------------------------
>
>  From 860fe4a63b1e9be8047f1b2f37c9072e92df5a5b Mon Sep 17 00:00:00 2001
>
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>  Date: Mon, 12 May 2008 10:21:01 +0300
>  Subject: [PATCH] iwlwifi: code clean up in security
>
>  This patch cleans up code in security. This clean up uses the
>  new pointer to ieee80211_key_conf passed with the tx_control.
>
>
>  Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>  ---
>   drivers/net/wireless/iwlwifi/iwl-sta.c      |   24 +++++++--------
>   drivers/net/wireless/iwlwifi/iwl4965-base.c |   43 +++++++++------------------
>   2 files changed, 25 insertions(+), 42 deletions(-)
>
>  diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
>  b/drivers/net/wireless/iwlwifi/iwl-sta.c
>  index c8e468f..ab3e223 100644
>  --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
>  +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
>  @@ -324,7 +324,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
>         unsigned long flags;
>
>         keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
>  -       keyconf->hw_key_idx = keyconf->keyidx;
>  +       keyconf->hw_key_idx = 1;
>         priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
>
>         spin_lock_irqsave(&priv->sta_lock, flags);
>  @@ -354,7 +354,6 @@ static int iwl_set_wep_dynamic_key_info(struct
>  iwl_priv *priv,
>         int ret;
>
>         keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
>  -       keyconf->hw_key_idx = keyconf->keyidx;
>
>         key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
>         key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
>  @@ -411,7 +410,6 @@ static int iwl_set_ccmp_dynamic_key_info(struct
>  iwl_priv *priv,
>                 key_flags |= STA_KEY_MULTICAST_MSK;
>
>         keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>  -       keyconf->hw_key_idx = keyconf->keyidx;
>
>         spin_lock_irqsave(&priv->sta_lock, flags);
>         priv->stations[sta_id].keyinfo.alg = keyconf->alg;
>  @@ -449,12 +447,10 @@ static int iwl_set_tkip_dynamic_key_info(struct
>  iwl_priv *priv,
>
>         keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
>         keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
>  -       keyconf->hw_key_idx = keyconf->keyidx;
>
>         spin_lock_irqsave(&priv->sta_lock, flags);
>
>         priv->stations[sta_id].keyinfo.alg = keyconf->alg;
>  -       priv->stations[sta_id].keyinfo.conf = keyconf;
>         priv->stations[sta_id].keyinfo.keylen = 16;
>
>         if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
>  @@ -483,7 +479,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
>         u16 key_flags;
>         u8 keyidx;
>
>  -       priv->key_mapping_key = 0;
>  +       priv->key_mapping_key--;
>
>         spin_lock_irqsave(&priv->sta_lock, flags);
>         key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
>  @@ -521,24 +517,26 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
>   EXPORT_SYMBOL(iwl_remove_dynamic_key);
>
>   int iwl_set_dynamic_key(struct iwl_priv *priv,
>  -                               struct ieee80211_key_conf *key, u8 sta_id)
>  +                               struct ieee80211_key_conf *keyconf, u8 sta_id)
>   {
>         int ret;
>
>  -       priv->key_mapping_key = 1;
>  +       priv->key_mapping_key++;
>  +       priv->stations[sta_id].keyinfo.conf = keyconf;
>  +       keyconf->hw_key_idx = 0;
>
>  -       switch (key->alg) {
>  +       switch (keyconf->alg) {
>         case ALG_CCMP:
>  -               ret = iwl_set_ccmp_dynamic_key_info(priv, key, sta_id);
>  +               ret = iwl_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
>                 break;
>         case ALG_TKIP:
>  -               ret = iwl_set_tkip_dynamic_key_info(priv, key, sta_id);
>  +               ret = iwl_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
>                 break;
>         case ALG_WEP:
>  -               ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
>  +               ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
>                 break;
>         default:
>  -               IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
>  +               IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
>                 ret = -EINVAL;
>
>         }
>
>  diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  index 481e943..492fc63 100644
>
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  @@ -1466,16 +1466,13 @@ static void
>  iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
>                                       struct sk_buff *skb_frag,
>                                       int sta_id)
>   {
>  -       struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
>  -       struct iwl_wep_key *wepkey;
>         int keyidx = 0;
>  +       struct ieee80211_key_conf *keyconf = ctl->hw_key;
>
>  -       BUG_ON(ctl->hw_key->hw_key_idx > 3);
>  -
>  -       switch (keyinfo->alg) {
>  +       switch (keyconf->alg) {
>         case ALG_CCMP:
>                 cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
>  -               memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
>  +               memcpy(cmd->cmd.tx.key, keyconf->key, keyconf->keylen);
>                 if (ctl->flags & IEEE80211_TXCTL_AMPDU)
>                         cmd->cmd.tx.tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
>                 IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
>  @@ -1483,39 +1480,26 @@ static void
>  iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
>
>         case ALG_TKIP:
>                 cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
>  -               ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
>  +               ieee80211_get_tkip_key(keyconf, skb_frag,
>                         IEEE80211_TKIP_P2_KEY, cmd->cmd.tx.key);
>                 IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
>                 break;
>
>         case ALG_WEP:
>  -               wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
>  -               cmd->cmd.tx.sec_ctl = 0;
>  -               if (priv->default_wep_key) {
>  -                       /* the WEP key was sent as static */
>  -                       keyidx = ctl->hw_key->hw_key_idx;
>  -                       memcpy(&cmd->cmd.tx.key[3], wepkey->key,
>  -                                                       wepkey->key_size);
>  -                       if (wepkey->key_size == WEP_KEY_LEN_128)
>  -                               cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
>  -               } else {
>  -                       /* the WEP key was sent as dynamic */
>  -                       keyidx = keyinfo->keyidx;
>  -                       memcpy(&cmd->cmd.tx.key[3], keyinfo->key,
>  -                                                       keyinfo->keylen);
>  -                       if (keyinfo->keylen == WEP_KEY_LEN_128)
>  -                               cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
>  -               }
>  +               cmd->cmd.tx.sec_ctl = (TX_CMD_SEC_WEP |
>  +                       (keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
>
>  -               cmd->cmd.tx.sec_ctl |= (TX_CMD_SEC_WEP |
>  -                       (keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
>  +               if (keyconf->keylen == WEP_KEY_LEN_128)
>  +                       cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
>  +
>  +               memcpy(&cmd->cmd.tx.key[3], keyconf->key, keyconf->keylen);
>
>                 IWL_DEBUG_TX("Configuring packet for WEP encryption "
>                              "with key %d\n", keyidx);
>                 break;
>
>         default:
>  -               printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
>  +               printk(KERN_ERR "Unknown encode alg %d\n", keyconf->alg);
>                 break;
>         }
>   }
>  @@ -5579,11 +5563,11 @@ static int iwl4965_mac_set_key(struct
>
> ieee80211_hw *hw, enum set_key_cmd cmd,
>                 if (cmd == SET_KEY)
>                         is_default_wep_key = !priv->key_mapping_key;
>                 else
>  -                       is_default_wep_key = priv->default_wep_key;
>  +                       is_default_wep_key = key->hw_key_idx;
>         }
>  -
>         switch (cmd) {
>         case SET_KEY:
>  +               printk(KERN_ERR "Set key: static = %d, keyidx = %d sta = %d default
>  = %d\n", is_default_wep_key, key->keyidx, sta_id,
>  priv->key_mapping_key);
>
>                 if (is_default_wep_key)
>                         ret = iwl_set_default_wep_key(priv, key);
>                 else
>  @@ -5592,6 +5576,7 @@ static int iwl4965_mac_set_key(struct
>
> ieee80211_hw *hw, enum set_key_cmd cmd,
>
>                 IWL_DEBUG_MAC80211("enable hwcrypto key\n");
>                 break;
>         case DISABLE_KEY:
>  +               printk(KERN_ERR "Remove key: static = %d, keyidx = %d sta = %d
>  default = %d\n", is_default_wep_key, key->keyidx, sta_id,
>  priv->key_mapping_key);
>
>                 if (is_default_wep_key)
>                         ret = iwl_remove_default_wep_key(priv, key);
>                 else
>  --
>  1.5.4.1
>
>
>
>
>
>  --
>  Emmanuel Grumbach
>  egrumbach@gmail.com
>



-- 
Emmanuel Grumbach
egrumbach@gmail.com
