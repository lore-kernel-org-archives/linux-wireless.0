Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877CB3B42E0;
	Sun, 30 Aug 2026 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788094098; cv=none; b=OunFTA8S9OmEWRi4om7mcCQFRkn1IDQd7AhyuvvnkOCoCRb1gxhHM5uF6k9QHp+8BrIx7MnyufT3paAHqJfHYcLx6X6Au5Hk405Atsj7Xrkge2fSbHox/4QbYDo1cnpa4oiREp7mB9LhqRz+SaHEoVPyREU2mqndxd6jFZDBfCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788094098; c=relaxed/simple;
	bh=CzA/c/YGzrlWgQufDdsCxm2/n4eXqNKN6wnMCOQ01b4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AA7hLHjCVMiotrEQ9Gw12143KMbk3LpHQIbMPYJv2OUwZwLPrWh4XIqn+hR5f9mkBCG2XT8uFpWsukGAtA/BEhJBafsaXe2hcNEkC9awmzdf9/uqvtm5fY+EUVE7UTTTCKpH9H6vrC0CEO8qlY3h7qjx8QWjhAWTo3tMbpdKxxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADH0T+MJpRq05maBg--.47695S2;
	Sun, 30 Aug 2026 20:48:13 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: libertas_tf: validate firmware block extents
Date: Sun, 30 Aug 2026 20:48:10 +0800
Message-ID: <20260830124810.97223-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADH0T+MJpRq05maBg--.47695S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF13CF1fJFW8tr4rXr4fXwb_yoW8GFWDpa
	4FkFy2qr45Xw4jv3ZFyan5ZFWrWa1fG3W3JFy0ya4Fkrs5Wr1rZFWrXFyfXr4YqrWrAasa
	vr4qyrWUCFykKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYwIDUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

check_fwfile_format() reads each block header and trusts its data length
before proving that both fit in the firmware image. A truncated header or
oversized block can therefore pass malformed extents to the download path.

Require the remaining image to contain the complete header and payload
before accepting each block.

Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index b85c6d783bf7b..b9d1a33bddfce 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -769,10 +769,18 @@ static int check_fwfile_format(const u8 *data, u32 totlen)
 	exit = len = 0;
 
 	do {
-		struct fwheader *fwh = (void *) data;
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

