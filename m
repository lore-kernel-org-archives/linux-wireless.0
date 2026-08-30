Received: from sg-2-3.ptr.blmpb.com (sg-2-3.ptr.blmpb.com [71.18.227.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4BF3016E0
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=71.18.227.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788115350; cv=none; b=ojdiuHBVbV2sb3bHBrzVHRU6oJd7gmo4xdtLtVGlNh3ftVe/VRufr6h6IqYqrDLeqf3Bbwt7Z8vWALquvVSvK5J/rYvd4S8N4DKxKx1yzkgaWQRIZchGLAxesbAnc6+uo6GfvnRdEPbSsnms6oFXhozOh2Gf4/QRPSM+4sDyE4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788115350; c=relaxed/simple;
	bh=qcWikxX63RDf+q1f319g6Cdqm4MSPds23j+RGAf3Z/Q=;
	h=Date:Message-Id:To:Content-Type:In-Reply-To:Cc:From:Subject:
	 Mime-Version:References; b=L88a6QeHy+/kfRZg2Wk9RrO/UnLc4SYmfyFqEj3B5poIYiuMN2CXEGym8X/ZXVhFB9WsKFdkj+jywOuuVjyWrdYaE0TnQbGj0103YtiAHR3MZl3i8XPuyCh5XLV2OjOGx0VXS4LAiQWx56EcHdtHOp90lW2yEWzeGx084QZJN5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc; spf=pass smtp.mailfrom=cherr.cc; dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b=Er4sR+X7; arc=none smtp.client-ip=71.18.227.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b="Er4sR+X7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1788115337; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=S2oGoSOjmfoakjBqcCh3/7CaRO1KAtC9csSDQBDkjrM=;
 b=Er4sR+X7V2QMJZOoY8TBjC+DM50q8AuCD3MdouvE5KKkbstSXyKN4hBm9oFXu3KQSLr07o
 AtjyAmQh3tbJYjUagjoVbEpWOiaNX2DtI3lllNuWHANx4OIz5/5cnRtszoJlvSuIwSVklv
 Q5eTWF5EfcPqNvCpwjlvZhqTA8HD2MbevkdEA0y4hFHTMCFP6mPS6rNVH9n1b/LibyuNz/
 g+T8K4l0YMMJID/GUCKKaLqqfTQbfLKArpLWgM5MO/mThA1Xc490RsJkKF6kAFUIPHAk8Q
 ZIUjbwh+SeW6T9+J7pABrbDXXDOw8WMLGoZOEXwGymp067z5M2Qeq0zNPqTOpQ==
Date: Mon, 31 Aug 2026 02:42:12 +0800
Message-Id: <20260831-p54-pda-validation-v2-1-dae566b388c8@cherr.cc>
X-Mailer: b4 0.16.0
To: "Christian Lamparter" <chunkeey@googlemail.com>, 
	"Michael Wu" <flamingice@sourmilk.net>, 
	"David S. Miller" <davem@davemloft.net>, 
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.9.107] ([111.42.148.195]) by smtp.feishu.cn with ESMTPS; Mon, 31 Aug 2026 02:42:15 +0800
In-Reply-To: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>
X-Original-From: Shengzhuo Wei <me@cherr.cc>
X-Lms-Return-Path: <lba+26a947987+417126+vger.kernel.org+me@cherr.cc>
Content-Transfer-Encoding: 7bit
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "Shengzhuo Wei" <me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>
Subject: [PATCH v2 1/2] wifi: p54: validate curve data length in the calibration curve converters
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>

p54_convert_rev0() and p54_convert_rev1() read calibration curve
data from the device-supplied EEPROM entry using channel and
points-per-channel counts taken verbatim from that same entry, so
an entry that declares more data than it carries drives an
out-of-bounds read past the EEPROM buffer (verified with a KASAN
reproducer of the conversion loop). The sibling converters
p54_convert_output_limits() and p54_convert_db() already validate
their counts against the entry length; this path was missed.

Reject the entry when the counts do not fit in the entry data.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Cc: stable@vger.kernel.org
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
 drivers/net/wireless/intersil/p54/eeprom.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 95580921d933..0dc848d77c5e 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -414,17 +414,22 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 }
 
 static int p54_convert_rev0(struct ieee80211_hw *dev,
-			    struct pda_pa_curve_data *curve_data)
+			    struct pda_pa_curve_data *curve_data, size_t len)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_pa_curve_data_sample *dst;
 	struct pda_pa_curve_data_sample_rev0 *src;
+	size_t needed = curve_data->channels *
+		(sizeof(*src) * curve_data->points_per_channel + 2);
 	size_t cd_len = sizeof(*curve_data) +
 		(curve_data->points_per_channel*sizeof(*dst) + 2) *
 		 curve_data->channels;
 	unsigned int i, j;
 	void *source, *target;
 
+	if (len < sizeof(*curve_data) + needed)
+		return -EINVAL;
+
 	priv->curve_data = kmalloc(sizeof(*priv->curve_data) + cd_len,
 				   GFP_KERNEL);
 	if (!priv->curve_data)
@@ -466,17 +471,22 @@ static int p54_convert_rev0(struct ieee80211_hw *dev,
 }
 
 static int p54_convert_rev1(struct ieee80211_hw *dev,
-			    struct pda_pa_curve_data *curve_data)
+			    struct pda_pa_curve_data *curve_data, size_t len)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_pa_curve_data_sample *dst;
 	struct pda_pa_curve_data_sample_rev1 *src;
+	size_t needed = curve_data->channels *
+		(sizeof(*src) * curve_data->points_per_channel + 3);
 	size_t cd_len = sizeof(*curve_data) +
 		(curve_data->points_per_channel*sizeof(*dst) + 2) *
 		 curve_data->channels;
 	unsigned int i, j;
 	void *source, *target;
 
+	if (len < sizeof(*curve_data) + needed)
+		return -EINVAL;
+
 	priv->curve_data = kzalloc(cd_len + sizeof(*priv->curve_data),
 				   GFP_KERNEL);
 	if (!priv->curve_data)
@@ -763,6 +773,7 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		case PDR_PRISM_PA_CAL_CURVE_DATA: {
 			struct pda_pa_curve_data *curve_data =
 				(struct pda_pa_curve_data *)entry->data;
+
 			if (data_len < sizeof(*curve_data)) {
 				err = -EINVAL;
 				goto err;
@@ -770,10 +781,10 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 
 			switch (curve_data->cal_method_rev) {
 			case 0:
-				err = p54_convert_rev0(dev, curve_data);
+				err = p54_convert_rev0(dev, curve_data, data_len);
 				break;
 			case 1:
-				err = p54_convert_rev1(dev, curve_data);
+				err = p54_convert_rev1(dev, curve_data, data_len);
 				break;
 			default:
 				wiphy_err(dev->wiphy,

-- 
2.47.3
