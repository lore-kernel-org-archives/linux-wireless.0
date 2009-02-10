Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48246 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZBJOPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 09:15:53 -0500
Date: Tue, 10 Feb 2009 09:10:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arnau Roig <arnau60@casal.upc.edu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: txpower and frequency settings: concept guidance needed
Message-ID: <20090210141045.GA3534@tuxdriver.com> (sfid-20090210_151557_400761_EF62E7DF)
References: <20090205164522.GA5580@purple>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090205164522.GA5580@purple>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 05:45:22PM +0100, Arnau Roig wrote:
> Hello to everybody.
> 
> I'm new in kernel development and in wireless networking also.
> I've read most of the documentation availible in wireless.kernel.org
> and, to be honest it's still not clear to me what are the uses of the
> mac80211, cfg80211 or nl80211.

mac80211 implements the higher level MAC layer function of the
ieee802.11 specification for wireless local area networking.
cfg80211 provides the back-end of a configuration API for wireless
LAN devices -- it is intended to supercede the Wireless Extensions
API at the device layer.  nl80211 is a front-end to cfg80211 that
is based on netlink sockets.  This provides a user-level API for
wireless configuration.

> I'm using a 2.6.24 kernel, compat-wireless-2.6-old (compat-release
> v4.5-g2badec7) and ath5k driver (v0.5.0).
> 
> What I want to do is a userspace application that has to modify the
> frequency channel and the tx_power of the wireless device depending on
> several network statistics. Please, where do I have to start looking?
> 
> Is the struct ieee80211_conf, declared in mac80211.h what I need for
> changing the current working channel and tx_power?
> Can I read network statistics with get_station, declared in the struct
> cfg80211_ops in cfg80211.h? Or the way to do it is using
> @NL80211_CMD_GET_WIPHY in nl80211_commands?

You may want to take a look at the sources for the iw utility.
This should illustrate how to drive the nl80211 API.

> Thank you for your time.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
