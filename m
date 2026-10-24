Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=Fhh+lbXuMM0lGoiThVLmRukESF4MdXEQzoeGp8364ea88XMAqGqGQJfJIKesqs1wL8vu
	 ipH0OCYFnsXK4BSVqs+N2MxxcmPnA/43BWD7gV22t4e1JNO7O8XN0SZNeIY4fVE/0sxRt
	 OZjRCLZPA+EQfkWtODn6UWgJhSH+FUT4H16p/kQLnOXRqtoLQdHAOC8D91hgPThHGV28R
	 a30RUEXuzUAqkoc3rplUTlmZeFu1MXo9alynerySOIssaV8vV8re3X7XTjT8tDXIK8Ckl
	 tZ4sfZRNJqwSj5LudqNhwYro9Xzveg7xfcwG1zsSEhBq2GVQkr/26Q2FTy5DvaK5LKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zTgW6yjVPTwXgwtGqkZnxhWwwppW4Aqr6+auDuFDHOo=;
	b=3AkqHlOJLXXiJi8pHmYZi+4rzUFeH3TqqxaLM1iQj7KMybYvdZhajazwNDyqkEwxmBe/
	 KKMCOIm9FkfOQ9FbpB4EJ6xbgvk1IFj+t+DtQZeNIHIRARWwOXw1sSP2pDDLdJdiTwh8m
	 k/syq8gCAEXViwmVMX3MDj7wiYuzOY2RFkEF2CzGcoIlHVwGhPcFlB7YNvtJTEJ5fic7p
	 NvKH0jG3JZWfYl/ghafaKea9CnDOTMc2/TV1iJ3pKLa3JL+Z2bKvfYlJP/7mJOUXSNfQd
	 3E4+pxJDEMZifMpP5e1n/KOXiFjnys6x9YQVl2vGFB/Fxzz2+XImQGMak9U2Pvwhi/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=cyvez6Pu;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DBE606A321
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95DBE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=cyvez6Pu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zTgW6yjVPTwXgwtGqkZnxhWwwppW4Aqr6+auDuFDHOo=; b=cyvez6Pu9UNnkhzakFHwsGFBip
	raXEpOsX/q3ya+xUBncfu37NM2v9vSEF2UYN+JaUW1HfzSGHYtEeRBxuKRPY2MtyHa5vCY89m/HJf
	2daPyEaZSBIiXX9DCQbB47PsPMiEOjMq2trJgO/B5pbmYWGEkiLUpNgQvBrJm1jiXfvk=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2Q-009vQq-0Y
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 07/11] wifi: mt76: mt7996: validate the RAM firmware region table
Date: Sat, 24 Oct 2026 09:19:23 +0200
Message-ID: <20261024071927.2279668-7-nbd@nbd.name>
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

__mt7996_load_ram() only checks that the firmware image holds the
trailer. mt7996_mcu_send_ram_firmware() then walks the region table and
sends each region without checking either against the image size. A
malformed image makes the driver read past the image and send that data
to the device.

Reject the image with mt76_connac2_fw_check(), like the connac2 RAM
loader. The mt7996 trailer and region layouts match the connac2 ones.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 590931207d79..d2d4253e2ccd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3576,7 +3576,7 @@ static int __mt7996_load_ram(struct mt7996_dev *dev, const char *fw_type,
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(dev->mt76.dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
-- 
2.47.3

