Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:59907 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab3EGVAd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 17:00:33 -0400
Date: Tue, 7 May 2013 23:00:28 +0200
From: Jakub Kicinski <moorray@wp.pl>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3.10-rc] wireless: rt2x00: rt2800: fix
 hardware antenna diversity for RT5370G
Message-ID: <20130507230028.6f13df5c@north> (sfid-20130507_230037_619074_17A2957B)
In-Reply-To: <1367957010-9496-1-git-send-email-xose.vazquez@gmail.com>
References: <1367957010-9496-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi...

seems like you have not addressed this patch directly to John, which I
think you should do [1].

[1] http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches

On Tue,  7 May 2013 22:03:30 +0200, Xose Vazquez Perez wrote:
>RT5370G has hardware RX antenna diversity like RT5390R.
>
>based on 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

Note that this is not the latest vendor driver for RT5572, hw antenna
diversity didn't change though, so the logic seems correct.

>Cc: Ivo van Doorn <IvDoorn@gmail.com>
>Cc: Gertjan van Wingerde <gwingerde@gmail.com>
>Cc: Helmut Schaa <helmut.schaa@googlemail.com>
>Cc: John W. Linville <linville@tuxdriver.com>
>Cc: users@rt2x00.serialmonkey.com
>Cc: linux-wireless@vger.kernel.org
>Tested-by: wnewbie72@gmail.com
>Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>---
> drivers/net/wireless/rt2x00/rt2800.h    | 3 ++-
> drivers/net/wireless/rt2x00/rt2800lib.c | 8 +++++---
> 2 files changed, 7 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
>index a7630d5..6e84eee 100644
>--- a/drivers/net/wireless/rt2x00/rt2800.h
>+++ b/drivers/net/wireless/rt2x00/rt2800.h
>@@ -89,7 +89,8 @@
> #define REV_RT3090E			0x0211
> #define REV_RT3390E			0x0211
> #define REV_RT5390F			0x0502
>-#define REV_RT5390R			0x1502
>+#define REV_RT5370G			0x0503 /* hardware RX antenna diversity */
>+#define REV_RT5390R			0x1502 /* hardware RX antenna diversity */

Line > 80 chars. hardware -> hw should be enough?

> #define REV_RT5592C			0x0221
> 
> #define DEFAULT_RSSI_OFFSET		120
>diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>index b52d70c..e202ec7 100644
>--- a/drivers/net/wireless/rt2x00/rt2800lib.c
>+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>@@ -4311,8 +4311,9 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
> 			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
> 		}
> 
>-		/* This chip has hardware antenna diversity*/
>-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
>+		/* These chips have hardware RX antenna diversity */
>+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
>+			rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {

Indentation of conditions seems wrong...  Please run 
checkpatch.pl --strict on your changes.

Thanks for sending the patch! (:

  -- Kuba
