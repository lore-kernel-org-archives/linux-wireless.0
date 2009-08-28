Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:48665 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbZH1K1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:27:42 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 00/10] complete cfg80211 conversion
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:27:42 +0300
Message-ID: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset completes cfg80211 conversion of rndis_wlan. Tested connect with 
wext-compat: WPA/WPA2-PSK, WEP work with station mode. Adhoc work with
and without WEP. Throught nl80211 pretty much untested.

Should rndis_wlan find out key_id for cfg80211_michael_mic_failure, patch 
currently uses -1?

---

Jussi Kivilinna (10):
      rndis_wlan: use cfg80211_wext_handler
      rndis_wlan: disable IWEVPMKIDCAND wireless event
      rndis_wlan: convert mic failure wireless event to cfg80211
      rndis_wlan: remove unneeded SIOCSIWCOMMIT
      rndis_wlan: rename wireless stats worker to device poller
      rndis_wlan: add cfg80211 dump_station
      rndis_wlan: add cfg80211 get_station
      rndis_wlan: add cfg80211 key handling
      rndis_wlan: add cfg80211 set_channel
      rndis_wlan: add cfg80211 connect, disconnect, join_ibss and leave_ibss


 drivers/net/wireless/rndis_wlan.c | 1299 ++++++++++++++++---------------------
 1 files changed, 571 insertions(+), 728 deletions(-)

-- 
