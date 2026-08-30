Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFFB70809;
	Sun, 30 Aug 2026 14:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788098666; cv=none; b=KChsdhFJkf/6WxZ2mBnowR4KSBcUZL3zdCUhK7hbrIoo/wcReioFW401heaeRdLYKWERjes+9Lgk5iabonO9Z33ugDWnAjHKOpT44NxmJSkumdl4yuq5ZTpSL55gcD7yOzthlQI6uU/78emtQhycEdqT6swm6Wn4ht3GOtGD+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788098666; c=relaxed/simple;
	bh=6s/LVD45pdGhRdTG39+oa/jmFG+YAdSmgTHycNEpV+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CfO/s8Vf5NC05e0qAYotHvxBDavjs3wUmprPZJsIsEWkuy8dynShalrJXcp65MsfaLwPQp3BSWnm0/f4HhMcaDiLh0KG2ZcseFV+V9O88Nk235C3LAxMRkiidbEx6ECcv8TX+ifr3SnDCsclcA6QJO8lF9a7Rge0yzvAYEcbKtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHyjhmOJRqNoGbBg--.17727S2;
	Sun, 30 Aug 2026 22:04:22 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: libertas: validate firmware block extents
Date: Sun, 30 Aug 2026 22:04:20 +0800
Message-ID: <20260830140420.26399-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHyjhmOJRqNoGbBg--.17727S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF13CF1fGr15Zw4xJw48Xrb_yoW8Gw4UpF
	yY9ry7Xr45Xa12v3ZrAw4kAay5Ka1ak3W7KFy0ya4F9rs5Xr1fZFyrXFy8Xr4Yqr4UJasI
	vF4Utry8CFykJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj9a97UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

check_fwfile_format() reads each block header and trusts its data length
before proving that both fit in the firmware image. A truncated header or
oversized block can therefore pass malformed extents to the download path.

Require the remaining image to contain the complete header and payload
before accepting each block.

Fixes: 954ee164f4f4 ("[PATCH] libertas: reorganize and simplify init sequence")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 5cc0c5cac2574..74870c9bd091c 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -798,10 +798,18 @@ static int check_fwfile_format(const uint8_t *data, uint32_t totlen)
 	exit = len = 0;
 
 	do {
-		struct fwheader *fwh = (void *)data;
+		struct fwheader *fwh;
+
+		if (totlen - len < sizeof(*fwh))
+			break;
+
+		fwh = (void *)data;
 
 		bincmd = le32_to_cpu(fwh->dnldcmd);
 		blksize = le32_to_cpu(fwh->datalength);
+		if (blksize > totlen - len - sizeof(*fwh))
+			break;
+
 		switch (bincmd) {
 		case FW_HAS_DATA_TO_RECV:
 			offset = sizeof(struct fwheader) + blksize;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

