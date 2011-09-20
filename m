Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1ITH1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 03:27:10 -0400
Subject: Re: [RFC v2] mac80211: make use of supported rates for probe
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1316499794-5979-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316499794-5979-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 09:27:03 +0200
Message-ID: <1316503623.3953.4.camel@jlt3.sipsolutions.net> (sfid-20110920_092718_637755_DEF6541C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-20 at 11:53 +0530, Rajkumar Manoharan wrote:
> The supported rates on scan trigger helps to send the probe
> request frames on non-11b rates for p2p. For the drivers that
> have rate control on hw like ath9k_htc, this approch does not
> work. So for those drivers wpa_supplicant should set tx rate
> mask to disable 11b rates.

I don't think using the advertised supported rates for actual rate
control is the right approach. I'd much rather have a separate
attribute. Also parsing mgmt-TX frames is plain ugly, and won't work at
all since those frames don't necessarily advertise rates themselves.

Finally, I think setting the global rate control stuff will be bound to
have a whole bunch of ugly races with actual TX -- and remember that
"wlan0" might be connected to an 11b AP at the same time!!

I really think this needs a different approach:
 * use a new attribute for the TX rate for scan/mgmt-tx
 * use per-frame rate control
 * figure out separately how ath9k-htc should work

johannes


