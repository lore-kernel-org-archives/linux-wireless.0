Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=mCZI4Ck/DgZHPU66B2ZoafiezubXg2wK2+2iCRTMRcPsqJ69cR4quddmXJIAnEgRsdCx
	 0kYcqG9pTvqk5UFqkhZdF1C+W7DB1WHCwLXHlxoqiCA3C12OIUuIb8p/amzkSWuZTitxm
	 ctw+R9QrnxJwz3GE6gILFZyZ4QYvoKQEi168PE7IjhomCbMZqI1HegUwGHsx8kTd8lRxw
	 buQFGMvQ4Pl2CigewY9niqR4sRdUONbh9JJevpmczAbNBc+mTJLHIIi/Ua0vVn3M6Qn8r
	 afiOjmip8lXqR/1cAJBmNj9S68KwJXYRp7abQzVLYLULnhcRsguneRBpsQZzQkvhTng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ck1i9mrthuEWUR+bvhcpDyQ1dzhQpfuGmSfhJsRUw7Y=;
	b=Gf7DqUcl0pYb4ULixfvl+V/8G7+X4E+ofZdQwd7DICJkSRB0I1UFIJSErnTXMoJ3EyFO
	 1Z/FwPTOo6ygGAtw6xwtm+cQ/G7El5v77g2NwmBUU3xgrpe5npdscctsS8HjYzR109Kjc
	 Xz190DW9mEpcHyE7phTOr10EcZOCZ00rOiT/i4BkrxHqwhWaWVt0pGM6DapiYYb15PGKH
	 yLmqOXXDDTu4Ei1QmJwHB4IMhboVO0PdIDFKzHOH5WYOIOyetVvgJSQGUs2RdnlxnkX02
	 rXWD1XRkCUaY4pfc4mHa3htziv9192IiWOSfLumGywLaLyAgvqeEbq7VWnIaKfRop6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Y1lYvs0y;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE13606A326
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BE13606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Y1lYvs0y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ck1i9mrthuEWUR+bvhcpDyQ1dzhQpfuGmSfhJsRUw7Y=; b=Y1lYvs0y3ijfezlC3ZNicU3FzI
	wakRZQtVO3bRpdEicGtO7bEe3Nbu8/eifRmci6NLMuXFbMM/3i/Invcp2OrvLcSqXafaKNc3cirOc
	MuewmqdvmY0HuaYCE8iR7VyDPyaTtDjdDPcyr1JvyfuhQ54Gy9qo4oZpCBdfgOe9kaOg=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2Q-009vQq-2D
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 10/11] wifi: mt76: mt7996: validate the ROM patch section table
Date: Sat, 24 Oct 2026 09:19:26 +0200
Message-ID: <20261024071927.2279668-10-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024071927.2279668-1-nbd@nbd.name>
References: <20261024071927.2279668-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_load_patch() only checks that the patch image holds the header.
The section table after the header, and the offset and length of each
section, come from the image and are not checked against its size. A
malformed image makes the driver read past the image and send that data
to the device.

Reject the image with mt76_connac2_patch_check(), like the connac2 patch
loader. The mt7996 patch header and section layouts match the connac2
ones.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d2d4253e2ccd..e3420ac523ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3447,7 +3447,7 @@ static int mt7996_load_patch(struct mt7996_dev *dev)
 	if (ret)
 		goto out;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_patch_check(fw)) {
 		dev_err(dev->mt76.dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
-- 
2.47.3

