Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7AC3128B6;
	Thu, 10 Sep 2026 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789003394; cv=none; b=mNuiNMAAOgENTAiGjUBiD9nL65I/4AVP5oyaHOcaU2fPwQ0kEVJkm3pck09FdEflGfboN2MQhhzhb2bw03KSh/zaXu/ul9LxKQf6/xRDBtPU/O0gsNqiJnVguBjJ/d6Iiv2sXxmzbTGil8ZDrZ47POezlzndJ3CIbBzYuRtoFoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789003394; c=relaxed/simple;
	bh=lRjClYP9yC3grhG0ovnCW4em2hdKxrj5BgNviM/1uQY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y30DPXtPe/Kg7823Teiju1aU4VuAxB4R+mmDuZMMA819YqLeoZWfPC8fbV0HMRXgUYpLihBdOUOdDTUGaa2Kk5IBUP270AgSmWQOrQqcKjT4IxW+nD5puR/E+80YjQaPsAo4vTSPlUXmZNmSHit2L8NGl0jgMDV9RweJMEO5gyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D4UmyBX5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4UmyBX5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789003392; x=1820539392;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lRjClYP9yC3grhG0ovnCW4em2hdKxrj5BgNviM/1uQY=;
  b=D4UmyBX5idwFUjYlmLOpMKRkPUZURoAnjAL8mn4AEn8kmx7pP8ZljnpS
   5JVOM0+ihQpRq36+JTS+1f8iMzSS718B2R0egQjRnkeenIvAKkScfrAiL
   ycION7yNQiExNuJ76kc1wf0jIg/HbY8kGCjRAM0wsp6ZGVq55Yhn+ICNb
   dpfDOdGqAto+O6sKwv5LTyjHI2D2ugjfz+O0FtQjGdOJd3LPmQNzo7B51
   3im2h5oWmmvYwytWpGSaI+K4voA+2GCVOneD4pS/mCLn98Le+8hCDuNHX
   /GEViPIXg1sDqTm1fpAoVd59u6S3mQoCPdLPAQuuEvH6ek00BsH79Fpb0
   w==;
X-CSE-ConnectionGUID: VzfSn1voSfmV5eo3TJ60Aw==
X-CSE-MsgGUID: vruBNC48Qv6IJAk9UC5p5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="106958975"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="106958975"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 18:23:12 -0700
X-CSE-ConnectionGUID: 92O01xzpT7azHbVodMzk+g==
X-CSE-MsgGUID: xoEUSTzkTmqTtucpQdEIbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="276720893"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 18:23:09 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit
Date: Thu, 10 Sep 2026 09:23:00 +0800
Message-ID: <acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some ASUS firmware carries 0xff in MTGS power slots. The driver narrows
the byte to s8, so the slot reads as -1 in its 0.5 dBm units, wins the
min() against the regulatory limit and caps every rate the driver
programs. On an ASUS Zenbook 14 UM3406HA (MT7922) all six MTGS tables
hold 0xff in every power byte, and txpower_sku shows tmac 3 on every
supported OFDM/HT/VHT/HE rate against EEPROM entries of 25-39, under
both the FR and the world regulatory domain. Huy Nguyen Dinh Quang saw
the same clamp on a Vivobook S 14 M5406WA, with 5 GHz TX at ~40 Mbps,
and proposed skipping the geo entry.

Skip a geo entry whose power byte is 0xff. The MTDS entry is narrowed
the same way on its way into the geo lookup, so give it the same
treatment, and clamp the dynamic value plus offset at 127 so a no-limit
entry cannot wrap.

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2515420
Reported-by: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/20260827134820.2607530-1-huynguyendinhquang@gmail.com/
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
Fed the Zenbook's MTGS bytes through the two lookups in a host build of
these functions, once with a sane v2 MTDS and once with one full of
0xff. Before: -1 on every range in every region, -2 under ETSI with
the padded MTDS. After: the MTDS values with the sane table, 127 with
the padded one. No MT7922 here; the Zenbook reporter has offered to
test.

 .../wireless/mediatek/mt76/mt792x_acpi_sar.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..9f0ea3d23e0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -279,10 +279,18 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
 	if (idx >= max)
 		return dyn_power;
 
-	geo_power = (band_pwr + idx)->pwr;
-	dyn_power += (band_pwr + idx)->offset;
+	band_pwr += idx;
 
-	return min(geo_power, dyn_power);
+	/* Some OEM tables carry 0xff here; narrowed to s8 that is -1 and
+	 * wins the min() below. Take it as no limit.
+	 */
+	if (band_pwr->pwr == 0xff)
+		return dyn_power;
+
+	geo_power = band_pwr->pwr;
+
+	return min_t(int, geo_power,
+		     min_t(int, dyn_power + band_pwr->offset, 127));
 }
 
 static s8
@@ -315,7 +323,9 @@ mt792x_asar_range_pwr(struct mt792x_phy *phy,
 	else
 		band = NL80211_BAND_2GHZ;
 
-	return mt792x_asar_get_geo_pwr(phy, band, limit[idx]);
+	/* 0xff: no dynamic limit, see mt792x_asar_get_geo_pwr() */
+	return mt792x_asar_get_geo_pwr(phy, band,
+				       limit[idx] == 0xff ? 127 : limit[idx]);
 }
 
 int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
-- 
2.43.0

