Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39332 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508AbXHXROI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 13:14:08 -0400
Message-ID: <46CF11DE.8040403@lwfinger.net>
Date: Fri, 24 Aug 2007 12:14:06 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
References: <20070824122705.549190000@sipsolutions.net> <20070824122905.350213000@sipsolutions.net>
In-Reply-To: <20070824122905.350213000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

The following hunk in wireless-dev/include/net/mac80211.h

@@ -200,13 +199,13 @@ struct ieee80211_tx_control {
  						  * long retry value */
  	u32 flags;			       /* tx control flags defined
  						* above */
+	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
+				 * IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
  	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
  				 * This could be used when set_retry_limit
  				 * is not implemented by the driver */
  	u8 power_level;		/* per-packet transmit power level, in dBm */
  	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
-	s8 key_idx;		/* HW_KEY_IDX_INVALID = do not encrypt,
-				 * other values: keyidx from hw->set_key() */
  	u8 icv_len;		/* length of the ICV/MIC field in octets */
  	u8 iv_len;		/* length of the IV field in octets */
  	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */

leads to a compiler warning "warning: comparison is always true due to limited range of data type" 
for b43 and b43legacy on the fiollowing statement.

         int use_encryption = ((!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
                               && (txctl->key_idx >= 0));

What did a negative key_idx mean before? How is that condition represented now, or is it safe to 
drop the entire portion following the &&?

Thanks,

Larry
