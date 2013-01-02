Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:47:36 -0500
Message-ID: <1357134469.9839.35.camel@jlt4.sipsolutions.net> (sfid-20130102_144739_161111_1D330CC7)
Subject: Re: [PATCHv5 7/8] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:47:49 +0100
In-Reply-To: <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:

> +	mutex_lock(&local->mtx);
> +	if (local->ap_cs_chandef.chan->flags & IEEE80211_CHAN_RADAR) {
> +		sdata_info(sdata, "changing to DFS channel\n");
> +		/* when changing to a DFS channel, stop AP. Userspace must
> +		 * restart AP or do start radar detection first.
> +		 */
> +		stop_ap = true;

I don't see any value in this. You might just as well simply forbid
requesting a channel change to a DFS channel, hostapd could then stop
instead of doing the switch.

> +	} else {
> +		/* update the device channel directly */
> +		sdata_info(sdata, "changing to non-DFS channel\n");
> +
> +		/* TODO: _oper_channel is deprecated ... use
> +		 * vif_release/use_channel instead? In this case, we must make
> +		 * sure that interface is down first ...
> +		 */

Well, most likely need to modify the existing channel context instead.
However, that's tricky, and what if there are other interfaces, what
happens to those?

johannes


