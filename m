Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429CD49482D;
	Thu,  8 Oct 2026 10:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455645; cv=none; b=k2IIAQymA4pHiZ8RGhn9HYLYCIxHdFdRJVCJfu2JcNdjpTrtL7y6Y54QXqW4TR7faEIUTsCxS2I9xExSmuaCi+wblYeQYmsFe3r79cm0119YtvvYHnwON8I7DpLVjsI4teyU0hHhpOKFRo+qt0NlQWEomVd74zdzoK3nmdfbBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455645; c=relaxed/simple;
	bh=hS5bxT0124U8uz9dLdQG4zRLx62euPnYQNgzXbGCgH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bKO6pjwpplVW2nRrnhk+wF2BrXBytXkCKkT0rzyUUEWb6/3tWo2ysgrCSIyQJHPtp5TC/H/lMjhyAhlwzIwYEXjGYghHB1wWCQTKNnmmEjxEtkGbeTOUxuQYhuWxBw7FU2siAWaI1N89Lmo6+4gJJHMoIEA4XPfoOlb7CLQGyRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mCreN4BJ; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mCreN4BJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+q
	6qhtvLlJNNjZ7TSYmuN4nf5vzDSdKV5xGxnFbeBOg=; b=mCreN4BJsidp7CidHl
	OHWPOuMxT7O7hfEaNmQUX1XghWMy+bephFymrGkXJoHNTU1gj5+i05C4fbOFemio
	lEAKy93fc+T9RpHcepGsaigLzaVzJzhiuSlbaj549uvCY9DzBP02+evYuGrN3gQU
	03Ko+iCMuViaatBJajpCzM2y8=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnD7NoccdqzYWXCw--.18311S2;
	Thu, 08 Oct 2026 18:33:13 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: drop glom superframe on header parse failure
Date: Thu,  8 Oct 2026 18:33:12 +0800
Message-ID: <20261008103312.20-1-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnD7NoccdqzYWXCw--.18311S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF43ur4ftw17uryUtw1xuFg_yoW8AFyUpr
	WI9FyYkr4DX3ySk3yfJF1xAF1Fqa1Uta40gFW8Zas3uF4rAr1rtr4q9Fyjgr1ayrs0kasF
	qFWSvrnxGr9FgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4v38UUUUU=
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbCxQkDQWrHcWkoyAAA3b

brcmf_sdio_rxglom() uses rd_new.len_nxtfrm and rd_new.dat_offset
right after the superframe brcmf_sdio_hdparse() without checking
errcode.  On parse failure those fields are either uninitialized
(the early -ENODATA/-EIO/-EPROTO returns) or hold a rejected value
(the -ENXIO bad-offset return), so bus->cur_read.len gets garbage
and skb_pull() runs with a garbage length.

Check errcode first and drop the superframe with the same cleanup
used for a bad subframe below.

Verified against wireless.git main (9727d1c4e1c9), the current
wireless fixes tree.

Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 381801af3..53ffb8dba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1649,6 +1649,18 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
 		sdio_release_host(bus->sdiodev->func1);
+		if (errcode) {
+			/* Superframe header is bad; rd_new fields are not
+			 * valid here. Drop it like a bad subframe below.
+			 */
+			sdio_claim_host(bus->sdiodev->func1);
+			brcmf_sdio_rxfail(bus, true, false);
+			bus->sdcnt.rxglomfail++;
+			brcmf_sdio_free_glom(bus);
+			sdio_release_host(bus->sdiodev->func1);
+			bus->cur_read.len = 0;
+			return 0;
+		}
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */

