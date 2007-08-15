Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4075 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbXHOBGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 21:06:33 -0400
Date: Tue, 14 Aug 2007 20:34:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Please pull 'upstream-davem' branch of wireless-2.6
Message-ID: <20070815003410.GJ7198@tuxdriver.com>
References: <20070815003234.GI7198@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070815003234.GI7198@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More items intended for 2.6.24, based-off the preceding fixes-davem
request.

Individual patches available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-davem

Thanks!

John

---

The following changes since commit b9bf1e60a294fc7795d5198f94a917290e52865b:
  John W. Linville (1):
        mac80211: probe for hidden SSIDs in pre-auth scan

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-davem

Johannes Berg (1):
      radiotap parser: accept all other fields

Larry Finger (1):
      mac80211: Add SIOCGIWTXPOWER routine

 net/mac80211/ieee80211_ioctl.c |   16 +++++++++++++++-
 net/wireless/radiotap.c        |    6 +++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index e7904db..f459d89 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -798,6 +798,20 @@ static int ieee80211_ioctl_giwrate(struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *data, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	data->txpower.fixed = 1;
+	data->txpower.disabled = !(local->hw.conf.radio_enabled);
+	data->txpower.value = local->hw.conf.power_level;
+	data->txpower.flags = IW_TXPOW_DBM;
+
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -1580,7 +1594,7 @@ static const iw_handler ieee80211_handler[] =
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
 	(iw_handler) ieee80211_ioctl_giwfrag,		/* SIOCGIWFRAG */
 	(iw_handler) NULL,				/* SIOCSIWTXPOW */
-	(iw_handler) NULL,				/* SIOCGIWTXPOW */
+	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
 	(iw_handler) ieee80211_ioctl_siwretry,		/* SIOCSIWRETRY */
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 68c11d0..28fbd0b 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -161,7 +161,11 @@ int ieee80211_radiotap_iterator_next(
 		[IEEE80211_RADIOTAP_DBM_TX_POWER] = 0x11,
 		[IEEE80211_RADIOTAP_ANTENNA] = 0x11,
 		[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = 0x11,
-		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11
+		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11,
+		[IEEE80211_RADIOTAP_RX_FLAGS] = 0x22,
+		[IEEE80211_RADIOTAP_TX_FLAGS] = 0x22,
+		[IEEE80211_RADIOTAP_RTS_RETRIES] = 0x11,
+		[IEEE80211_RADIOTAP_DATA_RETRIES] = 0x11,
 		/*
 		 * add more here as they are defined in
 		 * include/net/ieee80211_radiotap.h
-- 
John W. Linville
linville@tuxdriver.com
