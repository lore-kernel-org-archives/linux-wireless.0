Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXLaHpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 02:45:43 -0500
Date: Mon, 31 Dec 2007 07:45:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20071231074536.GA26874@infradead.org> (sfid-20071231_074547_543349_AE4FFCA4)
References: <1198253375.16241.76.camel@johannes.berg> <20071230231120.GB16557@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071230231120.GB16557@uranus.ravnborg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 31, 2007 at 12:11:20AM +0100, Sam Ravnborg wrote:
> # If RC algorithm in build-in
> rate-rc-y := rc80211_pid_algo.o
> rate-rc-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
> 
> # If RC algorithm is modular
> rate-rc-m := rc80211_pid.o
> 
> mac80211-y += ieee80211.o key.o util.o event.o
> mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
> mac80211-$(CONFIG_NET_SCHED) += wme.o
> mac80211-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o
> mac80211-$(CONFIG_MAC80211_DEBUGFS) += debugfs_netdev.o debugfs_key.o
> 
> # And this part select the rate algorithm
> mac80211-$(CONFIG_MAC80211_SIMPLE) += rc80211_simple.o
> mac80211-$(CONFIG_MAC80211_RC_PID) += $(rate-rc-$(CONFIG_MAC80211_RC_PID))
> 
> # Modular rate algorithm was assigned to mac80211-m - make it a separate module
> obj-m += $(mac80211-m)

Why don't we just build the rate control algorithms entirely separate
useing obj-$(FOO) ?  If they're modular that lets them be their own
module, and if they're built-in they'll still go into built-in.o.

But why do we want to have rc80211_pid.o only if modular and
rc80211_pid_algo.o only if built-in?  This seems like a complete mess
to me.

