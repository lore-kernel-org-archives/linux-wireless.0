Received: from nova.nubenode.com (nova.nubenode.com [46.4.179.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E11C33ADA7;
	Fri, 11 Sep 2026 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.179.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789148368; cv=none; b=oJ0hOhjZIeR9gdIpfY4ndvbrS11OhWCvFq6g+uEftiFWBA4XUszN2BgKjZiSYebzSsu39r7B6jmMLzYCvvldyJwh8CgLZdgb0x3AWJ+oNetru9YWvx5L5p8ZIP2STfnndt8GDWXjzgGSLx/v14Hjk8XUjCyJMQWtuG56L/PaTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789148368; c=relaxed/simple;
	bh=4oD2gflppFcCCdIEnPKlBKlKwZEn5ipFmZXdNlfSN0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 In-Reply-To:References; b=otMLMg46LCjqG9kISk9Pdd6VF7iefdRH4zv88rEARGwUmIqt3OzlqWoDA03o8gtIj5h2X9ejdL+O3SneFer6aS6WSNMjn/6SEB0pIEoF0cnKmuO/jLXh85rWgzW2AH2lPvN6E3pBOQ0SuTv0GnMoFwJTiX3dTGIgk59e2SEEGmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev; spf=pass smtp.mailfrom=cristiandeluxe.dev; dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b=YMenTbNZ; arc=none smtp.client-ip=46.4.179.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b="YMenTbNZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cristiandeluxe.dev; s=default; h=References:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nhSy1Kupm2gejwNjHkaXCrMxsoinBsXCFu3HvyR3WHw=; b=YMenTbNZjd9geo6o/vwY8vKqel
	2ocPj6QDlcPGtE9k0vlPJH4XbQ2JHi/B3VnsvJOW+L/NzXH0HPzJPuASIX/dUrpXfwUTfDhVeXK38
	FWffUE+E7auWBxEAtZlQuoSbOW3Qbco/CvSi90TQU71R6ikWM8wW8X9XcpY4KNmOR2iS8iePtDNTn
	1D1Dbw0NSxjUBRkgKbWMDb9bdZkWImbUxh/brhHaNHQ+vTUhp3OkjOA/lVubHvUoFF76TPj1A/kjb
	ZGPa1efFgC4wEqUrzj1S3YCbQvmjhevsYL6vueIP468ydLVVHXamHJQb9XkDs692yuT6m/l9vgEH3
	dCi5OrIg==;
Received: from cristiandev by nova.nubenode.com with local (Exim 4.99.5)
	(envelope-from <me@cristiandeluxe.dev>)
	id 1x55De-00000000RJi-391V;
	Fri, 11 Sep 2026 19:39:23 +0200
From: Cristian Deluxe <me@cristiandeluxe.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: rtw88: 8703b: complete the card-disable to card-emulation transition
Date: Fri, 11 Sep 2026 17:38:11 +0200
Message-ID: <178914109042.64584.1377616159988360897@cristiandeluxe.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: sendmail (hand-assembled, git-email unavailable on host)
In-Reply-To: <178914109042.64584.1681714272474754544@cristiandeluxe.dev>
References: <178914109042.64584.1681714272474754544@cristiandeluxe.dev>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nova.nubenode.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [1103 978] / [47 12]
X-AntiAbuse: Sender Address Domain - cristiandeluxe.dev
X-Get-Message-Sender-Via: nova.nubenode.com: authenticated_id: cristiandev/from_h
X-Authenticated-Sender: nova.nubenode.com: me@cristiandeluxe.dev
X-Source: 
X-Source-Args: 
X-Source-Dir: /root

On an RTL8723CS the driver cannot power the MAC on after a warm reboot:
the power-on sequence waits forever for power ready and probe fails.

  rtw88_8723cs mmc2:0001:1: failed to poll offset=0x6 mask=0x2 value=0x2
  rtw88_8723cs mmc2:0001:1: mac power on failed

trans_carddis_to_cardemu_8703b has a single entry, clearing the hardware
power-down bit. Its sibling trans_carddis_to_cardemu_8723d has six more,
and 8822b and 8822c carry the same SDIO pair: withdraw the SDIO suspend
request on local register 0x86 and wait for the interface to leave the
suspended state, clear the WL suspend bit alongside the power-down bit,
and take the 12H LDO out of sleep mode. The transition is the reverse of
trans_cardemu_to_carddis_8703b, which sets 0x23[4] and asks the
interface to suspend, so with those operations missing neither is ever
undone.

The chip then comes back with the WLAN MAC unpowered while the SDIO
function still enumerates and CMD52 still works, and nothing in the
sequence wakes it. rtw_mac_pre_system_cfg() does not cover it either: it
returns early for 8051 wcpu chips, of which this is one.

It survives a reboot on any board where WL_REG_ON is the only reset the
host has and the chip's rail is not switchable. On the Denver TAQ-102
the pwrseq reset line, the BT enable line, the 32.768 kHz clock and
every switchable PMIC rail were each toggled against a wedged chip and
none of them cleared it, while the vendor driver recovered it every
time.

Take the operations 8723d has and this table lacks. That table's USB-only
and PCI-only entries are left out: this chip has no such variant.

Tested on an RTL8723CS over SDIO: recovers a chip left wedged by a
previous boot, and survives repeated warm reboots and loader-mode flash
cycles.

Signed-off-by: Cristian Deluxe <me@cristiandeluxe.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8703b.c | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
index b5e7ae7eb..67bbd70f4 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -187,11 +187,38 @@ static const struct rtw_pwr_seq_cmd trans_pre_enable_8703b[] = {
 };
 
 static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8703b[] = {
+	/* clear WL suspend enable and HW power down enable */
 	{0x0005,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_ALL_MSK,
 	 RTW_PWR_ADDR_MAC,
-	 RTW_PWR_CMD_WRITE, BIT(7), 0},
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(7), 0},
+	/* withdraw the SDIO suspend request */
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	/* and wait for the interface to leave the suspended state */
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	/* disable WL suspend */
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4), 0},
+	/* take the 12H LDO back out of sleep mode, which the card-disable
+	 * transition put it into
+	 */
+	{0x0023,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
 	{TRANS_SEQ_END},
 };
 
-- 
2.51.0
