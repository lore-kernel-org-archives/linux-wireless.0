Received: from sg-2-5.ptr.blmpb.com (sg-2-5.ptr.blmpb.com [71.18.227.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D61B2EEE7B
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=71.18.227.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788115346; cv=none; b=XT8ENLThCS8oRZQQMG4zHehpsUjkqTvX6MNe81SJvvfGclH0V2aWDybTGtUPDYK2E4T6ew+X5cAOHpXv1NOb81ztAH8eBqRswAPt4sAJrdzfYk8Bmp+jUuXast60h+2CQE5PimLYs3CYT5ZoizxsHitWz0q0QN8FdSfZKGQD0/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788115346; c=relaxed/simple;
	bh=CL0/kY3bZfJVBbAxvDY0/bQoDkW/j7WSp2TzqY/TE7I=;
	h=Mime-Version:In-Reply-To:To:Subject:Message-Id:References:
	 Content-Type:Date:Cc:From; b=X+26UUwA+h1tl+mL6LzWHxaihPw1WrFefcZzm33Y1Q+/iHXkqk0Z0gpEVcgZGfSnLEGUHsjIwQEnt5l8Dvwa0PwfX5Zpv8XsnYE2t+ged8a2h103mafa5LgiKTEEyVUa6xx3Gj7IZnEyftBOtriXB4eazqSvQ3b2ri805feYvoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc; spf=pass smtp.mailfrom=cherr.cc; dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b=Mx2foPvK; arc=none smtp.client-ip=71.18.227.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.b="Mx2foPvK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1788115338; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7KRhxGIVwdrzN+rJYLkuSNUS8MiHyIi4c/SKannXfOI=;
 b=Mx2foPvKWAwGNZtoxnw0/HO9s4PNHmiDi4hNueRtO8nncKT204MTnh+BJXqjr0WPfjT3Cq
 3v6xeSetoaHr9zmhdsZYuQ8baTnsHfbaALM3uZQFICyfhU9rXFc8Fo5YI2XNtWtkQyXHVb
 a8wagT7WSobEUjNeieObXfhaqdAj0QDoCVL6eT+yrK3Kxul+C1kEr/wkPMTVhbhwRSVtOo
 thlET6oGXcIceqVGgSI3fkdvEWChk4bkSKdPZujeMG84P0uRL7MzxczvPQv3EJ2DZ+Pn12
 BiR0C+FkgtlytGJiY4mERAlsshoMP4Eg9P/Rk4ykpK307sgrUd184Ok3dY+8gw==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>
Received: from [192.168.9.107] ([111.42.148.195]) by smtp.feishu.cn with ESMTPS; Mon, 31 Aug 2026 02:42:16 +0800
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a947989+2cf692+vger.kernel.org+me@cherr.cc>
To: "Christian Lamparter" <chunkeey@googlemail.com>, 
	"Michael Wu" <flamingice@sourmilk.net>, 
	"David S. Miller" <davem@davemloft.net>, 
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 2/2] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Message-Id: <20260831-p54-pda-validation-v2-2-dae566b388c8@cherr.cc>
X-Original-From: Shengzhuo Wei <me@cherr.cc>
References: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 31 Aug 2026 02:42:13 +0800
X-Mailer: b4 0.16.0
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "Christian Lamparter" <chunkeey@gmail.com>, 
	"Shengzhuo Wei" <me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>

The PDR_INTERFACE_LIST loop only checks that the record start is within
the entry before reading an entire struct exp_if from it. A truncated
trailing record makes the if_id/variant reads cross the entry boundary
into the heap beyond the EEPROM buffer (verified with a KASAN
reproducer of the loop). The variant also feeds the synth front-end
selection, so this is not only a leak.

Advance only while a full record still fits in the entry.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Cc: stable@vger.kernel.org
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
 drivers/net/wireless/intersil/p54/eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 0dc848d77c5e..0475222d54fc 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -812,7 +812,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			break;
 		case PDR_INTERFACE_LIST:
 			tmp = entry->data;
-			while ((u8 *)tmp < entry->data + data_len) {
+			while ((u8 *)tmp + sizeof(struct exp_if) <=
+			       entry->data + data_len) {
 				struct exp_if *exp_if = tmp;
 				if (exp_if->if_id == cpu_to_le16(IF_ID_ISL39000))
 					synth = le16_to_cpu(exp_if->variant);

-- 
2.47.3
