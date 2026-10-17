Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332E03B47E0;
	Sat, 17 Oct 2026 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792223175; cv=none; b=kdiqf1nRuVV/R0DT6xV9mjLDe/EoSjGr3bQ/Nu71DK/CZ/o9y7//Ii22iOnuUIlPamQ+rD1vvhArh1sn2QWXtg1C/8/KBm67U6bDmj2Qnrf8oFogMzhgKT5DJyg+lGW8lSs1qOBZTxYNh6M3MqtHsuGihJGQf0divFSMv+m64Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792223175; c=relaxed/simple;
	bh=H07chQ95+I6ytt0i40CO0sn9UXLKnstU8KGtG50XK/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YKQ39eN+ivOvXYwQNio+yGD5OWsB4QHTSlLS7cRALX4zSf3NcsOdYZpq2TMh2Z5ILChRXUzjxFe4vIPBw0qZ2z3JBab16XwYHWEsahfBHlegEM2Gdl/5zaJXYchOz9Upk5H2Ag7p1bmg6NqqFX8KVFC7/yBzNoEYRD9xghVmHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=vgCPAEdh reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="vgCPAEdh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-Id:MIME-Version:Content-Transfer-Encoding; bh=Mm25wHBCf/
	/OJi5/+BFN0Xm8rZsFO3NmPjNryFAtrTM=; b=vgCPAEdhqQmjS2yHBZwjs73mwk
	uB4eE2EuuCCwvZp992ytMhmFQLqX+0lb/hPDp73AVQyJexqhv597848oNghMzBKN
	SOnLVNdGXbqfdd8ToHgXqrTLhnRCGyJTRrlx0uj2iyQrYLnDf+CQb4ZGjPh6UH+t
	ey/zwZeFnFb8+D5eQ=
Received: from user-virtual-machine.localdomain (unknown [113.200.174.50])
	by hzbj-edu-front-3.icoremail.net (Coremail) with UTF8SMTPA id BbQMCkAmLwKtJ9NqSequAA--.64257S2;
	Sat, 17 Oct 2026 15:45:50 +0800 (CST)
From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>
Subject: [PATCH] wifi: libertas: cancel fw_timeout on disconnect
Date: Sat, 17 Oct 2026 15:45:49 +0800
Message-Id: <20261017074549.57694-1-25031212351@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkAmLwKtJ9NqSequAA--.64257S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyrGF1UJFWkWr15ZF1UZFb_yoW5CFyUpF
	WYk3y2yr1DZr1aya93Ja1kAwn5Zan5Ja13Kr18uas3ZrnxJr1SqFWF9398WFy3XF4UAa42
	qFs0yrW7GF98G3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9vb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq
	07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r
	18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vI
	r41lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4AK67AK6r4xMxAIw28IcxkI7VAKI48JMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8i0ePUUUUU==
X-CM-SenderInfo: ysvqjiysrsjkur6v33wo0lvxldqovvfxof0/1tbiAQUJD2rSPdFn1gABsm

if_usb_disconnect() frees the if_usb_card structure without ever cancelling
its fw_timeout timer, which can still be pending in the timer wheel at that
point.

That timer is armed by the RX completion handler if_usb_receive_fwload()
with a five second deadline while a firmware download is in progress.  The
only place that cancels it is the asynchronous firmware download callback
if_usb_prog_firmware(), and it does so before killing the RX URBs:

	wait_event_interruptible(cardp->fw_wq,
				 cardp->surprise_removed ||
				 cardp->fwdnldover);
	timer_delete_sync(&cardp->fw_timeout);
	usb_kill_anchored_urbs(&cardp->rx_submitted);

Killing the URBs does not undo a timer that a completion handler which was
already running re-armed in between, so fw_timeout can still be pending
when the callback returns.

If the device is disconnected at that point, for example after a
USBDEVFS_RESET forced unbind or a physical unplug during firmware download,
the card structure is freed with its timer still queued in a timer wheel
bucket:

	BUG: KASAN: slab-use-after-free in enqueue_timer+0x236/0x250
	Write of size 8 at addr ffff88800ed324c8

	Allocated by task 1623:
	 if_usb_probe+0xc8/0xc60
	 drivers/net/wireless/marvell/libertas/if_usb.c:205
	Freed by task 1686:
	 if_usb_disconnect+0x1c6/0x270
	 drivers/net/wireless/marvell/libertas/if_usb.c:322

	The buggy address is located 200 bytes inside of
	 freed 512-byte region [ffff88800ed32400, ffff88800ed32600)

The offset corresponds to fw_timeout.entry.pprev, so the timer core later
rewrites the list node of a timer living in freed memory, both when
enqueuing another timer into the same bucket and when moving the bucket to
the expired list in run_timer_softirq().

Cancel the timer in if_usb_disconnect(), after if_usb_free() has killed the
RX URBs, which stops the completion path from arming it again, and before
the card is freed.

Fixes: 4f82f5c853e3 ("libertas: switch to a waitqueue and timer for handling USB firmware load")
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 5cc0c5cac257..3410d6850db2 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -319,6 +319,12 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
+
+	/* A firmware download in progress can re-arm fw_timeout from the RX
+	 * completion path, so make sure it is gone before freeing the card.
+	 */
+	timer_delete_sync(&cardp->fw_timeout);
+
 	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
-- 
2.34.1

