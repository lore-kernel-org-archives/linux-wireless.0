Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC14496D31;
	Thu, 10 Sep 2026 20:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789071066; cv=none; b=ZiLazyxemeedExZln5CM5zNwbVIloZC9XKgSSQio1l6G3jKBFwWf9ZlEzh0yHyIiNtCoUft4Myew+Usv9I+1c0EZ4lqslITFYOpJSwOoauRNM1Wipxyte3V0/SgAVY/YvPTOC0qTDbmlWwbpyFYaiEwqLqvD9NbXFHFLeQ/hvxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789071066; c=relaxed/simple;
	bh=bcCEwcPCOJXiyy5AW1SnWiH8BnfcfMgwvNjLz7Sxsk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L18LOJca7/Gcl4ek0Ais5+RPEnAghaw7csRvmQl6DEqoWN6tNfIvt2eWnx4A0DnfMTBUdNUlirJHp7rqZRdjNsjNef05fke6uxXd0Q6sVmL+ST1cTAI5FS/GEQtbdUl6OmmWoXKagaXFNBNwl6yQE0iZEuXwksLPtj0HpJZ/I3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b=mw6CLz4T; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.b="mw6CLz4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1789071060; x=1789675860; i=f3lix.dev@gmx.de;
	bh=RIBVdWcIBz44Y9aZeuTYrmWPjciwT/W4Koek/uPyCYI=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mw6CLz4TiBoh7skuPus7WjBcYBDD45ZolWZx6u+Qo8syxmpW65/YA4Xx5ei4wnxs
	 GIf8gk/sbXmpmAS7bi/bq/5osiYfe0TuJVxN3K30K2P3HVZ9SFMweP1S4rVCDcWT+
	 Mq0alfCXB4WhdyCKI2E79h17Is0fCqSvc9S1ZM4OC9jTKkNWN4FIgbaGfhEom+hIi
	 XyBt0+XfuAoykjqi8CRWzIUuPFVmM3E9CkY5W+1qG/0UCcwfOmd+GVaeV2lDrrfQP
	 MWBmDqrny3vI6nSZHBynt4jdSWb3V+nk+mMTx3/gnh6S16PCKUSkdHbxnR2oADufI
	 hi/1rsbW8hHusqsPmg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MjS9I-1wOZXq1C26-00ioXe; Thu, 10
 Sep 2026 22:11:00 +0200
From: Felix Hoffmann <f3lix.dev@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mm81x: validate YAPS receive framing
Date: Thu, 10 Sep 2026 22:10:30 +0200
Message-ID: <20260910201030.85862-1-f3lix.dev@gmx.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VUykunAKd9Dr/EIIeWQnANQvOf8Qq5Xz1LfX7AuHrp0AVNa1jw5
 6ojFNK8iTznzc0ToAbf05PXSKK3r1NyuCUdGqOiB9hRZs+OrEEPMLDJBG1S4gX9eEArePSh
 u7tsHbKAGJJ6wg1TuifGFQz0PZ2JeYFMSKJskmjO0SK7mmR7pp12y4YrN+w8EEcZxhfXdv+
 aNW0Sa5jIQiF9NZOHkGEg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5yVDd1gPz+Y=;FT2yKcLFil31KuChMtEqrmDBy8z
 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

The receive byte count comes from device-controlled status registers, but
the packet splitter unconditionally consumes a four-byte delimiter. A coun=
t
of one to three bytes therefore makes bytes_remaining negative. If the
reused receive buffer contains a valid delimiter, the negative value is
passed to memcpy() and converted to a near-SIZE_MAX length, corrupting
kernel memory.

YAPS streams are word aligned, so reject byte counts that cannot contain
complete delimiters. Also reject delimiter sizes which do not leave any
packet data after removing the reserved metadata page.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Assisted-by: Codex:gpt-5
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
=2D--
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c b/drivers/net=
/wireless/morsemicro/mm81x/yaps_hw.c
index 3d641d23c35b..97b2ff93c69f 100644
=2D-- a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
@@ -407,7 +407,7 @@ static bool mm81x_read_pkts_h_is_valid_delim(u32 delim=
)
 	if (calc_crc !=3D YAPS_DELIM_GET_CRC(delim))
 		return false;
=20
-	if (pkt_size =3D=3D 0)
+	if (pkt_size <=3D YAPS_RESERVED_PAGE_SIZE)
 		return false;
=20
 	if ((pkt_size + padding) > YAPS_MAX_PKT_SIZE_BYTES)
@@ -455,6 +455,10 @@ static int mm81x_yaps_hw_read_pkts(struct mm81x_yaps =
*yaps,
 		return 0;
 	if (bytes_remaining < 0)
 		return bytes_remaining;
+	if (!IS_ALIGNED(bytes_remaining, sizeof(u32))) {
+		dev_warn(yaps->mors->dev, "yaps truncated delimiter");
+		return -EIO;
+	}
=20
 	if (bytes_remaining > YAPS_HW_WINDOW_SIZE_BYTES) {
 		bytes_remaining =3D YAPS_HW_WINDOW_SIZE_BYTES;
=2D-=20
2.43.0

