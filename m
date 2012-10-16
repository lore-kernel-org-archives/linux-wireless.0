Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2JPTF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:05:57 -0400
Message-ID: <1350414390.10177.16.camel@jlt4.sipsolutions.net> (sfid-20121016_210600_737539_66CF0429)
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 16 Oct 2012 21:06:30 +0200
In-Reply-To: <1350226137-13704-6-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-6-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
> Add NL80211_CMD_AP_CH_SWITCH command which
> triggers an AP channel switch process.
> 
> Usermode notified about channel switch complete
> event with NL80211_CMD_CH_SWITCH_NOTIFY.
> 
> Usermode (hostapd) is responsible to update the
> channel switch announcement IE in the beacon
> prior and after the channel switch operation.

Hmm, does that really work? I mean, it can do the update when the event
comes in, but is that fast enough, or should it give us the new beacon
already when programming the switching?

johannes

