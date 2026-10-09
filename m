Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2173C5523;
	Fri,  9 Oct 2026 07:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791530608; cv=none; b=iuEgzNhrtkZ0XTpHS6ZklIupqKeP0R3inEgM+9R2H1v5oRnv8lbpEHtHhb+oQS9Rw4pPcD5+3LO+49WXPGNeN/OiN5fSqKJxwNEfzI1D79N5WucXw6++g/8glurZfaRinEux78AbRgGZnkHuI9qO6N+e2/8JUu5n2m03351UaTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791530608; c=relaxed/simple;
	bh=AMFp/Ebr159vLz/n0Yb3+LfWedR4hlt4rlDlqUnbufk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpL3GVFpoa87vKJ4eD3YT/6yU1C7dS176332P/C7fxOQxgy6ZY065RIz7/UFQbZijxUAXEoOwcYBvrYAvFKbTDBk7afs/UVX8LlVssyzgEVCNHdFYmRa1mX5NO6HZfRpl8DW/txjIArJ5w+hMYDmU1ZcAts0WtTvpFBxB7yv/Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VrkQVqDx; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VrkQVqDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=zM
	/zoDgiq86hQBEum2co31KfW0tzv70MXIWrE2UrOKk=; b=VrkQVqDx4ImuP4ba+s
	Gws1qQJx9h+laURQV4W1sWgjNCv5urOS7qRYMkjqvYsesK9BKLCs+ppUToKpn5Ys
	fKW85o3AJbjAnvG5SDpQMOSKJTKbhbfnY2XADCH2MIhFE+33TBmx0Hb4n/hOJK8s
	h/QUZv9RXkMN15uNGsLGIPqRw=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDX_zk4lshqdCt9DQ--.25180S2;
	Fri, 09 Oct 2026 15:22:33 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: brcmfmac: drop glom superframe on header parse failure
Date: Fri,  9 Oct 2026 15:22:32 +0800
Message-ID: <20261009072232.18-1-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008103312.20-1-shxzhaosr@163.com>
References: <20261008103312.20-1-shxzhaosr@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX_zk4lshqdCt9DQ--.25180S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF43ur4ftw17uryUurWfXwb_yoW8Zr47pr
	WIgFyj9r4DJrZYkrZ7AF1xAF1Fqa1Uta4UKay8u3WfuF4rAr1ftr4v9Fyjgr1YyrsYk3sF
	qFWFvrsxJr9FgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4c_-UUUUU=
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbCxRmAvmrIljmKUwAA32

brcmf_sdio_rxglom() uses rd_new.len_nxtfrm and rd_new.dat_offset
right after the superframe brcmf_sdio_hdparse() without checking
errcode.  On parse failure those fields are either uninitialized
(the early -ENODATA/-EIO/-EPROTO returns) or hold a rejected value
(the -ENXIO bad-offset return), so bus->cur_read.len gets garbage
and skb_pull() runs with a garbage length.

Check errcode first and drop the superframe with the same cleanup
used for a bad subframe below.

Verified against wireless.git main (fd4e7f1137291), the current
wireless fixes tree.

Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
---
Changes in v2: check errcode before sdio_release_host() so the
cleanup runs under the already-claimed host, avoiding the extra
release/claim cycle (suggested by Arend van Spriel).
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 381801af3..abe8d44ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1648,6 +1648,17 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		sdio_claim_host(bus->sdiodev->func1);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
+		if (errcode) {
+			/* Superframe header is bad; rd_new fields are not
+			 * valid here. Drop it like a bad subframe below.
+			 */
+			brcmf_sdio_rxfail(bus, true, false);
+			bus->sdcnt.rxglomfail++;
+			brcmf_sdio_free_glom(bus);
+			sdio_release_host(bus->sdiodev->func1);
+			bus->cur_read.len = 0;
+			return 0;
+		}
 		sdio_release_host(bus->sdiodev->func1);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */

