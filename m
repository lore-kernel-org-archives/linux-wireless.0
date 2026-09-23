Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C596639023A
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790195628; cv=none; b=Jkgy8FcDvGDSCMsVqdzRRa0abEDaQEDHxNh/RlE1Or0Ry3Svk5DmHtvc7fy8g9x1gkfqnU1ZEe7LNcBCgMfmC2sRRgUj+MMyfbmKoq5L0wsraeDJGmywnrzEmqe6dU1WSjmJPax4fhZahngZL01MZ9ZTHKO68paRMWddpkvCB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790195628; c=relaxed/simple;
	bh=/JJF6ssyxAQdmL0bSTx1Ono3iYU/qejhw/WQLlUJjoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g9OyndCtLW22yS9QyneqkQ36xva2X/xyHblQ5CFYCq8/PflCawRvNWhpUwgfwBQ6S13xmRVuRlgDrxiZMAebHrYoeCz89AbKwlDcwBw9oU4Lvy9Cye/pWq2CaQ4XPv2adDVjmlOm14/w2v0B7VViaitpgkLUu1m5pp2SCnVNsfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=posteo.de; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 87350240029
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 22:33:38 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hqpZn2flvz6twP;
	Wed, 23 Sep 2026 22:33:37 +0200 (CEST)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <mbrugger@suse.com>,
	Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 0/2] brcmfmac: firmware: Add missing clm_blob firmware files
Date: Wed, 23 Sep 2026 20:33:38 +0000
Message-ID: <20260923203253.2553179-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I noticed that these firmware files were missing inside the initrd when
including the brcmfmac kernel module:

```
/usr/lib/firmware/brcm/brcmfmac43436-sdio.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43436-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-a-plus.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,500.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,4-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,400.clm_blob.zst
```

These changes should be backported to the stable kernel releases as
well.

Benjamin Drung (2):
  wifi: brcmfmac: Add per-board clm_blob firmware binaries
  wifi: brcmfmac: Add clm_blob firmware for brcmfmac43456-sdio

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.53.0

