Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:50337 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXJHUeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 16:34:11 -0400
Received: by wr-out-0506.google.com with SMTP id 36so693799wra
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 13:34:10 -0700 (PDT)
Date: Mon, 8 Oct 2007 16:34:15 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Taylor <mike.taylor@apprion.com>
Subject: Re: [PATCH 2/6] ath5k: Enable radar detection
Message-ID: <20071008203415.GA7633@pogo> (sfid-20071008_213422_166362_CCC4CF58)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo> <40f31dec0710070256y261199abw54e8e8dafab3ffb6@mail.gmail.com> <40f31dec0710070328r71d986bcm2b3fa78130052cb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0710070328r71d986bcm2b3fa78130052cb3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 07, 2007 at 03:28:12AM -0700, Nick Kossifidis wrote:
> Take a look here..
> http://thread.gmane.org/gmane.linux.drivers.madwifi.devel/4386/focus=4391

Of course I have tested this...

So far I haven't received one AR5K_INT_RXPHY interrupt yet. Mind you we
are already setting radar to 1 too -- we do this at the end of
ath_reset() with ath5k_hw_enable_radar_alert() -- so not sure what's
going on. I do live in front of a cemetery...

Anyway IMO we shouldn't handle radar detection but simply pass it down
to the upper layers, in this case mac80211. It seems for DFS this
would mean to force to change channels and blacklist the channel for
30 minutes. If this interrupt *does* prove to be very noisy we can 
simply disable the AR5K_RX_FILTER_RADARERR and even AR5K_RX_FILTER_PHYERR
later. Perhaps AR5K_RX_FILTER_RADARERR should be enabled during
configure_filter() through mac80211 to indicate when we do *need* DFS.
Right now AR5K_RX_FILTER_PHYERR is enabled when mac80211 tells us
about FIF_FCSFAIL | FIF_PLCPFAIL, we also keep the current 
hw settings on AR5K_PHY_ERR_FIL (AR5K_PHY_ERR_FIL_RADAR, 
AR5K_PHY_ERR_FIL_OFDM or AR5K_PHY_ERR_FIL_CCK).

Comments?

  Luis
