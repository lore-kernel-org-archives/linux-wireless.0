Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48035 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbaHHMlf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 08:41:35 -0400
From: Avinash Patil <patila@marvell.com>
To: Hans Wennborg <hans@hanshq.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Aug 2014 05:40:16 -0700
Subject: RE: [PATCH 07/15] mwifiex: fix decimal printf format specifiers
 prefixed with 0x
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147BD8@SC-VEXCH2.marvell.com> (sfid-20140808_144152_883325_D034FD2E)
References: <1407300175-32635-1-git-send-email-hans@hanshq.net>
In-Reply-To: <1407300175-32635-1-git-send-email-hans@hanshq.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

>The prefix suggests the number should be printed in hex, so use the %x specifier to do that.

Acked-by: Avinash Patil <patila@marvell.com>

Thanks,
Avinash.

________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Hans Wennborg [hans@hanshq.net]
Sent: Wednesday, August 06, 2014 10:12 AM
To: Amitkumar Karwar; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Hans Wennborg
Subject: [PATCH 07/15] mwifiex: fix decimal printf format specifiers prefixed with 0x

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e2e6bf1..2856f0e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -246,7 +246,7 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
        }

        if (priv->roc_cfg.cookie) {
-               wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llu\n",
+               wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llx\n",
                          priv->roc_cfg.cookie);
                return -EBUSY;
        }
--
2.0.0.526.g5318336

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
