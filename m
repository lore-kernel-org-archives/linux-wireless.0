Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1ECO2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:28:53 -0400
Subject: RE: WARNING: at net/mac80211/wep.c:101
 ieee80211_wep_add_iv+0x52/0x150 [mac80211]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Powar <yogeshp@marvell.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"rossi.f@inwind.it" <rossi.f@inwind.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <7DDF37406E10F0438561DBB78326DF3902F35339F2@SC-VEXCH1.marvell.com>
References: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost>
	 ,<BANLkTim3-ve4BD6wghA=F-asEqJmcDip6Q@mail.gmail.com>
	 <7DDF37406E10F0438561DBB78326DF3902F35339F2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 16:28:49 +0200
Message-ID: <1304432929.3720.4.camel@jlt3.sipsolutions.net> (sfid-20110503_162856_132233_C901A0CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 07:25 -0700, Yogesh Powar wrote:
> >so may will this help? I don't know whether its a correct and with a
> >quick test the warning gets fixed.
> That should solve our problem with following explanation. 
> 
> The devices that require IV generation in software need tailroom reservation
> for ICVs used in TKIP or WEP encryptions.
> 
> Currently, decision to skip the tailroom reservation in the tx
> path was taken only on whether driver wants MMIC to be generated
> in software or not. Following patch appends IV generation check for such
> decisions.
> 
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index ca3c626..f3c4deb 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -102,7 +102,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  	if (!ret) {
>  		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
>  
> -		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
> +		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
> +				(key->conf.flags &
> +					IEEE80211_KEY_FLAG_GENERATE_IV)))
>  			key->local->crypto_tx_tailroom_needed_cnt--;

Can we have a bit nicer code style? :)

Also, need to submit a proper patch with S-o-b etc, and reported-by
rossi.

johannes

