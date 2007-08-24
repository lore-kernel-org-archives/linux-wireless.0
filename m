Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36114
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbXHXVXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 17:23:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
Date: Fri, 24 Aug 2007 23:21:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20070824122705.549190000@sipsolutions.net> <20070824122905.350213000@sipsolutions.net> <46CF11DE.8040403@lwfinger.net>
In-Reply-To: <46CF11DE.8040403@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708242321.54923.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 August 2007 19:14:06 Larry Finger wrote:
> Johannes Berg wrote:
> 
> The following hunk in wireless-dev/include/net/mac80211.h
> 
> @@ -200,13 +199,13 @@ struct ieee80211_tx_control {
>   						  * long retry value */
>   	u32 flags;			       /* tx control flags defined
>   						* above */
> +	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
> +				 * IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
>   	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
>   				 * This could be used when set_retry_limit
>   				 * is not implemented by the driver */
>   	u8 power_level;		/* per-packet transmit power level, in dBm */
>   	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
> -	s8 key_idx;		/* HW_KEY_IDX_INVALID = do not encrypt,
> -				 * other values: keyidx from hw->set_key() */
>   	u8 icv_len;		/* length of the ICV/MIC field in octets */
>   	u8 iv_len;		/* length of the IV field in octets */
>   	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
> 
> leads to a compiler warning "warning: comparison is always true due to limited range of data type" 
> for b43 and b43legacy on the fiollowing statement.
> 
>          int use_encryption = ((!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
>                                && (txctl->key_idx >= 0));
> 
> What did a negative key_idx mean before? How is that condition represented now, or is it safe to 
> drop the entire portion following the &&?

Simply drop the test for key_idx>=0.
It doesn't make sense to have two conditions in the tx control
to indicate use of encryption, so the negative key index was
removed and the DO_NOT_ENCRYPT flag is the one to test.
So you should probably remove the use_encryption variable, too,
and test the txctl->flags in the place where it's needed.

-- 
Greetings Michael.
