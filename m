Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.212
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805382;
	b=qSLbxjCP9IHTbgIsffnvYYXHMTPBNkTueJ58mKtXqxzMCvZO9qjgcAs3SBAJ9pSlebYK
	 wjF7NpbQnQ672Yep36xHaTMXcUx0wuu9BVzJCv0z+aPNsH+ooCR0H4ohVd4T32VomHrr/
	 VhjnXVPRTlHBtwFnrV1JNXtZF0C8gSbPi1tWpylWIMI4bBW//qHfoEkfaLJeSioLjg04N
	 jeyc+WUFtWat3SEWs0kFdQZ9c3Vz2/D/2Y0zflmCFsHLek9vdlSm8ekBuGPTZCab8d9KE
	 tysTKQBjfLTRTSB2Q9fqYQFIFYBGfKLME90kGQwhRAjeq4lZfmye9EQU/zZwP8WPb3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805382;
	h=DMARC-Filter:From:X-Lima-ML-UUID:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Gg0GU7y4BpX9CjOw9wkYKSPmsxYAjtxr8SHUj4VlaIg=;
	b=OEnRX/8yUok1OhW+SvAN5eH4nwRayDqC3zKKC+JRXwgYnoTCxqEUQRnE0EoXAMifgRxn
	 08acqj98BI3nEmgszYbuCj4Ge5MEXHDjKm7LjOqwGvAyMcP4bGNDuIPkxRZKmtm0A6EU3
	 Ax2yVFii6Huo9dNkRwtc7Pj1sfFjklm7OHEMTdjmiYN2H6XRHfzv7NC0/90Ciwyd9cjD5
	 yjO/LrwATpX2EpVAC9N31JtdLt514CbNRES+LUAlNbasLFpGNN3w4+nvkyfzTg42spSmr
	 luAZVxbZY3BsqrMpbw/8A1HX6hLgmtZsOSjPJCLb14j4ZryD+HIq1/QDAj/8uPtooVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=gfHTlQyZ;
	arc=none smtp.remote-ip=91.216.248.212
Received: from bulk0.mail-out.lima-city.de (bulk0.mail-out.lima-city.de [91.216.248.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8863160A380C;
	Wed,  4 Nov 2026 15:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8863160A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=gfHTlQyZ
From: Andre Eikmeyer <dev@deq.rocks>
X-Lima-ML-UUID: 71c5472f-e6c5-4240-a477-5538a226664e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793805379;
	bh=wIWsTUIttos50AavwboYoSeCnvp4m0UJ5HE+oI0n2sw=;
	h=From:To:Cc:Subject:Date:From;
	b=gfHTlQyZ4XOYpvHZHkiXr9fKptLI0kFAdGHiDchXtH255P8qlD+5qvNjKhHDu02dl
	 IVcGk2BuIezHAWQYBHq+eMASh7zzQhIFOyWmGXH7gEI6UPPNXCD0nJPrjbj99BXPKK
	 pVZPMx9z1er4Ja5dx+7o9SyUmgF6jHe+YB6I5BIAgAxPS5uoldFPDkHXtQ7N41VJUD
	 sZhdqjJP8V1VQ15A/Ej/mqv11YhPmfok/RPJhmltLI3QJ0WAHuLLbnFKlTT9v2hoO2
	 Mbhjqcoey7/29wSvGNrea8b3LrdQYvJ8U19a92QWEXcrJJgPm+myQkoe+Ow1O7BE2n
	 5vvIuhZ288vkQ==
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	sebastian.reichel@collabora.com,
	Andre Eikmeyer <dev@deq.rocks>,
	Lukas Klizas <lukas@klizas.lt>,
	Yossef Osman <Yossef.Osman@proton.me>,
	Aditya Garg <aditya.garg@linux.dev>
Subject: [PATCH] wifi: brcmfmac: reload the firmware after a missing D3 ACK
Date: Wed,  4 Nov 2026 16:16:16 +0100
Message-ID: <20261104151616.70623-1-dev@deq.rocks>
X-Mailer: git-send-email 2.56.0
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

Since commit 6f88e6ebdc1a ("wifi: brcmfmac: Improve D3 substate entering
timeout handling") system suspend goes on after a missing D3 ACK when
WoWL is off. On resume brcmf_pcie_pm_leave_D3() still takes the hot
resume path when the INTMASK register reads back nonzero. Firmware that
did not answer D3_INFORM can do that and stays dead afterwards. On the
BCM4364 in the MacBookPro16,1 the association and DHCP came back while
the data path was dead. On the MacBookPro15,1 every firmware command
timed out after such a resume and each further suspend failed.

Record the missing ACK and force the remove and re-probe path on the
next resume so the firmware is loaded again.

brcmf_msgbuf_delete_flowring() waits for outstanding tx status before
it checks the bus state. Check the bus first and stop waiting when it
goes down, since the firmware does not report tx status then.

Fixes: 6f88e6ebdc1a ("wifi: brcmfmac: Improve D3 substate entering timeout handling")
Link: https://github.com/t2linux/T2-Debian-and-Ubuntu-Kernel/issues/174
Co-developed-by: Lukas Klizas <lukas@klizas.lt>
Signed-off-by: Lukas Klizas <lukas@klizas.lt>
Tested-by: Yossef Osman <Yossef.Osman@proton.me>
Tested-by: Aditya Garg <aditya.garg@linux.dev>
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
---
The KaiT2en community runs this patch with its kernels, no regression
was reported.

This replaces "wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs"
(v2). Commit 6f88e6ebdc1a covers its suspend part for all chips, this
patch handles the resume after it:

  https://lore.kernel.org/all/20261001085308.1688049-1-dev@deq.rocks/

 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 22 ++++++++++++-------
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 16 ++++++++++++++
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 069ba701665..f002eda5171 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1445,13 +1445,26 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	int err;
 	int retry = BRCMF_MAX_TXSTATUS_WAIT_RETRIES;
 
+	/* no need to wait or submit if firmware can not be reached */
+	if (drvr->bus_if->state != BRCMF_BUS_UP) {
+		brcmf_dbg(MSGBUF, "bus down, flowring will be removed\n");
+		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
+		return;
+	}
+
 	/* make sure it is not in txflow */
 	brcmf_commonring_lock(commonring_del);
 	flow->rings[flowid]->status = RING_CLOSING;
 	brcmf_commonring_unlock(commonring_del);
 
-	/* wait for commonring txflow finished */
+	/* wait for commonring txflow finished, but bail if bus goes down */
 	while (retry && atomic_read(&commonring_del->outstanding_tx)) {
+		if (drvr->bus_if->state != BRCMF_BUS_UP) {
+			brcmf_dbg(MSGBUF, "bus went down, aborting wait\n");
+			atomic_set(&commonring_del->outstanding_tx, 0);
+			brcmf_msgbuf_remove_flowring(msgbuf, flowid);
+			return;
+		}
 		usleep_range(5000, 10000);
 		retry--;
 	}
@@ -1460,13 +1473,6 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 		atomic_set(&commonring_del->outstanding_tx, 0);
 	}
 
-	/* no need to submit if firmware can not be reached */
-	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_dbg(MSGBUF, "bus down, flowring will be removed\n");
-		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
-		return;
-	}
-
 	commonring = msgbuf->commonrings[BRCMF_H2D_MSGRING_CONTROL_SUBMIT];
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 17bae04c14b..21bf3168df3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -346,6 +346,7 @@ struct brcmf_pciedev_info {
 	struct brcmf_pcie_shared_info shared;
 	wait_queue_head_t mbdata_resp_wait;
 	bool mbdata_completed;
+	bool d3_ack_timeout;
 	bool irq_allocated;
 	bool wowl_enabled;
 	u8 dma_idx_sz;
@@ -2659,6 +2660,10 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 		}
 
 		brcmf_dbg(PCIE, "No D3 ACK, continuing to power the device off\n");
+		/* Remember that firmware is unresponsive so resume skips the
+		 * hot-resume path and does a full remove + re-probe.
+		 */
+		devinfo->d3_ack_timeout = true;
 	}
 
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
@@ -2680,6 +2685,17 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 	devinfo = bus->bus_priv.pcie->devinfo;
 	brcmf_dbg(PCIE, "Enter, dev=%p, bus=%p\n", dev, bus);
 
+	/* Firmware that failed to ACK D3_INFORM at suspend cannot be
+	 * trusted even if its registers still read back sanely: it may
+	 * keep the association up while the data path is dead. Skip the
+	 * hot-resume path and force a full re-probe to reload it.
+	 */
+	if (devinfo->d3_ack_timeout) {
+		devinfo->d3_ack_timeout = false;
+		brcmf_err(bus, "Firmware was unresponsive at suspend, reloading\n");
+		goto cleanup;
+	}
+
 	/* Check if device is still up and running, if so we are ready */
 	if (brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->intmask) != 0) {
 		brcmf_dbg(PCIE, "Try to wakeup device....\n");

base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2
