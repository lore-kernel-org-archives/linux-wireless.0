Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCA7C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC2DE21A80
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393845AbfBOLGu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:06:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38188 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393771AbfBOLGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:06:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gubKR-0004rv-Pc; Fri, 15 Feb 2019 12:06:48 +0100
Message-ID: <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:06:46 +0100
In-Reply-To: <20190210210620.31181-4-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-4-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
> 
>  - Enforce cipher does not change when replacing a key.

is that actually required somehow?

> + * @EXT_SET_KEY: a new key must be set but is only valid for decryption
> + * @EXT_KEY_RX_TX: a key installed with @EXT_SET_KEY is becoming the
> + *	designated Rx/Tx key for the station

Not sure I like the EXT_SET_KEY. There's also no "designated Rx key", is
there? It's always selected by key ID.

How about SET_KEY_RXONLY and SET_KEY_TX or something like that?

> +static int ieee80211_set_tx_key(struct ieee80211_sub_if_data *sdata,
> +				const u8 *mac_addr, u8 key_idx)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_key *key;
> +	struct sta_info *sta;
> +	int ret;
> +
> +	if (!wiphy_ext_feature_isset(local->hw.wiphy,
> +				     NL80211_EXT_FEATURE_EXT_KEY_ID))
> +		return -EINVAL;

You set this, wouldn't it make more sense to check EXT_KEY_ID_NATIVE?

Or maybe this is because of the next patch?

> +	sta = sta_info_get_bss(sdata, mac_addr);
> +
> +	if (!sta)
> +		return -EINVAL;
> +
> +	if (sta->ptk_idx == key_idx)
> +		return 0;
> +
> +	mutex_lock(&local->key_mtx);
> +	key = key_mtx_dereference(local, sta->ptk[key_idx]);
> +
> +	if (key && key->flags & KEY_FLAG_RX_ONLY)

do you even need the flag? Isn't it equivalent to checking
	sta->ptk_idx != key->idx
or so?

Less data to maintain would be better.

> +	bool ext_native = ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE);

you sort of only need this in the next patch, but I guess it doesn't
matter that much

> +int ieee80211_key_activate_tx(struct ieee80211_key *key)
> +{
> +	struct ieee80211_sub_if_data *sdata = key->sdata;
> +	struct sta_info *sta = key->sta;
> +	struct ieee80211_local *local = key->local;
> +	struct ieee80211_key *old;
> +	int ret;
> +
> +	assert_key_lock(local);
> +
> +	key->flags &= ~KEY_FLAG_RX_ONLY;
> +
> +	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
> +	    key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
> +			       IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
> +			       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
> +		increment_tailroom_need_count(sdata);
> +
> +	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> +		ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
> +				  &sta->sta, &key->conf);
> +		if (ret) {
> +			sdata_err(sdata,
> +				  "failed to activate key for Tx (%d, %pM)\n",
> +				  key->conf.keyidx, sta->sta.addr);
> +			return ret;

You've already cleared the RX_ONLY flag, which gets you inconsistent
data now.

> +		}
> +	}
> +
> +	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
> +	sta->ptk_idx = key->conf.keyidx;

but you set this only here.

> -		/* Stop TX till we are on the new key */
> +		/* Stop Tx till we are on the new key */

Uh, I had to read that three times ... please don't make changes like
that? :)

>  		old_key->flags |= KEY_FLAG_TAINTED;
>  		ieee80211_clear_fast_xmit(sta);
>  
> -		/* Aggregation sessions during rekey are complicated due to the
> +		/* Aggregation sessions during rekey are complicated by the

similarly here, please don't make drive-by comment wording issues (also,
I'm not sure I agree - the old version just treats "complicated" as an
adjective, you treat it as a verb, but ultimately doesn't really matter?

>  #define NUM_DEFAULT_KEYS 4
>  #define NUM_DEFAULT_MGMT_KEYS 2
> +#define INVALID_PTK_KEYIDX 2 /* Existing key slot never used by PTK keys */

We could also use something obviously wrong like 0xff?

> +++ b/net/mac80211/tx.c
> @@ -3000,23 +3000,15 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
>  		switch (build.key->conf.cipher) {
>  		case WLAN_CIPHER_SUITE_CCMP:
>  		case WLAN_CIPHER_SUITE_CCMP_256:
> -			/* add fixed key ID */
> -			if (gen_iv) {
> -				(build.hdr + build.hdr_len)[3] =
> -					0x20 | (build.key->conf.keyidx << 6);
> +			if (gen_iv)
>  				build.pn_offs = build.hdr_len;
> -			}
>  			if (gen_iv || iv_spc)
>  				build.hdr_len += IEEE80211_CCMP_HDR_LEN;
>  			break;
>  		case WLAN_CIPHER_SUITE_GCMP:
>  		case WLAN_CIPHER_SUITE_GCMP_256:
> -			/* add fixed key ID */
> -			if (gen_iv) {
> -				(build.hdr + build.hdr_len)[3] =
> -					0x20 | (build.key->conf.keyidx << 6);
> +			if (gen_iv)
>  				build.pn_offs = build.hdr_len;
> -			}
>  			if (gen_iv || iv_spc)
>  				build.hdr_len += IEEE80211_GCMP_HDR_LEN;
>  			break;
> @@ -3383,6 +3375,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
>  			pn = atomic64_inc_return(&key->conf.tx_pn);
>  			crypto_hdr[0] = pn;
>  			crypto_hdr[1] = pn >> 8;
> +			crypto_hdr[3] = 0x20 | (key->conf.keyidx << 6);
>  			crypto_hdr[4] = pn >> 16;
>  			crypto_hdr[5] = pn >> 24;
>  			crypto_hdr[6] = pn >> 32;

This shouldn't be needed, you do update the fast TX cache when changing
the key?

johannes

