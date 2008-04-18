Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:54429 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYDRQ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 12:56:31 -0400
Received: by wa-out-1112.google.com with SMTP id m16so1021368waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 09:56:30 -0700 (PDT)
Message-ID: <1ba2fa240804180956j84ae83bqb561f389eb6f6694@mail.gmail.com> (sfid-20080418_175637_678800_60CF7333)
Date: Fri, 18 Apr 2008 19:56:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v4] mac80211: Replace ieee80211_tx_control->key_idx with ieee80211_key_conf
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <1208469746.4066.98.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804171728.30188.IvDoorn@gmail.com>
	 <200804171759.54830.IvDoorn@gmail.com>
	 <200804171923.41533.IvDoorn@gmail.com>
	 <200804171941.03002.IvDoorn@gmail.com>
	 <1208469746.4066.98.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2008 at 1:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  > +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>  > @@ -1936,7 +1936,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
>  >       struct iwl_wep_key *wepkey;
>  >       int keyidx = 0;
>  >
>  > -     BUG_ON(ctl->key_idx > 3);
>  > +     BUG_ON(ctl->hw_key->hw_key_idx > 3);
>  >
>  >       switch (keyinfo->alg) {
>  >       case ALG_CCMP:
>  > @@ -1955,11 +1955,11 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
>  >               break;
>  >
>  >       case ALG_WEP:
>  > -             wepkey = &priv->wep_keys[ctl->key_idx];
>  > +             wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
>  >               cmd->cmd.tx.sec_ctl = 0;
>  >               if (priv->default_wep_key) {
>  >                       /* the WEP key was sent as static */
>  > -                     keyidx = ctl->key_idx;
>  > +                     keyidx = ctl->hw_key->hw_key_idx;
>  >                       memcpy(&cmd->cmd.tx.key[3], wepkey->key,
>  >                                                       wepkey->key_size);
>  >                       if (wepkey->key_size == WEP_KEY_LEN_128)
>
>  All this is rather odd. I think you (Intel) may want to change it to use
>  hw_key->keyidx and just leave the hw_key_idx alone, it seems to be a
>  copy of keyidx in iwl4965 but an actual index as it was meant to be used
>  in iwl3945?

Sure, this patch changes the picture., in addition the code can be a
bit simplified.
Will fix that.
Thanks
Tomas

>
