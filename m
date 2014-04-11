Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaDKH7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 03:59:48 -0400
Message-ID: <1397203178.4420.6.camel@jlt4.sipsolutions.net> (sfid-20140411_095952_012488_85BC626F)
Subject: Re: [PATCH v2 1/2] mac80211: add option to generate CCMP IVs only
 for mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 11 Apr 2014 09:59:38 +0200
In-Reply-To: <1397033857-2523-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140409_105814_570743_B097AC2A)
References: <1397033857-2523-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20140409_105814_570743_B097AC2A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 10:57 +0200, Marek Kwaczynski wrote:
> Some chips can encrypt managment frames in HW, but
> require generated IV in the frame. Add a key flag
> that allows us to achieve this.

> + * @IEEE80211_KEY_FLAG_GENERATE_MGMT_IV_TX: This flag should be set by the
> + *	driver for a CCMP key to indicate that is requires IV generation
> + *	only for managment frames (MFP).

Maybe IEEE80211_KEY_FLAG_GENERATE_IV_MGMT would be better and matching
the IEEE80211_KEY_FLAG_GENERATE_IV better?

>   */
>  enum ieee80211_key_flags {
> -	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
> +	IEEE80211_KEY_FLAG_GENERATE_IV		= 1<<1,

Since you're touching all these, please convert them all to BIT().

> @@ -625,8 +625,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  				tx->key = NULL;
>  			else
>  				skip_hw = (tx->key->conf.flags &
> -					   IEEE80211_KEY_FLAG_SW_MGMT_TX) &&
> -					ieee80211_is_mgmt(hdr->frame_control);
> +				   (IEEE80211_KEY_FLAG_SW_MGMT_TX |
> +				    IEEE80211_KEY_FLAG_GENERATE_MGMT_IV_TX)) &&
> +				    ieee80211_is_mgmt(hdr->frame_control);

This seems wrong, you don't want to skip_hw in this case, you just want
to have the IV generated.

> +	/* hwaccel - with software CCMP header or the HW needs
> +	 * generated the IV
> +	 */
> +	if (info->control.hw_key ||
> +	    (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MGMT_IV_TX))
>  		return 0;

This seems equally wrong, and it looks like maybe in this case two
wrongs make a right, but I think you should probably put it in the
place(s) where IEEE80211_KEY_FLAG_GENERATE_IV is checked.

johannes

