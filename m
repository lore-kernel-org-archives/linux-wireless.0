Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33322 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424458Ab2LFQgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:36:46 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, nbd@openwrt.org,
	jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Date: Thu,  6 Dec 2012 17:36:07 +0100
Message-Id: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121206_173651_773145_EE0C1AF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch(set) is the second iteration of the request for comments for
upcoming spectral scan feature. It adds spectral scan control and dump
features to debugfs. When the open questions regarding interpretation
are answered, I would like to build an interface to nl80211/mac80211.
Please see the open questions below, every hint is kindly appreciated. :)

This feature has been enabled for AR92xx and AR93xx based chipsets.
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

Changes to RFCv1:
 * remove nl80211/mac80211 stuff for now, to build a proper interface
   after intepretation/output stabilized
 * split spectral scan call into config, trigger and wait call, which can
   be called as desired (or depending on the mode)
 * use relay(fs) to stream spectral scan results (thanks for the hint Felix),
   this seems to be much cleaner - as long as we stay in debugfs

[1] http://packetmixer.de/sdl_spec_scan2.png
[2] https://github.com/simonwunderlich/FFT_eval
[3] http://www.wehavemorefun.de/fritzbox/Ath_spectral.ko#Symbole

Simon Wunderlich (1):
  ath9k: add spectral scan feature

 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   52 ++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   52 ++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |   36 +++++++
 drivers/net/wireless/ath/ath9k/debug.c      |  148 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h      |    5 +
 drivers/net/wireless/ath/ath9k/hw.h         |   26 +++++
 drivers/net/wireless/ath/ath9k/init.c       |    6 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    7 +-
 drivers/net/wireless/ath/ath9k/main.c       |   97 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c       |   28 +++++
 10 files changed, 455 insertions(+), 2 deletions(-)

-- 
1.7.10.4

