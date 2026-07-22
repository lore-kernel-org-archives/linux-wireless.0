Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DE41DDFA
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 20:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750660; cv=none; b=rNxmqpbxlZu1TSo3LdvXYYweSOgevj+x1hkYyNzrDHSxsrQgPJkA2uxneRQXgpkg9JcaXHQTsOVAq7bhMaz0JzrpBAxZk5XensqRg35hEKOI2OREqAw6qysAxRPxeT/xgP2ib6o0Auz0EGbnffsoIWO01EyCH+g02sFqt+92RNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750660; c=relaxed/simple;
	bh=+x/L9tozxiPYSdBYe/OPTMOjRpHMkavxjlKnSt0QD4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5zbWCweUGx4toEIP8gkdUcOOk4wVsXL1VhW8J/g/EoX12tO+OPMZC6uURQFce70iiqjJWPInJ06Yj4ECcDT9r1lrMF2oaWA9+L1Mc1eKO8tH0tc7hNRUZZPnIU8dQhONX0avmA+yCr9krIHGWG3q1tPCW+ZGzNHBHjnCV/6LHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dZhCU8uI; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dZhCU8uI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784750655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nY9GkOWHccU32SJDWygShs1guXvVfjz2R8t+zqPkMnQ=;
	b=dZhCU8uIeUY++PnurUKvI7BkiJYh/pX8wdoXx3buvRoDxQBFovBh3DUvVEBr2V6tVVzK2x
	foFV3FVGRdFMDlm4pu0iiMcjbAcgMMeBiJK+GZ2mqEr1xREtqxePvk+P3ER7S5YeteMv+r
	I9CSjEVDpwvpDA/vXylpeIElG2CGPCM=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 4/4] MAINTAINERS: add entry for the RTL8723B rtw88 driver
Date: Wed, 22 Jul 2026 22:03:31 +0200
Message-ID: <20260722200337.135150-5-luka.gejak@linux.dev>
In-Reply-To: <20260722200337.135150-1-luka.gejak@linux.dev>
References: <20260722200337.135150-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS support in
rtw88.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15011f5752a9..712b802d6612 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22735,6 +22735,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/realtek.yaml
 F:	drivers/net/dsa/realtek/*
 
+REALTEK RTL8723B WIRELESS DRIVER (rtw88)
+M:	Luka Gejak <luka.gejak@linux.dev>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/realtek/rtw88/rtw8723b*.c
+F:	drivers/net/wireless/realtek/rtw88/rtw8723b*.h
+
 REALTEK SPI-NAND
 M:	Chris Packham <chris.packham@alliedtelesis.co.nz>
 S:	Maintained
-- 
2.55.0

