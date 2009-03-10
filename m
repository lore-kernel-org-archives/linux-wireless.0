Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40984 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZCJK1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 06:27:12 -0400
Date: Tue, 10 Mar 2009 12:27:30 +0200
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 0/3] ath5k: Tx Power support
Message-ID: <20090310102730.GA3341@makis> (sfid-20090310_112716_185088_237A633C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 3 pathces add support for Tx power baseband calibration and some
basic Tx power limits. Initialy i thought that without these settings hw
transmited on the lowest possible power, it turns out that hw transmits
all the way up and that's why we have corrupted spectral mask and can't get 
more than 18Mb rates on some cards. With these patches we calibrate the
baseband so that it doesn't transmit above the power calibrated on EEPROM and 
it transmits the same power on all channels (pre amplifiers etc have different
behaviour on different frequencies so we have to pass a calibration curve on
hw for each channel by using infos found on EEPROM). We then further limit
that power for each rate (because OFDM rates need some special handling +
when we are on g mode CCK rates have different peak to average ratio and also
need special handling) so that we can have the maximum power supported by
hardware. Then we should apply regultory limits (i already tried to handle
some CTL tests, we need some more work on that) so that we can have the maximum
tx power supported by the driver and the last thing is to limit based on user
selection (if user asks for a tx power below that max).

Note that this code is not a port of HAL's source but i tried to rewrite most of
this stuff, i wanted to better understand what's going on and i also wanted to
have a much cleaner code that makes sense (there are lots of things that don't
make sense on HAL's source and without propper documentation it took me some
time to figure out what's going on + EEPROM docs were misleading). On RF2413+
output is the same with MadWiFi (i started with Felix's work with a few cleanups),
on RF5111/RF5112 output differs in some cases (check out the curves on
http://www.kernel.org/pub/linux/kernel/people/mickflemm/txp_curves/ so that you
can compare). I believe that my approach is better (it's certainly cleaner) but
time will show. Also note that these curves should be monotonicaly increasing, as
you can see HAL produces some anomalies on the curves (later i found out that HAL
actually "hardcodes" CCK-OFDM power difference on the channel power table (that
has nothing to do with rates) !!! I believe a better approach for chips that don't
support auto tx power adjustment (they lack a register) is to have a power offset
that can be used by the driver when we try out a CCK rate (this offset is 0 on cards
that support auto tx power adjustment).

Also note that i hardcoded a power limit of 12.5dB until we are done with regulatory
stuff, it's still not low enough to cover all cases but it'll help us on debuging and
keep users happy.

For now TPC is not supported but there's work in progress...

P.S. I usualy put lots of comments on my code, if some of these are obvious feel free
to clean them up.
