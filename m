Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45639 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761649AbYDQP37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 11:29:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: Replace ieee80211_tx_control->key_idx with ieee80211_key_conf
Date: Thu, 17 Apr 2008 17:29:34 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>
References: <200804171728.30188.IvDoorn@gmail.com>
In-Reply-To: <200804171728.30188.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804171729.34583.mb@bu3sch.de> (sfid-20080417_163016_377904_FD779564)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 April 2008 17:28:29 Ivo van Doorn wrote:
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
> index 19aefbf..2ee19cf 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -235,7 +235,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>  
>  	plcp_fragment_len = fragment_len + FCS_LEN;
>  	if (use_encryption) {
> -		u8 key_idx = (u16) (txctl->key_idx);
> +		u8 key_idx = (u16) (txctl->hw_key->hw_key_idx);

Can we actually remove that bogus cast while we are at it? :)

>  		struct b43_key *key;
>  		int wlhdr_len;
>  		size_t iv_len;
> diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
> index dcad249..ba50b68 100644
> --- a/drivers/net/wireless/b43legacy/xmit.c
> +++ b/drivers/net/wireless/b43legacy/xmit.c
> @@ -232,7 +232,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
>  
>  	plcp_fragment_len = fragment_len + FCS_LEN;
>  	if (use_encryption) {
> -		u8 key_idx = (u16)(txctl->key_idx);
> +		u8 key_idx = (u16)(txctl->hw_key->hw_key_idx);

Same here.

-- 
Greetings Michael.
