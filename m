Received: from sg-2-1.ptr.blmpb.com (sg-2-1.ptr.blmpb.com [71.18.227.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866941BA63
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=71.18.227.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787764098; cv=none; b=FgdCjKZrOl2nW2suAfscbyfssuU0YsnrU1H05VvtAh63UEZbjjTK66rZCq2q9n0f5DZRA/15ssPg9YPSjjDjihv8NfOGmIeTbSrgddmQfgWASAqQ9bv7kvfZGaKqHSzZ+2aN+QIPfbGWNCcJpXN3dbYj6r1bNUKR3UEmjv23jP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787764098; c=relaxed/simple;
	bh=4xBhgvMDLs/XLN2pd56fd3I5TV/RbHd5HZxG+sUGfYE=;
	h=In-Reply-To:Date:Content-Type:References:Cc:Message-Id:To:Subject:
	 Mime-Version:From; b=ZloY+E6tDTmAgXz/Za5Wz8jvfcH0PhyNbaD6ZqKfdBXdflfEvNTbMY5SduT+wNavORol7E7qUkm2L60DdxWA3En8NZ6xJ88KXOjVrctFRX6vlIADFGd/Zdaewxe3fO/SZ9+lZjj7PkNw/J6If3iE/QC71ILaQOQAsdRSlj7P6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc; spf=pass smtp.mailfrom=cherr.cc; dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b=lr8a2Wyd; arc=none smtp.client-ip=71.18.227.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b="lr8a2Wyd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1787764067; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=PJ594cLpPW6v3aDbK0/v/dsM4wWK1cUjGz46u5+Upc8=;
 b=lr8a2WydUUTX98ut1cOxoPJt1e3sxlbvLI3l9DmCiBzlw0KJPSq9c5axlmNijbfTm34PHz
 5loafIostJobZknPqe4IRoIp0SBuTI8KZyWtPG+TrqtPc4Y+Nav6x5+bKz6a3ekQPbWz8i
 dHfHWBsxf51a86oYVV/ryoGlGCe8SsyOdw4wno+A2QKuemCbdqWoLXh4tcyZSgcGee6mAN
 7pB2jD3sdCNt0kFA3nHor15GFw6EU8YA6U7uxBWCkD5xV+rnB8rvGfXl2PhTyz0m364CJl
 BxOEwwln4A3+VIMg2qUtH10cKhVMgJfmUd7+Sfid/BSIIgLJ/hArm0FYKuiUpA==
X-Mailer: b4 0.14.2
In-Reply-To: <20260827-p54-pda-validation-v1-0-bdc2b0675056@cherr.cc>
X-Lms-Return-Path: <lba+26a8f1d61+c2da0f+vger.kernel.org+me@cherr.cc>
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Aug 2026 01:07:39 +0800
Content-Type: text/plain; charset=UTF-8
References: <20260827-p54-pda-validation-v1-0-bdc2b0675056@cherr.cc>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "Shengzhuo Wei" <me@cherr.cc>
Message-Id: <20260827-p54-pda-validation-v1-1-bdc2b0675056@cherr.cc>
Received: from [192.168.9.107] ([111.42.148.29]) by smtp.feishu.cn with ESMTPS; Thu, 27 Aug 2026 01:07:45 +0800
To: "Christian Lamparter" <chunkeey@googlemail.com>, 
	"Michael Wu" <flamingice@sourmilk.net>, 
	"John W. Linville" <linville@tuxdriver.com>, 
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] wifi: p54: validate curve data length in p54_parse_eeprom()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Shengzhuo Wei <me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>

p54_convert_rev0() and p54_convert_rev1() walk
channels * (2 + points_per_channel * sizeof(sample)) bytes of the
curve data entry, with both counts taken verbatim from the
device-supplied EEPROM. An entry that declares channels=255,
points_per_channel=255 but carries only the 4-byte header drives a
~191 KB slab-out-of-bounds read past the EEPROM buffer (verified with
a KASAN reproducer of the conversion loop). The sibling converters
p54_convert_output_limits() and p54_convert_db() already validate
their counts against the entry length; this path was missed.

Reject the entry when the counts do not fit in the entry data.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Cc: stable@vger.kernel.org
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
 drivers/net/wireless/intersil/p54/eeprom.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 95580921d933827c5eac55b79404e26bd7a57ba4..968ce9a411358e0e6b83117b1a077becc3207090 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -763,6 +763,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		case PDR_PRISM_PA_CAL_CURVE_DATA: {
 			struct pda_pa_curve_data *curve_data =
 				(struct pda_pa_curve_data *)entry->data;
+			size_t needed;
+
 			if (data_len < sizeof(*curve_data)) {
 				err = -EINVAL;
 				goto err;
@@ -770,9 +772,23 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 
 			switch (curve_data->cal_method_rev) {
 			case 0:
+				needed = curve_data->channels *
+					(sizeof(struct pda_pa_curve_data_sample_rev0) *
+					 curve_data->points_per_channel + 2);
+				if (data_len - sizeof(*curve_data) < needed) {
+					err = -EINVAL;
+					goto err;
+				}
 				err = p54_convert_rev0(dev, curve_data);
 				break;
 			case 1:
+				needed = curve_data->channels *
+					(sizeof(struct pda_pa_curve_data_sample_rev1) *
+					 curve_data->points_per_channel + 3);
+				if (data_len - sizeof(*curve_data) < needed) {
+					err = -EINVAL;
+					goto err;
+				}
 				err = p54_convert_rev1(dev, curve_data);
 				break;
 			default:

-- 
2.47.3
