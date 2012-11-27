Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33987 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2K0TBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:01:51 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
Date: Tue, 27 Nov 2012 20:01:21 +0100
Message-Id: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_200156_359902_9B519F2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is a first request for comments for the upcoming spectral
scan feature. It adds a new attribute to nl80211 to ask for a spectral
scan while scanning, because we cycle through the channels anyway at
this time. If enabled by the driver, spectral scan results will be
collected. This feature has been enabled for AR92xx and AR93xx based
chipsets. As the FFT samples are very hardware dependent, they are only
provided via a debugfs file for further evaluation.

We've also written a visual evaluation program for these samples (see
screenshot [1] and sourcecode [2]).

Many details are not known due to the fact that I don't have access to
Atheros specifications and details. Many things are done by guessing
and might be wrong. I'm therefore requesting help from Qualcomm/Atheros
guys to confirm or correct my findings. Apart from that, after
discussion I think we could integrate this patchset to allow other
people to work on this as well, even if it is experimental now.

Questions from my end:
 1. There are many TODOs/Comments in the patches regarding details,
    please answer if you can. :)
 2. The output format is very Atheros-dependent. If my finding that 
    byte n-4 is some kind of offset/exponent, I'd integrate this in
    the debugfs output as well
 3. The data length varies pretty much, there might be some false
    positives/PHY errors which are not FFT data - what should be
    the correct length?
 4. Is there any special handling for HT40? At least the proprietary
    driver symbol names suggest so [3]

(Possible) further work:
 1. Integrate this patchset, confirm/correct findings
 2. If anyone would like: Atheros proprietary driver seems to
    support some kind of classification [3] (is this microwave? cordless
    phone? whatever?)
 3. If other devices also offer spectral scan support: define a
    common interface to use it (not debugfs).


[1] http://packetmixer.de/sdl_spec_scan2.png
[2] https://github.com/simonwunderlich/FFT_eval
[3] http://www.wehavemorefun.de/fritzbox/Ath_spectral.ko#Symbole

Simon Wunderlich (3):
  nl80211: add spec scan flag
  mac80211: add spectral_scan function, hook it up in scanning
  ath9k: add spectral scan feature

 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   37 +++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   37 +++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |   12 ++++
 drivers/net/wireless/ath/ath9k/debug.c      |   79 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
 drivers/net/wireless/ath/ath9k/init.c       |   13 +++++
 drivers/net/wireless/ath/ath9k/mac.h        |    7 ++-
 drivers/net/wireless/ath/ath9k/main.c       |   29 ++++++++++
 drivers/net/wireless/ath/ath9k/recv.c       |   34 ++++++++++++
 include/net/cfg80211.h                      |    2 +
 include/net/mac80211.h                      |    6 ++
 include/uapi/linux/nl80211.h                |    5 ++
 net/mac80211/driver-ops.h                   |   10 ++++
 net/mac80211/scan.c                         |    3 +
 net/mac80211/trace.h                        |    5 ++
 net/wireless/nl80211.c                      |    3 +
 16 files changed, 284 insertions(+), 2 deletions(-)

-- 
1.7.10.4

