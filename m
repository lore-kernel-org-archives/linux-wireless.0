Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF7416D17
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792354233; cv=none; b=iCDCM4iLj/mFZVCd0H5sfE3SPPnBwR5lwHdF6HM9zCMghq8L0wRzM8hkjKEFOWM8bAysAQ26y2vlv0LvvLmJV14o9E8vK0X72HnzpQMo3/aubjFWSgNjYutoKEK97HJy/JXm2VUA3Tpoyce8TNiJHdE/xDopC7pU6rmDMvNSlaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792354233; c=relaxed/simple;
	bh=qDDLogA45xqcBTJYZNnqpaQa9YaHc0IMnaFK3jYXOII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RKEMdLYj0Tj66Z8I8XfUYe6GuJLtm6h+AwDfzHYjYpsZDWuUBClbRRfB7AuVfMQpBHNDp2L32sDbgcyG6O4ZDdYPp5d5VKpbnrjtKAWpeIUWvwK99AN8fD/tn2oHsJSbnEXOQYp3PPdSSAGhXk41KOE2TGG4/Gy+my0Io1/oK/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8FnrP9n; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8FnrP9n"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso351301eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 13:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792354232; x=1792959032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pPc2vAbvehS3Oz5/ZhIFzrQ08Sy8cgXQhioY2HvI4kc=;
        b=M8FnrP9nKjVQjYK69ou27E9uIkVSN1+INc67hzTHgPMK9Y2xumsGGVrPEanFv0oq2X
         H3zVl5TsYyidV36HfwFLT5izcDg5v8qeWVL4mzbXS8WfDImKjWkIp2wSl8veNR19cOQ5
         345hnJvmlLtdv2qgrurktRp1I4UiXhl7n2NBsGyMvtGUR5RHSALoznjieLCy1I3Qz6R2
         eHE0R1n0jd7xbRC4r4RSxiVTKcPQrx/KCIym0ZMYnx1EDlDKKe6EW8QB0mzJHnBLcU/1
         yf8gCd+jWbG+eMQovWxNFzA4OLZCxlSwKaSSw0AQ4h28d4Iri90z19wwJcI8SlQ5R2Yv
         Govg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792354232; x=1792959032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pPc2vAbvehS3Oz5/ZhIFzrQ08Sy8cgXQhioY2HvI4kc=;
        b=SVV18nKZufNhjtnwmVPjz/PQlmb+KVMOfX84sDiEDUEGbjSvAhHC+GT2fsnxRuwQ0M
         Vf58t/3ihMJbw7/ArCI1bmarArIFQv7HQ6xylgz+wiIzA8l3fKPyKco+7yh0OCwEv91J
         oCvM19ljGWQyd8ytGB4hMYDacfLWdfjq6grA3QfS7Zf4Ymsy9thuMSYyXa+Y11NpzACX
         hsADKNPDV4MMTQB3OAmhlsifPDY3hpOSVbnoV6e+nBAl7yf5fXBy167AjUNdODg5v/fx
         25T4CBv1rAnPJXxUTyzuafDEdC79FGMxz2PJqEfuBEnJysJGQ0m8OZVh55XyIt+lttC+
         r00A==
X-Gm-Message-State: AFq9FYK5/csWoMkdByjBRgrv/RvxmMUSHQKuF5rU785WWEBspEAp3/56
	KdV5uzWV1FQKXIjnh4PPsGDis5WpKHM92GxG7NodNc4iC8ujDZha0Bp1UPdq1FUU
X-Gm-Gg: AYBFou0Si4xOJn3UBB7uRxh51UcU84kwSDSDVEwaSf5UfF4x4oB7SyLHMIlOGY3BuES
	78+JI4fyb3leVq0etMQvAFPIHD1ly9qOBYrrBqKq+jK6AXX8Bj0J+cBE45yTH0SlOR27j/ENFh9
	s+Q+48Z/ofPEdG03ZcH2MTjzpxjUymKOrDZJkSwHcHTAd4nvJOIzaFonVoAvG3lN7MWYlgefXI/
	9oDmk2WI0xo+Bfs6ACMfcSe4BY9/PRBdU3GmntsDm4otaqdX5QePg8fNYvot88mHjhDjkZ1Ep72
	lZS+C9liihWId3nP5O4snMXg/0LyTI3fotlMKISyThnPmZnGooeWLmx6U58U0BEzY9CB8QZmi8M
	c6gVoaYkFhWkYZR/urgmpQyzMnCgO3zBgaBuN6JXIxTf4aUhneMwzQKtiFL+FAio1Qhr9VI2JbN
	gnRff5SN1w78TKdXL2a4rUy+KnEYwMlJYdQZmO93asmTnzI5AaDDOl4UPdwVWL4Ol4Z4AhJp+JI
	uon+40EAWQy4tz3OUUA0LPZc1FBAwUaOa/EedgXX+uAOEBLqq3aEpo7Nd0pIMJnF0iE3Lc7z56p
	vGdHTNJa0DrOjzgnwlayNr2IXX1JKO8ANp1ouh6dwiN9gw3+
X-Received: by 2002:a05:693c:66c1:20b0:35c:85fa:5a61 with SMTP id 5a478bee46e88-361a264acaemr8556476eec.38.1792354231532;
        Sun, 18 Oct 2026 13:10:31 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608308a87csm43715457eec.28.2026.10.18.13.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 13:10:30 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: write the HT-PHY TX power estimates as 16-bit entries
Date: Sun, 18 Oct 2026 13:10:29 -0700
Message-ID: <20261018201029.50082-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

b43_phy_ht_tx_power_ctl_setup() computes the 64 power estimates per
core in a u32 array and writes them with b43_httab_write_bulk() as
16-bit entries, which reads the array as u16. Each table then holds
the low half of an estimate in every even entry and its high half, 0,
in every odd one, and only the first 32 estimates are written. The
hardware TX power control maps half of the TSSI readings to a power
of 0 and raises the TX gain towards its maximum.

The wl driver writes the same 64 entries of tables 26-28 as 16-bit
values, which match the ones b43 computes. Use a u16 array.

Fixes: 5949e0406041 ("b43: HT-PHY: setup TX power control")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_ht.c b/drivers/net/wireless/broadcom/b43/phy_ht.c
index fab8399c64f7..b63e7734db6f 100644
--- a/drivers/net/wireless/broadcom/b43/phy_ht.c
+++ b/drivers/net/wireless/broadcom/b43/phy_ht.c
@@ -714,7 +714,7 @@ static void b43_phy_ht_tx_power_ctl_setup(struct b43_wldev *dev)
 
 	for (c = 0; c < 3; c++) {
 		s32 num, den, pwr;
-		u32 regval[64];
+		u16 regval[64];
 
 		for (i = 0; i < 64; i++) {
 			num = 8 * (16 * b0[c] + b1[c] * i);
-- 
2.56.0

