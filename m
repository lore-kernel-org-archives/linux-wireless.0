Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936177Ab3DHO3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 10:29:16 -0400
Message-ID: <1365431343.25475.15.camel@jlt4.sipsolutions.net> (sfid-20130408_162925_432779_AB3234D3)
Subject: Re: [PATCHv2] mac80211: fix recalc_radar hwconf sync problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 08 Apr 2013 16:29:03 +0200
In-Reply-To: <1365422997-15728-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130408_141012_232911_870275CB)
References: <1365165364.8515.24.camel@jlt4.sipsolutions.net>
	 <1365422997-15728-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130408_141012_232911_870275CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 14:09 +0200, Simon Wunderlich wrote:

> @@ -118,6 +137,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
>  
>  	if (!local->use_chanctx) {
>  		local->_oper_channel_type = NL80211_CHAN_NO_HT;
> +		local->hw.conf.radar_enabled = false;

That should probably get a comment (and an assertion?) that radar
detection is only possible with a single channel context, so when that
is freed radar detection can no longer be turned on.

Also, the patch doesn't apply on mac80211-next.

johannes

