Received: from sg-2-2.ptr.blmpb.com (sg-2-2.ptr.blmpb.com [71.18.227.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ADF3B19C4
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=71.18.227.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787764093; cv=none; b=e53sh4cVC+cOPWgt8bFoRmVp9Csd9utLaqC8KVdJceoGBzG2Z2UvbRz+PvQMqRl3/VLSsMwR9r2IfpW0vMRJMLqJ4CkMtfhvYrUi17qB8vMWakNXjVKNpp0wCaI7JkLpcDNMWlgUGTDZy7SD+TRA1IJGlm4ut6u/AGTlzq4dvVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787764093; c=relaxed/simple;
	bh=glCRWDETEOZd3T5Auf42nmSv6PlKlIi1zcCKql9h8P0=;
	h=Mime-Version:Subject:Message-Id:Content-Type:Cc:From:To:Date; b=aB1drFWmVzfAGS1KRBxtIxc0Bge5fW4F6HCTl/Vu+l3Bp8Q7vPlaY+lib7LG5GSuzP+zkQRoeBfX00hnzZDJ1yjia48mwyLTkPtkjQtjdnABuE+AoBzrxzDi3/mDJLiXUCftyJH2xbZi7jXr1ZdoYtS3jjNHGX30YvRuWmFOCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc; spf=pass smtp.mailfrom=cherr.cc; dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b=hDJXWGEp; arc=none smtp.client-ip=71.18.227.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b="hDJXWGEp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1787764066; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=c5Ot+JgDYQWyZUz2n6G/z2KoUJnMN+NrbAHmuQ4rCDw=;
 b=hDJXWGEpMqluZ1THie/DBE+mc4RbuWMd6DtDQSTA/3ZTS6tqOIHQr6lc3jjl1sXVSezTA8
 BAebLEwtN7q2D4/jpizfFMf9DF6QvJiBKaDdCPhA9Xv3RFa8ked8agy5wlE4C8rlpinmSI
 LzXRDQ5rxGUyGyi1WmSHODvBW1ggMo/rAFUxrqIrol8lUVbX7Fk0lb8Ww/VZ/DlhLDomai
 +H7TnUh800anpVugkFB258pImFMZimng8xHF8zwdOoN3RGoszkCQZDWG8x2gm+x6JaEuxu
 DFaOYhRP/8F/Pwb9EcaNduTKudVSx19X9wjUEuh5G4N/nWugEq1boH9/4nPFow==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFodj2oC/x2MSQqAMAwAv1JyNqBV6/IV8RBt1IDU0ooI4t8tH gdm5oHIQThCrx4IfEmUwyUoMgXzRm5lFJsYdK5N3mqDvq7QW8KLdrF0Jh2bSXNXLNVsqIQU+sC L3P90GN/3A+Co+G5kAAAA
X-Original-From: Shengzhuo Wei <me@cherr.cc>
X-Lms-Return-Path: <lba+26a8f1d60+792251+vger.kernel.org+me@cherr.cc>
Subject: [PATCH 0/2] wifi: p54: validate PDA entry data lengths in eeprom parser
Message-Id: <20260827-p54-pda-validation-v1-0-bdc2b0675056@cherr.cc>
Content-Type: text/plain; charset=UTF-8
X-Mailer: b4 0.14.2
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "Shengzhuo Wei" <me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>
To: "Christian Lamparter" <chunkeey@googlemail.com>, 
	"Michael Wu" <flamingice@sourmilk.net>, 
	"John W. Linville" <linville@tuxdriver.com>, 
	"David S. Miller" <davem@davemloft.net>
Date: Thu, 27 Aug 2026 01:07:38 +0800
Received: from [192.168.9.107] ([111.42.148.29]) by smtp.feishu.cn with ESMTPS; Thu, 27 Aug 2026 01:07:43 +0800
Content-Transfer-Encoding: 7bit
X-Change-Id: 20260826-p54-pda-validation-7b2e91f4c6a3

p54_parse_eeprom() walks the device-supplied PDA entries but some
handlers read from entry->data without first checking that the entry
actually carries the bytes they read. This series adds the missing
length validations for the two worst offenders: the PA calibration
curve data (a ~191 KB over-read) and the interface-list records.

This continues the EEPROM trust-boundary hardening of
da1b9a55ff11 and ebd6d37fa94b, which validated the readback path but
not the parser that consumes the received data.

Both over-reads were verified with KASAN reproducers of the respective
loops, and both fixes confirmed to silence them.

---
Shengzhuo Wei (2):
      wifi: p54: validate curve data length in p54_parse_eeprom()
      wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST

 drivers/net/wireless/intersil/p54/eeprom.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)
---
base-commit: 66fb95a521110da673090294561844c9f76ebe64
change-id: 20260826-p54-pda-validation-7b2e91f4c6a3

Best regards,
-- 
Shengzhuo Wei <me@cherr.cc>
