Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35410 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308AbZCCRYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:24:44 -0500
Message-Id: <20090303172325.437810138@atheros.com> (sfid-20090303_182447_252437_EABEC164)
Date: Tue, 03 Mar 2009 19:23:25 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/15] ath9k: Virtual interfaces and radios
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches brings in an initial step in adding support for
multiple virtual interfaces into ath9k both at the multi-vif (for
single channel only) and multi-wiphy (virtual radios that can be used
with multiple channels). The patches are on top of the current
wireless-testing tree, the beacon changes from Sujith and a setkey
patch from earlier today.

The first two patches clean up the multi-vif code and prepare the
driver for use of multiple MAC addresses. The third patch starts the
work on the concept of a virtual wiphy/radio (i.e., ath9k will be able
to register multiple "radios" with mac80211, but without mac80211
having to know about multi-channel operations). The fourth patch adds
support for multiple secondary wiphys. The patches 5-13 are completing
and improving the virtual interface operations.

The 14th patch file brings in a simple channel scheduler that is
enough for initial tests, but will be optimized in the future to take
into account various corner cases and different states of each virtual
radio to time the channel changes better.

The final patch in this series adds a debugfs interface that makes it
possible to control the virtual radios (e.g., add a new "radio"). For
now, this is enough to allow initial testing and experiments with the
new virtual wiphy concept. In the future, more official interface
(e.g., an nl80211 command passed through mac80211) is likely to remove
need for a debugfs interface.


Lot of the code here is still quite experimental, but taken into
account how many areas this touches, it would be helpful to get at
least parts of this merged in. I'm not aware of any regressions for
single-interface operations.

There are still some known limitations for the multi-interface
operations and one should be aware of these when running experiments
with the code. These will be worked on in the future to avoid the
extra complexity or compromises needed in the initial version.

Key cache configuration does not yet handle all combinations of
security policies in virtual interfaces. Consequently, the recommended
starting point is to use software crypto when using multiple
wiphys/vifs, i.e., use nohwcrypt=1 module parameter.

There is currently support for only a single beaconing interface,
i.e., not more than one AP wiphy can be added at a time. There is no
such limitation for station interfaces, i.e., arbitrary number of
virtual station wiphys can be added and used on arbitrary channels.
Though, the simple channel scheduler will start showing up its
simplicity with increased latency if there the wiphys end up on large
number of different channels.

Quick steps to start experiments:

modprobe ath9k nohwcrypt=1
# make sure debugfs is mounted somewhere (replace '/debug' in the
# command below with wherever the root directory is)

# wlan0 can now be used, e.g., with wpa_supplicant

echo add > /debug/ath9k/phy0/wiphy

# wlan1 can now be used, e.g., with wpa_supplicant

echo add > /debug/ath9k/phy0/wiphy

# wlan2 can now be used, e.g., with wpa_supplicant

and so on.. In theory, all the virtual wiphy interfaces could be used
as if they are real radios (run wpa_supplicant, hostapd, use iwconfig,
etc.).

When using virtual wiphys, the APs that the virtual interfaces are
associated with do not need to be on the same channel. One of the
wiphys could also be used with hostapd to bring up an AP. However, it
should be noted that most client implementation do not exactly like
the AP disappearing all the time, so using a virtual station interface
on another channel at the same time may not be that good of an idea
for most use cases now. This will hopefully improve somewhat with
future optimizations.


It would be useful to hear what others think about this sort of
functionality and how this should be integrated with Linux, including
the user space interface, applications managing the virtual interface
functionality, and user interface that the end users would see. This
is still quite an early step in the progress, but the goal here is to
get this functionality into mature state and provide something that
makes it easier to use wireless LAN in general for connecting devices
in various scenarios. All feedback would be welcome!

-- 
Jouni Malinen                                            PGP id EFC895FA
