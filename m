Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2321C41DED8
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 16:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490225; cv=none; b=sD2+Udw4walTEGgGKCSag40vsCiqkHQFdkbBssdRrlHm3+9zHddIPeexpJNTqcJMaulxLHar2nNCyO3Vk1IXRdH7mG2+/c16cIyTAXDbaNsIe6ck6PMUjMunItjUHpo/bPOenhdIVjMigsm6T6S+rKh53mNoYlTLhZ/d7MccmYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490225; c=relaxed/simple;
	bh=hrcSslWf9OV1pzTYNNc/FvrI/OBOg/id/uu0chl4jlA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FBrhR+7G7+4ScUfPj3aS3XTWFRHdYSHkFbPfh3AJUgNxfjC+RsEH6FcmCdVcMh37tcPZKJxXeJkCa28AIu4sZSjxNQMojsa6/IuP8pkZzhX1RBJ62drYGIoHubWKH6EXykTOqvk50ngUKyJxcR3Wywn2usxli/Btcc9vnULWSMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ee4PlLgx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZHBCltA1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ee4PlLgx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZHBCltA1"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFAaEX291131
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 16:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=hdV3KIhCi7YCLPaq1KLzAv
	xgX5n5+ED+mUKoBQ8kj0E=; b=Ee4PlLgxSyihIgMYwMYoGjH0BFkEazxbaP5o5d
	cV1UT5sZ+SrQvv2ZEoOHMnTo8l9z5wwUeMfI3Q1tqlbJ1ZrAuPmXBsnmVw/mgBT/
	J96iS0UvNaQCrclTXEZkv3sFO3bNWvYWxJm0Pgmrn3KP/sUs8NBabOKAG/b1eOgG
	DB5RJrodZOqJ+p4Kzoz911XZcbO6NjDPhbfTyUayQQgKnR05QYMyaZWhLy042yQK
	nNotqVhUA33QxMhYJP3Bn1qkjNvEYTmWrLtoQ8GHS9QVzte24CpNVehw8tC56fsz
	wI5hSyMpbY6IenT7iPg3GlnQtJpLuqKB9d9j7v2Gin6VWbIw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpyux2x8u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 16:37:02 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc44d708055so7807498a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 09:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789490221; x=1790095021; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hdV3KIhCi7YCLPaq1KLzAvxgX5n5+ED+mUKoBQ8kj0E=;
        b=ZHBCltA1bHPj8tYHKWRxh2LK7lueihfVbNYdlB+39tSt6wtocr9Bai9KWLYh5Bui5N
         pFwdypxsfAXjEBwPAn1zs3Zq5FK7J23minTlaiIpjRp4UGrV8McHUaUcOkoZIp1aSI33
         dOTDUNyyxBmytVyanSNtQ8Ed7yMCQ17vSe8DfFP45A+p87AHsaaM6tsUvP3shDm/K0CQ
         GMS0aLihreZHr74K9RRN2BAjUDrLnftmKqF7kcpxAUqaoKkC0J39/JsQ6uEO/Q7iccfr
         YRY1jAbNnb8kBavZdNYnekj6L8tRA6Cpp0IykRJrr/Jn4PzsEZlSTnicPrXno2Em6xtC
         rQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789490221; x=1790095021;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hdV3KIhCi7YCLPaq1KLzAvxgX5n5+ED+mUKoBQ8kj0E=;
        b=hirU+wiio+Uwt8uMGBjZmpEjjkgQ/Rbd41vK1TeJWLy1DF/XOwAJg0IYQUGVsATTRK
         QducPJQ0+bhZ3bfBwBzIyTkgm4mEUBo5HuemZ/jnYQgnTUzAw22SxOdlnjt04zb5VYO5
         ++vkRGhziQAsfq8/tQVue8xo78r3enS8QnYRtZcoJAHIRiAbW4ulMktIHZHAuEdA4E67
         GfVeIJS24xIbp0c4O5z3plkETrR+Gtn3mDKm20+EWYeh5mnOxnV3AW171liQ2YsUnTy8
         7q+tJVxWkNZAkXOw5Flgx0HMiLsO1emJ+GKAJ4B5dses006vUj0dw0HgNFhlSlgwu+yX
         tYYg==
X-Forwarded-Encrypted: i=1; AKwUvBwvpjRN5r6npP/uWCeWc64vt7FcuU5TkH8LKo9jiQY8HClwYsuJY/B/vpePPLzpw4P3OlreXUcSEwp33WiwOQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lKJFML2aYowJ5f1AQsUdVNhSXFz1yroXqPrfp20j3oS6itZIOj
	l0R3FkPn7bofBbkMBebbx54SEI7eO1cR9kN9Y5XmdhxuzxYm8J+vGaJPLs8adO73XH3dECpjiVQ
	cssac4ywOIlllfe/MMfUjbnjs3OQSYPre2F9CICML2qxXUq4scAx99hSR0gOC76WeC94fLQ==
X-Gm-Gg: AYBFou3oQ3evQhRfbttf7xiMlfUHzUXu32xhxDLRUX0YRg/j/MMw84SmcVsTZ2CFDMP
	t3XgOF4m2GwvbZ+AzEYPHy9SL6E6y1ZN+S/VSwbwfCoslZmS2qnaktqnWxI+10a77kwfxf8rEjU
	VaCjhkSIh+OR494/hzMZ3goLjjKLoRku55AnWDGqF0Buq/W18nmxR0kcozMWTToAT5ZLMAMXvYZ
	dloFM84rPudxvpAa3N4pm0KUFxyktFzymflU9q+q3aKeLjYfudzE6cOhVUKh6ZMcja/FyhI/2uQ
	52VoemgMvwrWLyqCSWcYMO0ca6BMcWkN2zSQcvWqEs8/gX/Z5AtATfqoRNEnRzJGd92uXDLJ8X9
	TIxLnUzSy8PFLVfQJcTxmWNe4TxYWItxZef1UBMDF+9BqrGMuepZHSXY=
X-Received: by 2002:a17:90b:3f4e:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-39e10ce07c7mr3609052a91.2.1789490221383;
        Tue, 15 Sep 2026 09:37:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3f4e:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-39e10ce07c7mr3608981a91.2.1789490220919;
        Tue, 15 Sep 2026 09:37:00 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd7545asm6324529a91.14.2026.09.15.09.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 09:37:00 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Tue, 15 Sep 2026 09:36:48 -0700
Subject: [PATCH wireless-next] MAINTAINERS: Replace
 wireless.wiki.kernel.org links
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260915-wireless-wiki-v1-1-21dc76684b44@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAB90qWoC/z2MOwqAMBAFryJbG4jxR7yKWCS66qJEyYoGxLsbL
 OxmYN67gdETMjTJDR5PYtpclCxNoJ+Nm1DQEB2UVJXUWSku8rgic4SFhDGm0LbQea0sxM3ucaT
 w/bXwpw7DAd3zvOobIFBuAAAA
X-Change-ID: 20260915-wireless-wiki-aaa49b49372b
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDI0MiBTYWx0ZWRfX4bbYGArpr11j
 ZnRcELG3sE52VMB24dq6AzoFFIYt8G5d4il0HlexFYxINFMALLIkdrimP8JKF5mySgiKxpOueDT
 MQprYWF/tSIWjZy9xhdCsCItmiurZYi+4mVZLO5iJDq+E7EqKrTwAdrdlpJ0QgqZnYPnuejQs/C
 atsOP8RaJlV3iqL4nMm9+/z0vC6gcyDteAwEMK24ZewjX33VLdNC+TockpOOtSJ/whi0tKA6Bcl
 1IQ4ayjhoVKyeHuO9YsUr6YIXLheZAYnhlV7huS7ddeQQD33kfhvCvwyNwKONiGzVr/11oBs7+G
 MaiL4OsEaV6dkxRikiVmCWWTPzpO4WA9oOe6UYqhZU6zedVFcBaWCqhFN0xbYUWpNo2jYR7FyuM
 +BAt/9bxyW/trWcZbK/LaaiDDv7DDyRvfIhksQEdFrQVbGaKhZu70UXkFmkP0LC1W1hejyKZDDz
 pfAwajBo7LczDRfdSTQ==
X-Proofpoint-ORIG-GUID: b5GgHCtMqyjP-KXZ0pyjUSgj38pZQF1T
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDI0MiBTYWx0ZWRfX5mFlJywpfICc
 Jw7UtSdmbLeBgeYCffyGKGgiDyC7LCwwHpWpPCugpiorWM3Srec1cGBYL1sTjCpcf6mEL2jxY1K
 M59QpbfF3QvSpGLr/VYmPN5M8I6JJ0E=
X-Proofpoint-GUID: b5GgHCtMqyjP-KXZ0pyjUSgj38pZQF1T
X-Authority-Analysis: v=2.4 cv=QYLzLcbv c=1 sm=1 tr=0 ts=6aa9742e cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17 a=VwQbUJbxAAAA:8
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=stkexhm8AAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8
 a=mK_AVkanAAAA:8 a=QyXUC8HyAAAA:8 a=uSTmyDH8MVGYOsSRgaMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22 a=pIW3pCRaVxJDc-hWtpF8:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=3gWm3jAn84ENXaBijsEo:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150242

wireless.wiki.kernel.org has not existed for a while. Update all links to
point to the current rendered pages at wireless.docs.kernel.org.

Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 MAINTAINERS | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b23fb6f2f4ef..f6ead73ab92d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -113,7 +113,7 @@ F:	net/6lowpan/
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/
+W:	https://wireless.docs.kernel.org/en/latest/
 Q:	https://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
@@ -4260,13 +4260,13 @@ M:	Nick Kossifidis <mickflemm@gmail.com>
 M:	Luis Chamberlain <mcgrof@kernel.org>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath5k
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath5k.html
 F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH6KL WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 S:	Orphan
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath6kl
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath6kl.html
 F:	drivers/net/wireless/ath/ath6kl/
 
 ATI_REMOTE2 DRIVER
@@ -4535,14 +4535,14 @@ B43 WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
 S:	Orphan
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/b43
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html
 F:	drivers/net/wireless/broadcom/b43/
 
 B43LEGACY WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
 S:	Orphan
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/b43
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html
 F:	drivers/net/wireless/broadcom/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
@@ -5919,7 +5919,7 @@ CARL9170 LINUX COMMUNITY WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/carl9170
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/carl9170.html
 F:	drivers/net/wireless/ath/carl9170/
 
 CAVIUM I2C DRIVER
@@ -13560,7 +13560,7 @@ INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Miri Korenblit <miriam.rachel.korenblit@intel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
-W:	https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/iwlwifi.html
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git/
 F:	drivers/net/wireless/intel/iwlwifi/
 
@@ -15661,7 +15661,7 @@ MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/
+W:	https://wireless.docs.kernel.org/en/latest/
 Q:	https://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
@@ -18920,7 +18920,7 @@ NETWORKING DRIVERS (WIRELESS)
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/
+W:	https://wireless.docs.kernel.org/en/latest/
 Q:	https://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
@@ -20592,7 +20592,7 @@ P54 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/p54
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/p54.html
 F:	Documentation/devicetree/bindings/net/wireless/st,stlc4560.yaml
 F:	drivers/net/wireless/intersil/
 
@@ -22282,7 +22282,7 @@ M:	Jeff Johnson <jjohnson@kernel.org>
 L:	linux-wireless@vger.kernel.org
 L:	ath12k@lists.infradead.org
 S:	Supported
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath12k
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k.html
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
 F:	drivers/net/wireless/ath/ath12k/
 N:	ath12k
@@ -22292,7 +22292,7 @@ M:	Jeff Johnson <jjohnson@kernel.org>
 L:	linux-wireless@vger.kernel.org
 L:	ath10k@lists.infradead.org
 S:	Supported
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath10k
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k.html
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
 F:	drivers/net/wireless/ath/ath10k/
 N:	ath10k
@@ -22302,8 +22302,8 @@ M:	Jeff Johnson <jjohnson@kernel.org>
 L:	linux-wireless@vger.kernel.org
 L:	ath11k@lists.infradead.org
 S:	Supported
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath11k
-B:	https://wireless.wiki.kernel.org/en/users/Drivers/ath11k/bugreport
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k.html
+B:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k/bugreport.html
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
 F:	drivers/net/wireless/ath/ath11k/
 N:	ath11k
@@ -22312,7 +22312,7 @@ QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
 M:	Toke Høiland-Jørgensen <toke@toke.dk>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath9k
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath9k.html
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
 F:	Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
 F:	drivers/net/wireless/ath/ath9k/
@@ -22654,7 +22654,7 @@ M:	Loic Poulain <loic.poulain@oss.qualcomm.com>
 L:	wcn36xx@lists.infradead.org
 L:	linux-wireless@vger.kernel.org
 S:	Supported
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/wcn36xx
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/wcn36xx.html
 F:	drivers/net/wireless/ath/wcn36xx/
 
 QUANTENNA QTNFMAC WIRELESS DRIVER
@@ -23413,7 +23413,7 @@ RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-W:	https://wireless.wiki.kernel.org/
+W:	https://wireless.docs.kernel.org/en/latest/
 Q:	https://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
@@ -27508,8 +27508,8 @@ F:	drivers/media/platform/ti/vpe/
 TI WILINK WIRELESS DRIVERS
 L:	linux-wireless@vger.kernel.org
 S:	Orphan
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/wl12xx
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/wl1251
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/wl12xx.html
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/wl1251.html
 F:	drivers/net/wireless/ti/
 
 TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
@@ -29386,7 +29386,7 @@ F:	drivers/hid/hid-wiimote*
 WILOCITY WIL6210 WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 S:	Orphan
-W:	https://wireless.wiki.kernel.org/en/users/Drivers/wil6210
+W:	https://wireless.docs.kernel.org/en/latest/en/users/drivers/wil6210.html
 F:	drivers/net/wireless/ath/wil6210/
 
 WINBOND CIR DRIVER

---
base-commit: 85437f88642d72cb82e5707918dc4da95c2653de
change-id: 20260915-wireless-wiki-aaa49b49372b

