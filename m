Received: from nova.nubenode.com (nova.nubenode.com [46.4.179.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D163F38C40E;
	Fri, 11 Sep 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.179.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789148394; cv=none; b=G7ciHC9IFrs1ljJ3YGPm2H0w6SECR2WvbvokrZ0xhbtsBQ7r3CzKwy4+DZ3vmu1lug39sxdCuwWa4YkCEXG/mkMVshHMaYjpRcqm+udu68H5JHqmmHxo/6R8B5Wk+HZuI/YEWR+vztQ3SEtg+uE/m6i8x5ErwrC118cvVQDVk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789148394; c=relaxed/simple;
	bh=j4CUhv1QLcEu0+ak7TLFO32/Pf38l/f42ONd5EExPvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 In-Reply-To:References; b=roPYF2qv5wjtmhudrQIR3YDd+A4bGWYJrRTlHNqu9cH31TqEefG8gh37x8ccRIvws6xi+qBW9ujs/9546oVLb3Zna3hM0jib0QfelwXM82PRsrIVSQ1z/EPUUUgMlQdIZuwJXTT2IaBNUQIurmuwoA9Qt8xsa2KhF3WIas2i9gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev; spf=pass smtp.mailfrom=cristiandeluxe.dev; dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b=b/SCbX6g; arc=none smtp.client-ip=46.4.179.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b="b/SCbX6g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cristiandeluxe.dev; s=default; h=References:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2XPjYYHQB59xTSnxAKCR9wFwi40L5z7iGdr3RaF0B94=; b=b/SCbX6g/Ek0rUAouQG4n22DVB
	tYcuD3WwqTAjhEfmkRofhaDDZci4EVcGW7zWNGHN22yCtR/Dyu+7wNqghKJvBhBsTGny2c1GCXAaz
	wTjCchtS6PYbRxUr5OvfgGb24YGlR9iYYU9SSBuIvnQIIXxTdkWaCxOWe/4JQeUkYZGnit+qNoJ6l
	TCwXEDKVGuroQ2r8KldS5x59sC4sqKevoSX3VFccpypz/oyGmO7BD+UgNM2e9iS19kdoRxBAw3UiJ
	1WCKclZySV9CuuhNs/QmV2DtoSerkU8EWi5gnORZBeKFFH58AUKZhP3jyezFtlxWMXSIMnaVKgeRc
	ryqB5xVA==;
Received: from cristiandev by nova.nubenode.com with local (Exim 4.99.5)
	(envelope-from <me@cristiandeluxe.dev>)
	id 1x55E5-00000000RSS-0i7P;
	Fri, 11 Sep 2026 19:39:49 +0200
From: Cristian Deluxe <me@cristiandeluxe.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wifi: rtw88: 8703b: stop the PCIe DMA write reaching SDIO
Date: Fri, 11 Sep 2026 17:38:12 +0200
Message-ID: <178914109042.64584.11316164845616306056@cristiandeluxe.dev>
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

The first entry of trans_act_to_lps_8703b writes 0xff to MAC register
0x301 on every interface. That register is the PCIe DMA control, and
both trans_act_to_lps_8723d and Realtek's own 8703b sequence header
restrict the same entry to PCI, where it is commented "PCIe DMA stop".

So on an RTL8723CS, which is SDIO only, every transition into low power
poked a PCIe register for no reason. Restrict it the way the sibling
chip and the vendor both do.

Tested on an RTL8723CS over SDIO: the interface goes down and back up,
reassociates and takes an address, and a warm reboot brings Wi-Fi back
with no change in behaviour.

Signed-off-by: Cristian Deluxe <me@cristiandeluxe.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8703b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -412,7 +412,7 @@ static const struct rtw_pwr_seq_cmd trans_act_to_reset_mcu_8703b[] = {
 static const struct rtw_pwr_seq_cmd trans_act_to_lps_8703b[] = {
 	{0x0301,
 	 RTW_PWR_CUT_ALL_MSK,
-	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
 	 RTW_PWR_ADDR_MAC,
 	 RTW_PWR_CMD_WRITE, 0xff, 0xff},
 	{0x0522,
-- 
2.51.0
