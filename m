Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:39974 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0KAEjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 00:39:41 -0400
Message-ID: <4CCE4479.1010400@mandriva.com.br>
Date: Mon, 01 Nov 2010 02:39:21 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
MIME-Version: 1.0
To: seno <senada@t-online.de>
CC: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	hintak.leung@gmail.com
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org> <4CC71CFF.8050004@lwfinger.net> <20101026185341.GA4608@barata.holoscopio.com> <20101028191305.2960c83b@gotham.conectiva> <loom.20101029T010426-834@post.gmane.org> <20101029135449.GB3768@barata.holoscopio.com> <loom.20101030T001241-932@post.gmane.org>
In-Reply-To: <loom.20101030T001241-932@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------080702070207010401040508"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080702070207010401040508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 29-10-2010 20:31, seno wrote:
> Thadeu Lima de Souza Cascardo<cascardo@...>  writes:
>
>> Perhaps, the problem is related to using compat-wireless. Have you tried
>> using the module without the patch, using this same compat-wireless
>> version in the same linux version you are using?
>
> Cascardo, you were right :-) Your patch did not cause the problem.
> I get those errors also with an unpatched compat-wireless-2010-10-25 driver.
>
> With a patched compat-wireless-2.6.33.6 there occur no errors.
>
> The router reports a better signal quality compared to the unpatched module, but
> I can not really recognize a better throughput - usually still max 1 mbit @ 10
> meters.
>
> I noticed that the connection is fast for a short time after booting (10 mbit @
> 10 meters), but a few seconds after the download on speedtest.net started
> (meaning the network gets under load), speed drops to 1 mbit and never recovers
> to faster speed again; somehow like an "unrecoverable fallback mechanism"...?

I have seen the throughput issue, but on my tests it wasn't so bad. 
Usually max I got on testing was 24M while close to the AP, and it goes 
into lower speeds when going more far away, but takes a good number of 
meters to go down to 1M.

Anyway of course something isn't right. I started reviewing realtek GPL 
code (their ieee80211 drivers) and code in rtl8187 in the kernel, doing 
many tests and verifying things, trying to understand and check some 
register writes etc. (hard with missing doc or other info).

I did some cleanups, and discovered two bad things in the code. After 
the fixes, I can get normal rates (up to 54M close to the AP) without 
issue. I'll soon post the patch series to be included in 
wireless-testing, for now just for test I attach them to be easier (hope 
it isn't stripped by ML, and yes they start on 0003 through 0011 :P), 
check if with it you get better results.

The patches that matter (shown by my tests) are:
0010-rtl8187-remove-uneeded-setting-of-anaparam-write.patch
0011-rtl8187-restore-anaparam-registers-after-reset-with-.patch

but they depend on some previous patches in the series (better apply 
all), and I diffed on a tree with Thadeu's patch applied already. There 
is more cleanups and checking to do, but I probably will submit this 
initial series and later come with more ones, as with this initial 
series the throughput issue should be solved.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
[]'s
Herton


--------------080702070207010401040508
Content-Type: text/plain;
 name="0003-rtl8187-remove-redundant-initialization-of-ARFR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-rtl8187-remove-redundant-initialization-of-ARFR.patch"

>From b7999be35d6a0b687ee55fd9af6d4dde07ce83a7 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Fri, 29 Oct 2010 17:58:31 -0200
Subject: [PATCH] rtl8187: remove redundant initialization of ARFR

This removes redundant write to Auto Rate Fallback Register on RTL8187B.
The same value was being written to it on the same function. Avoid this
removing the duplicate initialization on rtl8187b_reg_table, and also
add comment for this write (information from Realtek source).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 6e26149..3dbf305 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -712,10 +712,9 @@ static const u8 rtl8187b_reg_table[][3] = {
 
 	{0x58, 0x4B, 1}, {0x59, 0x00, 1}, {0x5A, 0x4B, 1}, {0x5B, 0x00, 1},
 	{0x60, 0x4B, 1}, {0x61, 0x09, 1}, {0x62, 0x4B, 1}, {0x63, 0x09, 1},
-	{0xCE, 0x0F, 1}, {0xCF, 0x00, 1}, {0xE0, 0xFF, 1}, {0xE1, 0x0F, 1},
-	{0xE2, 0x00, 1}, {0xF0, 0x4E, 1}, {0xF1, 0x01, 1}, {0xF2, 0x02, 1},
-	{0xF3, 0x03, 1}, {0xF4, 0x04, 1}, {0xF5, 0x05, 1}, {0xF6, 0x06, 1},
-	{0xF7, 0x07, 1}, {0xF8, 0x08, 1},
+	{0xCE, 0x0F, 1}, {0xCF, 0x00, 1}, {0xF0, 0x4E, 1}, {0xF1, 0x01, 1},
+	{0xF2, 0x02, 1}, {0xF3, 0x03, 1}, {0xF4, 0x04, 1}, {0xF5, 0x05, 1},
+	{0xF6, 0x06, 1}, {0xF7, 0x07, 1}, {0xF8, 0x08, 1},
 
 	{0x4E, 0x00, 2}, {0x0C, 0x04, 2}, {0x21, 0x61, 2}, {0x22, 0x68, 2},
 	{0x23, 0x6F, 2}, {0x24, 0x76, 2}, {0x25, 0x7D, 2}, {0x26, 0x84, 2},
@@ -776,7 +775,9 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
+	/* Auto Rate Fallback Register (ARFR): 1M-54M setting */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFFE2, 0x00, 1);
 
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0004-rtl8187-remove-setting-of-beacon-atim-registers-from.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-rtl8187-remove-setting-of-beacon-atim-registers-from.pa";
 filename*1="tch"

>From e33c4770e112b2c67bc4d1572426693ac6b1e7ce Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Fri, 29 Oct 2010 15:41:02 -0200
Subject: [PATCH] rtl8187: remove setting of beacon/atim registers from initialization

On 8187B path, we set a initial value for beacon interval and atim
window on initialization. But this isn't needed, since same setup is
done on rtl8187_config.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 0c04654..e5f1269 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -776,8 +776,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
-	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
-	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFD4, 0xFFFF, 1);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0005-rtl8187-fix-wrong-register-initialization-in-8187B.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-rtl8187-fix-wrong-register-initialization-in-8187B.patc";
 filename*1="h"

>From 15bf87f344f5ca11c5e1f43bde35805e505f79c1 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Fri, 29 Oct 2010 19:46:02 -0200
Subject: [PATCH] rtl8187: fix wrong register initialization in 8187B

We were using wrong address for BRSR (Basic Rate Set Register) while
initializing its value, comparing with Realtek sources, for 8187B case.

Also, the same register is initialized in rtl8187b_reg_table, so remove
the duplicate initialization from the table.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 30c2120..b9ce2a8 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -725,11 +725,11 @@ static const u8 rtl8187b_reg_table[][3] = {
 	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2}, {0x72, 0x56, 2},
 	{0x73, 0x9A, 2},
 
-	{0x34, 0xF0, 0}, {0x35, 0x0F, 0}, {0x5B, 0x40, 0}, {0x84, 0x88, 0},
-	{0x85, 0x24, 0}, {0x88, 0x54, 0}, {0x8B, 0xB8, 0}, {0x8C, 0x07, 0},
-	{0x8D, 0x00, 0}, {0x94, 0x1B, 0}, {0x95, 0x12, 0}, {0x96, 0x00, 0},
-	{0x97, 0x06, 0}, {0x9D, 0x1A, 0}, {0x9F, 0x10, 0}, {0xB4, 0x22, 0},
-	{0xBE, 0x80, 0}, {0xDB, 0x00, 0}, {0xEE, 0x00, 0}, {0x4C, 0x00, 2},
+	{0x5B, 0x40, 0}, {0x84, 0x88, 0}, {0x85, 0x24, 0}, {0x88, 0x54, 0},
+	{0x8B, 0xB8, 0}, {0x8C, 0x07, 0}, {0x8D, 0x00, 0}, {0x94, 0x1B, 0},
+	{0x95, 0x12, 0}, {0x96, 0x00, 0}, {0x97, 0x06, 0}, {0x9D, 0x1A, 0},
+	{0x9F, 0x10, 0}, {0xB4, 0x22, 0}, {0xBE, 0x80, 0}, {0xDB, 0x00, 0},
+	{0xEE, 0x00, 0}, {0x4C, 0x00, 2},
 
 	{0x9F, 0x00, 3}, {0x8C, 0x01, 0}, {0x8D, 0x10, 0}, {0x8E, 0x08, 0},
 	{0x8F, 0x00, 0}
@@ -770,7 +770,11 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	if (res)
 		return res;
 
-	rtl818x_iowrite16(priv, (__le16 *)0xFF2D, 0x0FFF);
+	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
+	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
+	 * one of the 12 rates, all are enabled */
+	rtl818x_iowrite16(priv, (__le16 *)0xFF34, 0x0FFF);
+
 	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
 	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0006-rtl8187-avoid-redundant-write-to-register-FF72.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-rtl8187-avoid-redundant-write-to-register-FF72.patch"

>From 6c7fb00e928d97e9f6aab3ea004e1642a242b5b5 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sat, 30 Oct 2010 15:06:46 -0200
Subject: [PATCH] rtl8187: avoid redundant write to register FF72 (RFSW_CTRL)

The table with misc register initialization were setting it, and later
on we would set it again with a explicity call to rtl818x_iowrite16_idx.

Remove duplicate initialization from the register table.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 7e6ebd0..21dc648 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -720,8 +720,7 @@ static const u8 rtl8187b_reg_table[][3] = {
 	{0x52, 0x04, 2}, {0x53, 0xA0, 2}, {0x54, 0x1F, 2}, {0x55, 0x23, 2},
 	{0x56, 0x45, 2}, {0x57, 0x67, 2}, {0x58, 0x08, 2}, {0x59, 0x08, 2},
 	{0x5A, 0x08, 2}, {0x5B, 0x08, 2}, {0x60, 0x08, 2}, {0x61, 0x08, 2},
-	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2}, {0x72, 0x56, 2},
-	{0x73, 0x9A, 2},
+	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2},
 
 	{0x5B, 0x40, 0}, {0x84, 0x88, 0}, {0x85, 0x24, 0}, {0x88, 0x54, 0},
 	{0x8B, 0xB8, 0}, {0x8C, 0x07, 0}, {0x8D, 0x00, 0}, {0x94, 0x1B, 0},
@@ -809,6 +808,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
 
+	/* RFSW_CTRL register */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0007-rtl8187-move-pll-reset-at-start-out-of-ANAPARAM-writ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0007-rtl8187-move-pll-reset-at-start-out-of-ANAPARAM-writ.pa";
 filename*1="tch"

>From e2d453c4cd574ac7de0b8852dcb576cf43b731fc Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sat, 30 Oct 2010 17:02:03 -0200
Subject: [PATCH] rtl8187: move pll reset at start out of ANAPARAM write

On 8187B start, comment about pll reset, and move it out of ANAPARAM
write sequence, so that code is more readable.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 21dc648..72b0153 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -740,7 +740,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_CONFIG);
-
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
@@ -750,19 +749,19 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 			  RTL8187B_RTL8225_ANAPARAM_ON);
 	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
 			 RTL8187B_RTL8225_ANAPARAM3_ON);
-
-	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
-	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
-	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & ~(1 << 5));
-	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (1 << 5));
-
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_NORMAL);
 
+	/* Reset PLL sequence on 8187B. Realtek note: reduces power
+	 * consumption about 30 mA */
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
+	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & ~(1 << 5));
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (1 << 5));
+
 	res = rtl8187_cmd_reset(dev);
 	if (res)
 		return res;
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0008-rtl8187-don-t-set-RTL818X_CONFIG3_GNT_SELECT-flag-on.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-rtl8187-don-t-set-RTL818X_CONFIG3_GNT_SELECT-flag-on.pa";
 filename*1="tch"

>From d68a001d007914fa32a977a5cc0b15fd2c936afe Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sat, 30 Oct 2010 19:39:26 -0200
Subject: [PATCH] rtl8187: don't set RTL818X_CONFIG3_GNT_SELECT flag on 8187B

The GNTSel bit should only concern pci devices by looking at RTL8180
spec, which is not the case of 8187B. Also testing shows that trying to
set this bit fails, a subsequent read from the register after trying to
set it shows that the bit isn't set, seems the hardware ignores it,
which makes sense. This setting was a left over from Realtek sources.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 72b0153..47c0b13 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -741,7 +741,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
 			  RTL8187B_RTL8225_ANAPARAM2_ON);
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0009-rtl8187-consolidate-anaparam-on-off-write-sequences.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0009-rtl8187-consolidate-anaparam-on-off-write-sequences.pat";
 filename*1="ch"

>From 06d221196dba00516c70113cf25509904373a9d6 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sat, 30 Oct 2010 22:26:19 -0200
Subject: [PATCH] rtl8187: consolidate anaparam on/off write sequences

There are repeated calls for anaparam on/off sequence in the code.
Consolidate the common code in rtl8187_set_anaparam and use it where
needed.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |   84 ++++++++++++-----------
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |   22 ------
 2 files changed, 44 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 47c0b13..896aba0 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -553,6 +553,46 @@ static int rtl8187b_init_status_urb(struct ieee80211_hw *dev)
 	return ret;
 }
 
+static void rtl8187_set_anaparam(struct rtl8187_priv *priv, bool rfon)
+{
+	u32 anaparam, anaparam2;
+	u8 anaparam3, reg;
+
+	if (!priv->is_rtl8187b) {
+		if (rfon) {
+			anaparam = RTL8187_RTL8225_ANAPARAM_ON;
+			anaparam2 = RTL8187_RTL8225_ANAPARAM2_ON;
+		} else {
+			anaparam = RTL8187_RTL8225_ANAPARAM_OFF;
+			anaparam2 = RTL8187_RTL8225_ANAPARAM2_OFF;
+		}
+	} else {
+		if (rfon) {
+			anaparam = RTL8187B_RTL8225_ANAPARAM_ON;
+			anaparam2 = RTL8187B_RTL8225_ANAPARAM2_ON;
+			anaparam3 = RTL8187B_RTL8225_ANAPARAM3_ON;
+		} else {
+			anaparam = RTL8187B_RTL8225_ANAPARAM_OFF;
+			anaparam2 = RTL8187B_RTL8225_ANAPARAM2_OFF;
+			anaparam3 = RTL8187B_RTL8225_ANAPARAM3_OFF;
+		}
+	}
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
+        rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
+	if (priv->is_rtl8187b)
+		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, anaparam3);
+	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+}
+
 static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
@@ -603,19 +643,7 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	int res;
 
 	/* reset */
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg |
-			 RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
-			  RTL8187_RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
-			  RTL8187_RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg &
-			 ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_NORMAL);
+	rtl8187_set_anaparam(priv, true);
 
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
@@ -629,17 +657,7 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	if (res)
 		return res;
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
-			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
-			  RTL8187_RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
-			  RTL8187_RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
-			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	rtl8187_set_anaparam(priv, true);
 
 	/* setup card */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0);
@@ -738,22 +756,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	int res, i;
 	u8 reg;
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
-			  RTL8187B_RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
-			  RTL8187B_RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
-			 RTL8187B_RTL8225_ANAPARAM3_ON);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_NORMAL);
+	rtl8187_set_anaparam(priv, true);
 
 	/* Reset PLL sequence on 8187B. Realtek note: reduces power
 	 * consumption about 30 mA */
@@ -1005,6 +1008,7 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 
 	priv->rf->stop(dev);
+	rtl8187_set_anaparam(priv, false);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG4);
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
index 97eebdc..5c6666f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -898,29 +898,7 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 
 static void rtl8225_rf_stop(struct ieee80211_hw *dev)
 {
-	u8 reg;
-	struct rtl8187_priv *priv = dev->priv;
-
 	rtl8225_write(dev, 0x4, 0x1f);
-
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	if (!priv->is_rtl8187b) {
-		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
-				  RTL8187_RTL8225_ANAPARAM2_OFF);
-		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
-				  RTL8187_RTL8225_ANAPARAM_OFF);
-	} else {
-		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
-				  RTL8187B_RTL8225_ANAPARAM2_OFF);
-		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
-				  RTL8187B_RTL8225_ANAPARAM_OFF);
-		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
-				  RTL8187B_RTL8225_ANAPARAM3_OFF);
-	}
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
 static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0010-rtl8187-remove-uneeded-setting-of-anaparam-write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0010-rtl8187-remove-uneeded-setting-of-anaparam-write.patch"

>From 8196a051927a3d2a679c0a41f470258d8f15c5c1 Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sun, 31 Oct 2010 01:42:46 -0200
Subject: [PATCH] rtl8187: remove uneeded setting of anaparam write

Usually you set RTL818X_CONFIG3_ANAPARAM_WRITE when you are going to
change/write ANAPARAM registers. But in current initialization of
RTL8187B there is a place where ANAPARAM_WRITE bit is set without any
ANAPARAM register being written, without reason, so remove it.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 896aba0..c160c16 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -813,14 +813,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	/* RFSW_CTRL register */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_NORMAL);
-
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
-- 
1.7.1



--------------080702070207010401040508
Content-Type: text/plain;
 name="0011-rtl8187-restore-anaparam-registers-after-reset-with-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0011-rtl8187-restore-anaparam-registers-after-reset-with-.pa";
 filename*1="tch"

>From 27c4daca2bacc85ba3e4b2a6901a55ac4a58c49c Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Sun, 31 Oct 2010 02:09:22 -0200
Subject: [PATCH] rtl8187: restore anaparam registers after reset with 8187B

Current 8187B initialization misses anaparam registers restore after
8187 reset. This causes ANAPARAM register to stay zeroed out (ANAPARAM2
kept its value on my tests). To avoid this, call rtl8187_set_anaparam
right after chip reset (to be on the safe side, as it makes sure we
restore all ANAPARAM registers).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index c160c16..d62a313 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -769,6 +769,8 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	if (res)
 		return res;
 
+	rtl8187_set_anaparam(priv, true);
+
 	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
 	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
 	 * one of the 12 rates, all are enabled */
-- 
1.7.1



--------------080702070207010401040508--
