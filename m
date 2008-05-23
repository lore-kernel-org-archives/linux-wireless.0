Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:55885 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYEWQNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:13:47 -0400
Received: by fg-out-1718.google.com with SMTP id 19so433841fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:13:44 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] rt2x00: Reset antenna RSSI after switch
Date: Fri, 23 May 2008 18:13:56 +0200
References: <200805231811.38557.IvDoorn@gmail.com> <200805231812.00201.IvDoorn@gmail.com> <200805231812.18092.IvDoorn@gmail.com>
In-Reply-To: <200805231812.18092.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805231813.56554.IvDoorn@gmail.com> (sfid-20080523_181350_670148_8E610AD1)
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the antenna configuration has changed we should reset
the antenna RSSI value. Otherwise the value will be influenced
by the previous configuration quality which in turn will affect
the antenna diversity.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00config.c |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 41f352e..3b4944d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -328,6 +328,11 @@ static inline int rt2x00_get_link_ant_rssi(struct link *link)
 	return DEFAULT_RSSI;
 }
 
+static inline void rt2x00_reset_link_ant_rssi(struct link *link)
+{
+	link->ant.rssi_ant = 0;
+}
+
 static inline int rt2x00_get_link_ant_rssi_history(struct link *link,
 						   enum antenna ant)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index a9930a0..48608e8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -129,6 +129,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00dev->ops->lib->config(rt2x00dev, &libconf, CONFIG_UPDATE_ANTENNA);
 	rt2x00lib_reset_link_tuner(rt2x00dev);
+	rt2x00_reset_link_ant_rssi(&rt2x00dev->link);
 
 	rt2x00dev->link.ant.active.rx = libconf.ant.rx;
 	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
-- 
1.5.5.1

