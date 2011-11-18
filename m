Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1KRKit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:38:49 -0500
Subject: Re: [PATCHv2 1/2] mac80211: Add NoAck per WMM Queue Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111116_133151_852630_8E8411B2)
References: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20111116_133151_852630_8E8411B2)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 11:38:41 +0100
Message-ID: <1321612721.10266.32.camel@jlt3.sipsolutions.net> (sfid-20111118_113852_361136_A6313BB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 13:31 +0100, Simon Wunderlich wrote:

> @@ -154,7 +154,10 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
>  	 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
>  	 * to closest integer */
>  
> -	dur = ieee80211_frame_duration(local, 10, rate, erp,
> +	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +		dur = 0;
> +	else
> +		dur = ieee80211_frame_duration(local, 10, rate, erp,
>  				tx->sdata->vif.bss_conf.use_short_preamble);
>  
>  	if (next_frag_len) {

Come to think of it, I think this is wrong.

IEEE80211_TX_CTL_NO_ACK might also be set for frames that will get an
ACK, but for which we aren't going to wait for one. In those cases the
duration must still be set correctly to include the ACK because if it
isn't the ACK might conflict with another station's frame on the air.

johannes

