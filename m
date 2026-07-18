Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF538279903;
	Sat, 18 Jul 2026 02:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.187.6.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342703; cv=none; b=eC80ik+Vf6/VrWa2fijozGW1WidK4OsB7f76o0RwFiaLsVqIZI57njaHZxFjGmeX2QuaUQjCtNSuZhjAQ00TLi84jP2pvWSd8i3fmU07wo3sWaMp+8Qa5k3V23egapCcsiT/JEWAI3gvtBDJsdlu+nsNILAzd/GqEJPfhCtlSv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342703; c=relaxed/simple;
	bh=g8BdcmlyHQIpJWnjB1ljvV5xw3uxzmXlEnQdQ3j3Vr4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZaHg7bYknVIn0X6M7qiMhHd8QLfGIllU/MZdNnZdwKAKiEiwMAKtYOvv2IFpbsn+F8h4w5T+hi+c0NrJYq828vRqaov9bYbOfiquASw6Mhyo9u7gjDcwvInxMxS2mOXd+WIctZCFLO7c0x7n+RZUsZR7NosIlyRj2PTP6Go0gf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.187.6.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wDHLzyi6FpqgikLAA--.13136S3;
	Sat, 18 Jul 2026 10:44:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgBnMXWg6Fpq+aBHAw--.27942S2;
	Sat, 18 Jul 2026 10:44:48 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: arend.vanspriel@broadcom.com,
	kvalo@kernel.org
Cc: eddiephillips@google.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	wright.feng@infineon.com,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	SHA-cyfmac-dev-list@infineon.com,
	linux-kernel@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH v2 0/2] wifi: brcmfmac: fix bus_reset work lifetime and scratch-buffer DMA double-free
Date: Sat, 18 Jul 2026 02:43:51 +0000
Message-Id: <20260718024353.3147201-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgBnMXWg6Fpq+aBHAw--.27942S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?6XT4nQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WN9z1vMBPf31kB5rJtB208xRAe6WXmf9rU7cGu361cagswD
	49fJYyanNG7eGj/tRo/N5RPxYw6l01w8CbPzC/8w
X-Coremail-Antispam: 1Uk129KBj93XoWxJry8uF13WFW8ArW3Zr1rKrX_yoW8tF17pr
	WagFWYyr4DWrWfKFZ3Zr47ZF1Fkan3t34vkr4fXayxuF15Ar15JrWIkF4FgryDCrWSy34a
	qr4UX3WrurWqyFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU818BUUUUUU==

This series fixes two narrow reset/remove teardown bugs: a use-after-free
where the bus_reset work can outlive drvr (freed on removal via
brcmf_free() -> wiphy_free()), and a DMA double-free in the PCIe
reset/remove teardown.

Patch 1/2 makes brcmf_pcie_release_scratchbuffers() safe to call again
after a prior release: it freed the scratch/ringupd DMA buffers without
clearing the pointers, so reset teardown followed by remove() could
double-free them.  Split out as its own fix so it can be reviewed and
backported independently.

Patch 2/2 drains the bus_reset work item on device removal.  A per-bus
mutex serializes arming against that drain
(brcmf_bus_cancel_reset_work() sets "removing" and cancels the work
under the lock, before any free), and brcmf_fw_crashed() is NULL-guarded
before it dereferences drvr.  The mutex is safe because every arming
producer runs in process context (the PCIe firmware-halt notification
runs in the threaded IRQ handler; the SDIO one in the data workqueue).

This series does not attempt to address the separate, pre-existing
lifetime of the asynchronous firmware completion started by the PCIe
reset path.  That callback needs its own lifetime/ownership protocol and
is being tracked separately.

---
Changes in v2:
 - Following the v1 discussion with Eddie Phillips and Arend van Spriel,
   retain the mutex approach.
 - Split the scratch-buffer DMA double-free into 1/2.
 - Add the NULL guard before the drvr dereferences in 2/2.
 - Rebased onto wl-next/main.

Link: https://lore.kernel.org/linux-wireless/20260709101635.103005-1-fanwu01@zju.edu.cn/

Fan Wu (2):
  wifi: brcmfmac: make release_scratchbuffers idempotent
  wifi: brcmfmac: drain bus_reset work on device removal

 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 13 ++++++
 .../broadcom/brcm80211/brcmfmac/bus.h         |  6 +++
 .../broadcom/brcm80211/brcmfmac/core.c        | 46 +++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 14 ++++++-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  6 +++
 .../broadcom/brcm80211/brcmfmac/sdio.h        |  1 +
 .../broadcom/brcm80211/brcmfmac/usb.c         |  3 ++
 7 files changed, 83 insertions(+), 6 deletions(-)

--
2.34.1

