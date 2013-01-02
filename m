Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:45:12 -0500
Message-ID: <1357134319.9839.32.camel@jlt4.sipsolutions.net> (sfid-20130102_144516_467711_DC62A328)
Subject: Re: [PATCHv5 6/8] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:45:19 +0100
In-Reply-To: <1355407113-27006-7-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-7-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> Add NL80211_CMD_AP_CH_SWITCH command which
> triggers an AP channel switch process.
> 
> Usermode notified about channel switch complete
> event with NL80211_CMD_CH_SWITCH_NOTIFY.
> 
> Usermode (hostapd) is responsible to update the
> channel switch announcement IE in the beacon
> prior and after the channel switch operation.

So ... hostapd is also responsible for counting down the "count"? This
didn't seem to be the case last I asked?

Then why is it responsible for creating the CSA IE? Should that be in
the kernel maybe? Or the IE be given to this command?

And then maybe the post-switch beacon IEs should be given to the command
as well, to avoid races as well as making it easier to manage this with
smarter firmware (say full-MAC drivers)?

Also, we already have an event to notify of an AP channel change, maybe
that should be used? If not, why not?

johannes

