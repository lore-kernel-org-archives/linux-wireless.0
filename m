Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A80D3C76BC
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785614191; cv=none; b=s1mN5S3IfOGFdlvQIgwtZ2/hD74MLngsjpa/SY/AAHuDYCQHKOCEOSAesgXN1y0bmDy6DQE/pC0Q6ASrL+GpcaclVgt+5QnsgUIwh+ZUDxhAxXTwjmEzLElIFZ8N40cA4v8FJLelcNStNLQv4D8NQck/sC4hlOpTiNBLLOyni08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785614191; c=relaxed/simple;
	bh=jRCtHxYQbzSVipaJb15HIDt3mt8am6/lnYyTBvSwHXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgAqvMo/ElbzQqvlzB+fK1EGnI9A8fZtpCGrbYEizZIAiXZN3E8BtwupXUVfXg5RUPi+BId7rXYSeSCpMhqQUviduS15sxoCqgmczwatESQ/GWYyEF7EhpefDzEjFyqJMqkvkIoVdomvecXvJBn4qZARbPMjIgugIUR9MI+CcSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DL1LcvNk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KWt5UWon; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DL1LcvNk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KWt5UWon"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671JWmdU4099073
	for <linux-wireless@vger.kernel.org>; Sat, 1 Aug 2026 19:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=YilNsvftXkeJTNgADTddjj92CPFeR7A2/HJ
	cuCj9OM8=; b=DL1LcvNkw21qL3Bm/fQqOWiVRKLOkLn7baYE+LjJlQZY29mMEMb
	K6rM2iiMi28eCaS4WMLpZPdoZH7pGdTyQdz9jcVXTzS6PkF7N1f8CoAMd1SoKh9P
	WHAAVQa6do/6X9yfR9EROo2Yq2py9W/D94/OZqoH94YrxgE4vtBbYQirDUQ01/xI
	7MY/75zQsIEc8YxVDlcT5TuXwVJhhkZnYOdg2Zu0VOne+iaj3uAc3PYYEoYQdljQ
	9JaP9uXow7znnQ+dO+WKU5nSLfQimWAXgtirtkC7J0JkeiIU6V4OWvKMqnIQQTIX
	KhFZ2NgJ2PYpai3oqjo1tfygYeCUTar5fZQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8q51msm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 19:56:28 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0199faafso21312761cf.3
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 12:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785614182; x=1786218982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YilNsvftXkeJTNgADTddjj92CPFeR7A2/HJcuCj9OM8=;
        b=KWt5UWon+o9Qcz7a/RnrT3U3kFp4Qnae0AfTAlFLbaugYr/FbcoSjYdlXo/xTioskQ
         bVquFQa89/KFywR1V8xEB45ztGsdu3D0Eulq2U6k9uqayo6EOHtC6DYmJJXxHSmns5M5
         nAMRBny8EfhaDZBeA6mIrndeIPoDeCzNcDX0zjXL9wi77UV12AXaN26K4LHJWODUIp1O
         2nVBJEzJp3pCFOCYxzH3F91fSuCiKJeori+kXp5kBSTx4VVhc2ZOmJvN5FRXCu04J52r
         V+2x5ygXFXIXLjEu+G2SS0oqx07EJRJeXmfDsf1sXzjGBAggxKlB3c8FfBXlYTVZ2t2s
         +cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785614182; x=1786218982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YilNsvftXkeJTNgADTddjj92CPFeR7A2/HJcuCj9OM8=;
        b=q1b/q8ceVIjCkLchqfY9cVthTArqI5zLIMqmhGj0oXEAfuKgnnFO//giEW9ds9mBx9
         6eg3gfgHmF0Sh3+quMbPizsfdFP5KukSCH39q7KF+Sw8Jl4q0QYNSzM36HaxL/t4mKEu
         VhPX620JLEaN89n/m+8ez/CardtKG+XKBmK5gLmapOhN+Mhik3dlwtznWRtVuNLIvwhM
         zDVcUknrWy+VF/lbha05HuBJN8q6F1XL34dIBRSOhx2L/5v+d5sdGlIk/idDm+mJaGAc
         uTX1aKF87QekJD6ukQ0NP7FPYWuBvTGafTzMG8F7uuuArOMqf8BCp5KMYHbIcrNKgmqA
         oAGg==
X-Forwarded-Encrypted: i=1; AHgh+Rols1jsILAQxIdkRqxlI0DF4FGnqq+vrLcimk3tkqq+rKYHob+/mus+DKHiplXO10inLy1iOi82KArHmrHRAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+1/HkZhdT5TqvusE4Uux9F4/6gsT6lBTw/7VJtdWXnv5nAIvI
	/9C7LAbFyMZ0+DwuzeJGU+s1TcP0siGurDMGJh/cHyCicX3WF0FpjfK4PXnKfB8DuyyCsjQV8Yz
	QsD/qfriBJTNUAJOksedduHWjimFZHEFIOKiW4rk0/tJuEcUAdqHYw6fn++RnVCT1Fx2asQ==
X-Gm-Gg: AR+sD10CMd3ugwUANPxbrR3cNEv3Dl5N3rJRlfguaXDOwy2zS5aT8P/S1LsoaHbQilU
	n43Pv6F9+LegZZXhYD/GW57QlBqgad5GPGsyWpx5j1E4V6eJjRCvQoEWsGSKMtTTGR/GzCC5RT3
	lR1VhPjNBwONCi1epe7zWGQp5S+/lbtn4Bmu8vEC5xE/dGIKj49woBnvcsVt2KYjYKgsaPmMb+L
	H7e3tdaFzDbQrkC/MILmy9aRdsHNSWnwT80UvA9X4XGEUdB5OmFhQoZOh/iD+QUoe7z8amfmFMM
	vgjEf3yYH1aT2vaFJjHNEevKEdjGBOYnZE07WV1Z2vOO3G17wY4MTREu5tnxQ5q4uRieUAxqYta
	U1JYuzwOPrHNw550R
X-Received: by 2002:a05:622a:2596:b0:51c:c6c:9d65 with SMTP id d75a77b69052e-52b5667054fmr101489091cf.1.1785614181488;
        Sat, 01 Aug 2026 12:56:21 -0700 (PDT)
X-Received: by 2002:a05:622a:2596:b0:51c:c6c:9d65 with SMTP id d75a77b69052e-52b5667054fmr101487961cf.1.1785614180919;
        Sat, 01 Aug 2026 12:56:20 -0700 (PDT)
Received: from quoll ([178.197.223.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm16523909f8f.3.2026.08.01.12.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 12:56:18 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@arm.com>, James Clark <james.clark@linaro.org>,
        Leo Yan <leo.yan@arm.com>, Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <cassel@kernel.org>, Jyri Sarha <jyri.sarha@iki.fi>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linusw@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Andi Shyti <andi.shyti@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>, Lee Jones <lee@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
        Paul Walmsley <pjw@kernel.org>,
        Samuel Holland <samuel.holland@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jens Wiklander <jenswi@kernel.org>,
        Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>,
        YC Hung <yc.hung@mediatek.com>, Svyatoslav Ryhel <clamor95@gmail.com>,
        Sean Wang <sean.wang@kernel.org>, Frank Li <Frank.Li@nxp.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        coresight@lists.linaro.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, mfd@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] dt-bindings: Correct white-space style
Date: Sat,  1 Aug 2026 21:56:14 +0200
Message-ID: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=25041; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=jRCtHxYQbzSVipaJb15HIDt3mt8am6/lnYyTBvSwHXM=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBqbk9dcmvFjYCVFkZB2dpTSq2XFpopFEsJgYPdk
 MOOvnArybaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCam5PXQAKCRDBN2bmhouD
 13wqD/kBunGPSCWQR/b5Wxs6ixKR+A10NDRYBErq4Tta9I5OlO8dNcUw4VsWhVirfb+XK+6LMv2
 2lLjyQ9SbjrQfmzFsBMBbtJ6p5NGoP1pE83mslHrQ6LZsrBLt38R0U0KeVjpwegZhaLn9jegUG5
 WwSKtZ0XOXPUpwvGoNE90C2Yiq2ES3TtXSnDEeYfhohFeSsK7r8LKyu9C7HpLrjAsmIoUzjhins
 JZp/lWQt0rwq1YDmKIhZWJhtUHlNW4KL6z2bWpliRjPXoZ8mHQ/5wMsbdS3vRH7ewuC9O8L+mxT
 tnyHO4UbYOzAteLCauAC5XaOLKelbxgmSMaZZPGWSC/uFxZ6/lWvZQQ5G0wudXsdhqRiwFyE8HH
 737aU0WsC0YOHtzKzMBVKUo2l6039B/7utqrVQCg4bU17HWhY/xeEs0XRBkPQdTVafdwt4K+uXm
 gAPGBqdHIG37ssgKg/b4zuMN4eizSf5rLk4/H9hYAo3kPsdEL/+FivL5o3dL69EtXsi4stRCVVT
 FdUNl+2d+oHHTcK2TX9c+a8oUtp4i9XXyDLLs0U/tkvCbGyVeff3gWR+k4sZcnL/7/BwiS+s4n+
 E6QakHXrRwoL+5PcvBB8WyqkJsWWQJVwJFlmGklcrPEOCr2lQB1YqgLpdRdNJRoOi7Mf0TVYKD/ hwt/BYnshz8WcZA==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDE2MSBTYWx0ZWRfX3emJQfzzKU4D
 gzY2UY2JXt3azQvPHKKLRCYisbp/pD9EZlo39BF80j3cHj/yL58VyAh4ejyWOOvmqNgBHyqK7tB
 7hjcoEnZjE6EBnSLVNaQHTjx/sJWxWk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDE2MSBTYWx0ZWRfX5C9dUe05c0FR
 SPTHFhw+c68nzFEKb3GGWh+gpNGJNaAxrTCT9KtErkkWnoOXJGN5fvfdZL+HXG2s5rFllu8sQzv
 so+2lPFxUxp80naKGEWcQcIK+9VHFOjpWHDndDFa5v7XKbOcynM2E1q20i3vMKiryXGVjquKII/
 NqoPzZ0NSXKV/X4cCjrXxTjbR81ZbovlykfTPUe2/rI9C8DnHmLNalV2F5w7lnzamxAJZc8xhcT
 /6THUx1h59W8j5LlPihWo2+zwhEywWpxKr7B16vJmLZ4kNLHqVyorfkeUzAK4OYb30dXbXxBSh7
 0m/wIR/+POPe7a/lXrVcjiRKXOAJbS7OeCPJnFm5sIb/Lt7Q5mcLNqBnd8IpGgh6pdZ/f2SBwSa
 MgbKZ7HHs3eprb9mDMEpPF7Se2JVBdB9NhCdeTjjnhiYUZwpOzKJyLyeBlL0YyxLmufFFhrWkvH
 r6x02zXRwymrKR2aZZw==
X-Proofpoint-GUID: 3ohH1i1yQwsQkPLBmW5OU4Y4EB5cPIP9
X-Authority-Analysis: v=2.4 cv=IYC3n2qa c=1 sm=1 tr=0 ts=6a6e4f6c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=N6niishs+lR9UBL1FN3Qrw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=7lKMP4hLRc14UtNM5MAA:9 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: 3ohH1i1yQwsQkPLBmW5OU4Y4EB5cPIP9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608010161

Correct a few white-space issues, like double space after '=' or before
bracket '{' characters, which will be flagged by dt-check-style.  No
functional changes.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

---

Patch applies on Rob's for-next branch.
---
 .../arm/firmware/linaro,optee-tz.yaml         |  8 +-
 .../devicetree/bindings/arm/psci.yaml         | 18 ++--
 .../bindings/arm/qcom,coresight-tnoc.yaml     |  2 +-
 .../devicetree/bindings/ata/st,ahci.yaml      | 22 ++---
 .../bindings/display/ti/ti,am65x-dss.yaml     | 12 +--
 .../bindings/display/ti/ti,j721e-dss.yaml     | 96 +++++++++----------
 .../bindings/display/ti/ti,k2g-dss.yaml       | 36 +++----
 .../bindings/dsp/mediatek,mt8195-dsp.yaml     |  2 +-
 .../bindings/gpio/st,nomadik-gpio.yaml        |  2 +-
 .../devicetree/bindings/i2c/st,sti-i2c.yaml   |  2 +-
 .../bindings/mailbox/st,sti-mailbox.yaml      |  2 +-
 .../bindings/mfd/maxim,max77620.yaml          |  2 +-
 .../bindings/net/wireless/qcom,ath10k.yaml    | 34 +++----
 .../devicetree/bindings/opp/opp-v2.yaml       | 28 +++---
 .../pinctrl/mediatek,mt7988-pinctrl.yaml      |  2 +-
 .../devicetree/bindings/ptp/fsl,ptp.yaml      | 12 +--
 .../devicetree/bindings/pwm/pwm-sifive.yaml   |  2 +-
 .../bindings/usb/ti,twl4030-usb.yaml          |  2 +-
 18 files changed, 142 insertions(+), 142 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
index 5d033570b57b..26ebcf4565f3 100644
--- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
+++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
@@ -50,8 +50,8 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
-    firmware  {
-        optee  {
+    firmware {
+        optee {
             compatible = "linaro,optee-tz";
             method = "smc";
             interrupts = <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
@@ -59,8 +59,8 @@ examples:
     };
 
   - |
-    firmware  {
-        optee  {
+    firmware {
+        optee {
             compatible = "linaro,optee-tz";
             method = "hvc";
         };
diff --git a/Documentation/devicetree/bindings/arm/psci.yaml b/Documentation/devicetree/bindings/arm/psci.yaml
index 6e2e0c551841..0d04389c81fa 100644
--- a/Documentation/devicetree/bindings/arm/psci.yaml
+++ b/Documentation/devicetree/bindings/arm/psci.yaml
@@ -146,12 +146,12 @@ examples:
     // Case 1: PSCI v0.1 only.
 
     psci {
-      compatible      = "arm,psci";
-      method          = "smc";
-      cpu_suspend     = <0x95c10000>;
-      cpu_off         = <0x95c10001>;
-      cpu_on          = <0x95c10002>;
-      migrate         = <0x95c10003>;
+      compatible = "arm,psci";
+      method = "smc";
+      cpu_suspend = <0x95c10000>;
+      cpu_off = <0x95c10001>;
+      cpu_on = <0x95c10002>;
+      migrate = <0x95c10003>;
     };
 
   - |+
@@ -159,8 +159,8 @@ examples:
     // Case 2: PSCI v0.2 only
 
     psci {
-      compatible      = "arm,psci-0.2";
-      method          = "smc";
+      compatible = "arm,psci-0.2";
+      method = "smc";
     };
 
   - |+
@@ -251,7 +251,7 @@ examples:
 
       cpu_pd1: power-domain-cpu1 {
         #power-domain-cells = <0>;
-        domain-idle-states =  <&cpu_pwrdn>;
+        domain-idle-states = <&cpu_pwrdn>;
         power-domains = <&cluster_pd>;
       };
 
diff --git a/Documentation/devicetree/bindings/arm/qcom,coresight-tnoc.yaml b/Documentation/devicetree/bindings/arm/qcom,coresight-tnoc.yaml
index ef648a15b806..37147124449e 100644
--- a/Documentation/devicetree/bindings/arm/qcom,coresight-tnoc.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom,coresight-tnoc.yaml
@@ -82,7 +82,7 @@ additionalProperties: false
 
 examples:
   - |
-    tn@109ab000  {
+    tn@109ab000 {
       compatible = "qcom,coresight-tnoc", "arm,primecell";
       reg = <0x109ab000 0x4200>;
 
diff --git a/Documentation/devicetree/bindings/ata/st,ahci.yaml b/Documentation/devicetree/bindings/ata/st,ahci.yaml
index 6e8e4b4f3d6c..d82c5a65b60c 100644
--- a/Documentation/devicetree/bindings/ata/st,ahci.yaml
+++ b/Documentation/devicetree/bindings/ata/st,ahci.yaml
@@ -57,16 +57,16 @@ examples:
     #include <dt-bindings/clock/stih407-clks.h>
 
     sata@9b20000 {
-        compatible    = "st,ahci";
-        reg           = <0x9b20000 0x1000>;
-        interrupts    = <GIC_SPI 159 IRQ_TYPE_NONE>;
+        compatible = "st,ahci";
+        reg = <0x9b20000 0x1000>;
+        interrupts = <GIC_SPI 159 IRQ_TYPE_NONE>;
         interrupt-names = "hostc";
-        phys          = <&phy_port0 PHY_TYPE_SATA>;
-        phy-names     = "sata-phy";
-        resets        = <&powerdown STIH407_SATA0_POWERDOWN>,
-                         <&softreset STIH407_SATA0_SOFTRESET>,
-                         <&softreset STIH407_SATA0_PWR_SOFTRESET>;
-        reset-names   = "pwr-dwn", "sw-rst", "pwr-rst";
-        clocks        = <&clk_s_c0_flexgen CLK_ICN_REG>;
-        clock-names   = "ahci_clk";
+        phys = <&phy_port0 PHY_TYPE_SATA>;
+        phy-names = "sata-phy";
+        resets = <&powerdown STIH407_SATA0_POWERDOWN>,
+                 <&softreset STIH407_SATA0_SOFTRESET>,
+                 <&softreset STIH407_SATA0_PWR_SOFTRESET>;
+        reset-names = "pwr-dwn", "sw-rst", "pwr-rst";
+        clocks = <&clk_s_c0_flexgen CLK_ICN_REG>;
+        clock-names = "ahci_clk";
     };
diff --git a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
index 49a007cbcd3a..d1e530e12604 100644
--- a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
+++ b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
@@ -261,9 +261,9 @@ examples:
                 "ovr1", "ovr2", "vp1", "vp2", "common1";
         ti,am65x-oldi-io-ctrl = <&dss_oldi_io_ctrl>;
         power-domains = <&k3_pds 67 TI_SCI_PD_EXCLUSIVE>;
-        clocks =        <&k3_clks 67 1>,
-                        <&k3_clks 216 1>,
-                        <&k3_clks 67 2>;
+        clocks = <&k3_clks 67 1>,
+                 <&k3_clks 216 1>,
+                 <&k3_clks 67 2>;
         clock-names = "fck", "vp1", "vp2";
         interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
         ports {
@@ -299,9 +299,9 @@ examples:
             reg-names = "common", "vidl1", "vid",
                         "ovr1", "ovr2", "vp1", "vp2", "common1";
             power-domains = <&k3_pds 186 TI_SCI_PD_EXCLUSIVE>;
-            clocks =        <&k3_clks 186 6>,
-                            <&vp1_clock>,
-                            <&k3_clks 186 2>;
+            clocks = <&k3_clks 186 6>,
+                     <&vp1_clock>,
+                     <&k3_clks 186 2>;
             clock-names = "fck", "vp1", "vp2";
             interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
             oldi-transmitters {
diff --git a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
index 65ae8a1c3998..cac5ef1743d3 100644
--- a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
+++ b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
@@ -154,54 +154,54 @@ examples:
     #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
     dss: dss@4a00000 {
-            compatible = "ti,j721e-dss";
-            reg =   <0x04a00000 0x10000>, /* common_m */
-                    <0x04a10000 0x10000>, /* common_s0*/
-                    <0x04b00000 0x10000>, /* common_s1*/
-                    <0x04b10000 0x10000>, /* common_s2*/
-                    <0x04a20000 0x10000>, /* vidl1 */
-                    <0x04a30000 0x10000>, /* vidl2 */
-                    <0x04a50000 0x10000>, /* vid1 */
-                    <0x04a60000 0x10000>, /* vid2 */
-                    <0x04a70000 0x10000>, /* ovr1 */
-                    <0x04a90000 0x10000>, /* ovr2 */
-                    <0x04ab0000 0x10000>, /* ovr3 */
-                    <0x04ad0000 0x10000>, /* ovr4 */
-                    <0x04a80000 0x10000>, /* vp1 */
-                    <0x04aa0000 0x10000>, /* vp2 */
-                    <0x04ac0000 0x10000>, /* vp3 */
-                    <0x04ae0000 0x10000>, /* vp4 */
-                    <0x04af0000 0x10000>; /* wb */
-            reg-names = "common_m", "common_s0",
-                    "common_s1", "common_s2",
-                    "vidl1", "vidl2","vid1","vid2",
-                    "ovr1", "ovr2", "ovr3", "ovr4",
-                    "vp1", "vp2", "vp3", "vp4",
-                    "wb";
-            clocks =        <&k3_clks 152 0>,
-                            <&k3_clks 152 1>,
-                            <&k3_clks 152 4>,
-                            <&k3_clks 152 9>,
-                            <&k3_clks 152 13>;
-            clock-names = "fck", "vp1", "vp2", "vp3", "vp4";
-            power-domains = <&k3_pds 152 TI_SCI_PD_EXCLUSIVE>;
-            interrupts =    <GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>,
-                            <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>,
-                            <GIC_SPI 604 IRQ_TYPE_LEVEL_HIGH>,
-                            <GIC_SPI 605 IRQ_TYPE_LEVEL_HIGH>;
-            interrupt-names =       "common_m",
-                                    "common_s0",
-                                    "common_s1",
-                                    "common_s2";
-            ports {
-                    #address-cells = <1>;
-                    #size-cells = <0>;
-                    port@0 {
-                            reg = <0>;
+        compatible = "ti,j721e-dss";
+        reg = <0x04a00000 0x10000>, /* common_m */
+              <0x04a10000 0x10000>, /* common_s0*/
+              <0x04b00000 0x10000>, /* common_s1*/
+              <0x04b10000 0x10000>, /* common_s2*/
+              <0x04a20000 0x10000>, /* vidl1 */
+              <0x04a30000 0x10000>, /* vidl2 */
+              <0x04a50000 0x10000>, /* vid1 */
+              <0x04a60000 0x10000>, /* vid2 */
+              <0x04a70000 0x10000>, /* ovr1 */
+              <0x04a90000 0x10000>, /* ovr2 */
+              <0x04ab0000 0x10000>, /* ovr3 */
+              <0x04ad0000 0x10000>, /* ovr4 */
+              <0x04a80000 0x10000>, /* vp1 */
+              <0x04aa0000 0x10000>, /* vp2 */
+              <0x04ac0000 0x10000>, /* vp3 */
+              <0x04ae0000 0x10000>, /* vp4 */
+              <0x04af0000 0x10000>; /* wb */
+        reg-names = "common_m", "common_s0",
+                "common_s1", "common_s2",
+                "vidl1", "vidl2","vid1","vid2",
+                "ovr1", "ovr2", "ovr3", "ovr4",
+                "vp1", "vp2", "vp3", "vp4",
+                "wb";
+        clocks = <&k3_clks 152 0>,
+                 <&k3_clks 152 1>,
+                 <&k3_clks 152 4>,
+                 <&k3_clks 152 9>,
+                 <&k3_clks 152 13>;
+        clock-names = "fck", "vp1", "vp2", "vp3", "vp4";
+        power-domains = <&k3_pds 152 TI_SCI_PD_EXCLUSIVE>;
+        interrupts = <GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 604 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 605 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "common_m",
+                          "common_s0",
+                          "common_s1",
+                          "common_s2";
+        ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            port@0 {
+                reg = <0>;
 
-                            dpi_out_0: endpoint {
-                                    remote-endpoint = <&dp_bridge_input>;
-                            };
-                    };
+                dpi_out_0: endpoint {
+                    remote-endpoint = <&dp_bridge_input>;
+                };
             };
+        };
     };
diff --git a/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
index 96b1439f88e3..87721da0a8af 100644
--- a/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
+++ b/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
@@ -80,26 +80,26 @@ examples:
     #include <dt-bindings/interrupt-controller/arm-gic.h>
     #include <dt-bindings/interrupt-controller/irq.h>
 
-    dss: dss@2540000 {
-            compatible = "ti,k2g-dss";
-            reg =   <0x02540000 0x400>,
-                    <0x02550000 0x1000>,
-                    <0x02557000 0x1000>,
-                    <0x0255a800 0x100>,
-                    <0x0255ac00 0x100>;
-            reg-names = "cfg", "common", "vid1", "ovr1", "vp1";
-            clocks =        <&k2g_clks 0x2 0>,
-                            <&k2g_clks 0x2 1>;
-            clock-names = "fck", "vp1";
-            interrupts = <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>;
+    dss@2540000 {
+        compatible = "ti,k2g-dss";
+        reg = <0x02540000 0x400>,
+              <0x02550000 0x1000>,
+              <0x02557000 0x1000>,
+              <0x0255a800 0x100>,
+              <0x0255ac00 0x100>;
+        reg-names = "cfg", "common", "vid1", "ovr1", "vp1";
+        clocks = <&k2g_clks 0x2 0>,
+                 <&k2g_clks 0x2 1>;
+        clock-names = "fck", "vp1";
+        interrupts = <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>;
 
-            power-domains = <&k2g_pds 0x2>;
+        power-domains = <&k2g_pds 0x2>;
 
-            max-memory-bandwidth = <230000000>;
+        max-memory-bandwidth = <230000000>;
 
-            port {
-                    dpi_out: endpoint {
-                            remote-endpoint = <&sii9022_in>;
-                    };
+        port {
+            dpi_out: endpoint {
+                remote-endpoint = <&sii9022_in>;
             };
+        };
     };
diff --git a/Documentation/devicetree/bindings/dsp/mediatek,mt8195-dsp.yaml b/Documentation/devicetree/bindings/dsp/mediatek,mt8195-dsp.yaml
index abc52978be7a..994afb1c31ff 100644
--- a/Documentation/devicetree/bindings/dsp/mediatek,mt8195-dsp.yaml
+++ b/Documentation/devicetree/bindings/dsp/mediatek,mt8195-dsp.yaml
@@ -81,7 +81,7 @@ examples:
     #include <dt-bindings/interrupt-controller/arm-gic.h>
     #include <dt-bindings/interrupt-controller/irq.h>
     dsp@10803000 {
-        compatible =  "mediatek,mt8195-dsp";
+        compatible = "mediatek,mt8195-dsp";
         reg = <0x10803000 0x1000>,
               <0x10840000 0x40000>;
         reg-names = "cfg", "sram";
diff --git a/Documentation/devicetree/bindings/gpio/st,nomadik-gpio.yaml b/Documentation/devicetree/bindings/gpio/st,nomadik-gpio.yaml
index 40b4a7551449..e871149c520f 100644
--- a/Documentation/devicetree/bindings/gpio/st,nomadik-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/st,nomadik-gpio.yaml
@@ -85,7 +85,7 @@ examples:
   - |
     gpio@8012e080 {
         compatible = "st,nomadik-gpio";
-        reg =  <0x8012e080 0x80>;
+        reg = <0x8012e080 0x80>;
         interrupts = <0 120 0x4>;
         #gpio-cells = <2>;
         gpio-controller;
diff --git a/Documentation/devicetree/bindings/i2c/st,sti-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,sti-i2c.yaml
index 08f9c1e446fd..4efbe82b6d68 100644
--- a/Documentation/devicetree/bindings/i2c/st,sti-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/st,sti-i2c.yaml
@@ -60,7 +60,7 @@ examples:
     i2c@fed40000 {
         compatible = "st,comms-ssc4-i2c";
         reg = <0xfed40000 0x110>;
-        interrupts =  <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
+        interrupts = <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
         clocks = <&clk_s_a0_ls CLK_ICN_REG>;
         clock-names = "ssc";
         clock-frequency = <400000>;
diff --git a/Documentation/devicetree/bindings/mailbox/st,sti-mailbox.yaml b/Documentation/devicetree/bindings/mailbox/st,sti-mailbox.yaml
index a023c28dff49..662ab7f617ac 100644
--- a/Documentation/devicetree/bindings/mailbox/st,sti-mailbox.yaml
+++ b/Documentation/devicetree/bindings/mailbox/st,sti-mailbox.yaml
@@ -42,7 +42,7 @@ additionalProperties: false
 examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
-    mailbox0: mailbox@8f00000  {
+    mailbox@8f00000 {
         compatible = "st,stih407-mailbox";
         reg = <0x8f00000 0x1000>;
         interrupts = <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/Documentation/devicetree/bindings/mfd/maxim,max77620.yaml b/Documentation/devicetree/bindings/mfd/maxim,max77620.yaml
index 602711865274..ac063c2bab73 100644
--- a/Documentation/devicetree/bindings/mfd/maxim,max77620.yaml
+++ b/Documentation/devicetree/bindings/mfd/maxim,max77620.yaml
@@ -311,7 +311,7 @@ examples:
                 in-sd3-supply = <&vdd_5v0_vbus>;
 
                 in-ldo0-1-supply = <&vdd_1v8_vio>;
-                in-ldo2-supply   = <&vdd_3v3_vbat>;
+                in-ldo2-supply = <&vdd_3v3_vbat>;
                 in-ldo3-5-supply = <&vdd_3v3_vbat>;
                 in-ldo4-6-supply = <&vdd_3v3_vbat>;
                 in-ldo7-8-supply = <&vdd_1v8_vio>;
diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
index d4f4d72ee0d3..e667d78b3ab3 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
@@ -390,22 +390,22 @@ examples:
                      <GIC_SPI 46 IRQ_TYPE_EDGE_RISING>,
                      <GIC_SPI 47 IRQ_TYPE_EDGE_RISING>,
                      <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
-        interrupt-names =  "msi0",
-                           "msi1",
-                           "msi2",
-                           "msi3",
-                           "msi4",
-                           "msi5",
-                           "msi6",
-                           "msi7",
-                           "msi8",
-                           "msi9",
-                           "msi10",
-                           "msi11",
-                           "msi12",
-                           "msi13",
-                           "msi14",
-                           "msi15",
-                           "legacy";
+        interrupt-names = "msi0",
+                          "msi1",
+                          "msi2",
+                          "msi3",
+                          "msi4",
+                          "msi5",
+                          "msi6",
+                          "msi7",
+                          "msi8",
+                          "msi9",
+                          "msi10",
+                          "msi11",
+                          "msi12",
+                          "msi13",
+                          "msi14",
+                          "msi15",
+                          "legacy";
         ieee80211-freq-limit = <5470000 5875000>;
       };
diff --git a/Documentation/devicetree/bindings/opp/opp-v2.yaml b/Documentation/devicetree/bindings/opp/opp-v2.yaml
index 10000a758572..ce0fa82bce98 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2.yaml
@@ -293,9 +293,9 @@ examples:
             opp-microvolt = <970000>, /* Supply 0 */
                             <960000>, /* Supply 1 */
                             <960000>; /* Supply 2 */
-            opp-microamp =  <70000>,  /* Supply 0 */
-                            <70000>,  /* Supply 1 */
-                            <70000>;  /* Supply 2 */
+            opp-microamp = <70000>,  /* Supply 0 */
+                           <70000>,  /* Supply 1 */
+                           <70000>;  /* Supply 2 */
             clock-latency-ns = <300000>;
         };
 
@@ -306,9 +306,9 @@ examples:
             opp-microvolt = <975000 970000 985000>, /* Supply 0 */
                             <965000 960000 975000>, /* Supply 1 */
                             <965000 960000 975000>; /* Supply 2 */
-            opp-microamp =  <70000>,    /* Supply 0 */
-                <70000>,    /* Supply 1 */
-                <70000>;    /* Supply 2 */
+            opp-microamp = <70000>,    /* Supply 0 */
+                           <70000>,    /* Supply 1 */
+                           <70000>;    /* Supply 2 */
             clock-latency-ns = <300000>;
         };
 
@@ -317,11 +317,11 @@ examples:
         opp-1000000002 {
             opp-hz = /bits/ 64 <1000000002>;
             opp-microvolt = <975000 970000 985000>, /* Supply 0 */
-                <965000 960000 975000>, /* Supply 1 */
-                <965000 960000 975000>; /* Supply 2 */
-            opp-microamp =  <70000>,    /* Supply 0 */
-                <0>,      /* Supply 1 doesn't need this */
-                <70000>;    /* Supply 2 */
+                            <965000 960000 975000>, /* Supply 1 */
+                            <965000 960000 975000>; /* Supply 2 */
+            opp-microamp = <70000>,    /* Supply 0 */
+                           <0>,      /* Supply 1 doesn't need this */
+                           <70000>;    /* Supply 2 */
             clock-latency-ns = <300000>;
         };
     };
@@ -405,8 +405,8 @@ examples:
             opp-hz = /bits/ 64 <1000000000>;
             opp-microvolt-slow = <915000 900000 925000>;
             opp-microvolt-fast = <975000 970000 985000>;
-            opp-microamp-slow =  <70000>;
-            opp-microamp-fast =  <71000>;
+            opp-microamp-slow = <70000>;
+            opp-microamp-fast = <71000>;
         };
 
         opp-1200000000 {
@@ -415,7 +415,7 @@ examples:
                                  <925000 910000 935000>; /* Supply vcc1 */
             opp-microvolt-fast = <975000 970000 985000>, /* Supply vcc0 */
                                  <965000 960000 975000>; /* Supply vcc1 */
-            opp-microamp =  <70000>; /* Will be used for both slow/fast */
+            opp-microamp = <70000>; /* Will be used for both slow/fast */
         };
     };
 
diff --git a/Documentation/devicetree/bindings/pinctrl/mediatek,mt7988-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/mediatek,mt7988-pinctrl.yaml
index 1f31b520cb43..a33f1fd277c9 100644
--- a/Documentation/devicetree/bindings/pinctrl/mediatek,mt7988-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/mediatek,mt7988-pinctrl.yaml
@@ -573,7 +573,7 @@ examples:
         uart0_pins: uart0-pins {
           mux {
             function = "uart";
-            groups =  "uart0";
+            groups = "uart0";
           };
         };
       };
diff --git a/Documentation/devicetree/bindings/ptp/fsl,ptp.yaml b/Documentation/devicetree/bindings/ptp/fsl,ptp.yaml
index 42ca895f3c4e..998f2ce8665f 100644
--- a/Documentation/devicetree/bindings/ptp/fsl,ptp.yaml
+++ b/Documentation/devicetree/bindings/ptp/fsl,ptp.yaml
@@ -146,11 +146,11 @@ examples:
         reg = <0x24e00 0xb0>;
         interrupts = <12 IRQ_TYPE_LEVEL_LOW>;
         interrupt-parent = <&ipic>;
-        fsl,cksel       = <1>;
+        fsl,cksel = <1>;
         fsl,tclk-period = <10>;
-        fsl,tmr-prsc    = <100>;
-        fsl,tmr-add     = <0x999999a4>;
-        fsl,tmr-fiper1  = <0x3b9ac9f6>;
-        fsl,tmr-fiper2  = <0x00018696>;
-        fsl,max-adj     = <659999998>;
+        fsl,tmr-prsc = <100>;
+        fsl,tmr-add = <0x999999a4>;
+        fsl,tmr-fiper1 = <0x3b9ac9f6>;
+        fsl,tmr-fiper2 = <0x00018696>;
+        fsl,max-adj = <659999998>;
     };
diff --git a/Documentation/devicetree/bindings/pwm/pwm-sifive.yaml b/Documentation/devicetree/bindings/pwm/pwm-sifive.yaml
index bae993128981..40397bdf2d69 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-sifive.yaml
+++ b/Documentation/devicetree/bindings/pwm/pwm-sifive.yaml
@@ -62,7 +62,7 @@ additionalProperties: false
 
 examples:
   - |
-    pwm:  pwm@10020000 {
+    pwm@10020000 {
       compatible = "sifive,fu540-c000-pwm", "sifive,pwm0";
       reg = <0x10020000 0x1000>;
       clocks = <&tlclk>;
diff --git a/Documentation/devicetree/bindings/usb/ti,twl4030-usb.yaml b/Documentation/devicetree/bindings/usb/ti,twl4030-usb.yaml
index 6ef337507425..c338ad0368de 100644
--- a/Documentation/devicetree/bindings/usb/ti,twl4030-usb.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,twl4030-usb.yaml
@@ -67,7 +67,7 @@ examples:
 
         usb1v5-supply = <&reg_vusb1v5>;
         usb1v8-supply = <&reg_vusb1v8>;
-        usb3v1-supply  = <&reg_vusb3v1>;
+        usb3v1-supply = <&reg_vusb3v1>;
         usb_mode = <1>;
 
         #phy-cells = <0>;
-- 
2.53.0

