Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:26141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab0DGHGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 03:06:42 -0400
Received: by fg-out-1718.google.com with SMTP id d23so309691fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 00:06:41 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: use rt2800_config_channel_rt3x for rt2872
Date: Wed, 7 Apr 2010 09:06:34 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201004070906.34724.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2872 needs the same rf register setup as rt3070 and rt3090, hence
use rt2800_config_channel_rt3x instead of rt2800_config_channel_rt2x.
This change allows me to actually switch channels and hence scan all
configured channels on the RT305x SoC platform (which uses a rt2872)
here.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Tested-by: Luis Correia <luis.f.correia@gmail.com>
---

 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 326fce7..c23b8fe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -827,7 +827,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	u8 bbp;
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) ||
-	     rt2x00_rt(rt2x00dev, RT3090)) &&
+	     rt2x00_rt(rt2x00dev, RT3090) ||
+	     rt2x00_rt(rt2x00dev, RT2872)) &&
 	    (rt2x00_rf(rt2x00dev, RF2020) ||
 	     rt2x00_rf(rt2x00dev, RF3020) ||
 	     rt2x00_rf(rt2x00dev, RF3021) ||
-- 
1.6.4.2

