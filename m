Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423481Ab3FUUs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 16:48:59 -0400
Message-ID: <1371847733.8936.6.camel@jlt4.sipsolutions.net> (sfid-20130621_224902_325872_600F1D5B)
Subject: Re: [PATCH] mac80211: fix the kernel panic on ath_tx_aggr_wakeup on
 mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 21 Jun 2013 22:48:53 +0200
In-Reply-To: <1371803215-2685-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130621_103004_439845_20E28F3A)
References: <1371803215-2685-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130621_103004_439845_20E28F3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-21 at 16:26 +0800, Chun-Yeow Yeoh wrote:
> The is to fix the kernel panic happens if user space inserts the mesh
> STA and not proceed with the SAE and AMPE, and later the same mesh STA
> is detected again. The sta_state of the mesh STA remains at
> IEEE80211_STA_NONE and if the ieee80211_sta_ps_deliver_wakeup
> is called and subsequently the ath_tx_aggr_wakeup, the kernel panic due
> to ath_tx_node_init is not called before to initialize the require data
> structures.

I'd like to have a less ath9k-centric description, and particularly
subject, please.

> Thomas Perdersen

I think you misspelled that :)

> also mentioned that this patch has fixed the
> bad sta magic warning in mac80211_hwsim_set_tim() when applied to
> mac80211-next/master

"The bad sta magic warning"? That sounds like everyone should know about
that, but I don't think I do, or maybe it just slipped my mind?

johannes

