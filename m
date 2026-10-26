Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793022804;
	b=fhjyKv6fhWsMyf8Q7/HhFSmZUcQpRRv9xTBCL0fuPGV2PWXDu6FoOCH2mPlqhTFXh7Yc
	 GS9sKm5fxmtYwKA25kT4ZbtPi+b42rwzMk3acqh0uf9iD/J0XuBqOPyeQAo1583c7GnwS
	 dWX1+vNfMvRlcCZ/i86bOX1hEF1BCttFe9YNMlUwHO+tsrxCokw9iX+s+GYExkG2laxKI
	 MWaq4G9ryvSKeJC/5QKesJv5Bh2GBi9VZzWR2cf/9AMpr+UY1nxiVoZ5pb3/sqiDejOce
	 UcSZx6ZvCmanFpOZivonNRTSXoaBb2+RXuNYtp2mr07/Ku5M1JO3lStE89ZKfheeCZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793022804;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=t/AHGlUTqB8q3K6xZ5qjexD1QA86eCDEpSxha7I1bw0=;
	b=EfMRSuWUc1gJI4NAkiwdGIpBsOJKf1r5FzNxA6oBk3AB8Hr66TssinOJx2NdWZSZDgeW
	 0OHRpg5D74ARC5rjSQHSZ1SJ9ZX+cdtG9raM5qnQNvlyTEcwopKmim+Zi7wW2FQXVXsam
	 sgmAq9dnfme0TPDO+JEE8yABRySVIwpe9fSA294yMcYhaD6+7w0w0iwHZznjU6Xs/yn9d
	 Vub7S5xohroUMckmJWZjuIU3+EznH37wRjGilgLvKKtfDlM69XqGVoFcnkjvaXWuibl/u
	 LZn0ub8hFjjZ8IfepFoDVWNzsL/ajmwFeCc3wf1KTLWZee89Iv7UlxMT8c1ZTfKMryQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=ph6vSlfH;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FEF606A31D;
	Mon, 26 Oct 2026 13:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77FEF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=ph6vSlfH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=t/
	AHGlUTqB8q3K6xZ5qjexD1QA86eCDEpSxha7I1bw0=; b=ph6vSlfHNJR1E6mOmJ
	v3PElvHKLl+L3Oc/zxHUJ4JvaALbS5bKbUCGd4W6Kg3cffxr6qYn4+0e9ebPOfuL
	yAlB0fybEBBXgLKXI5v9uQUkmCmQXeSNOhbGEvpEl72+ZOnlSzmEhva5eELB9yDT
	VH5pP9Yna/fOSUrVgPdBMmCzo=
Received: from flipped.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3fzFDW99qIs6vCg--.23953S2;
	Mon, 26 Oct 2026 21:53:10 +0800 (CST)
From: Sicong Huang <congei42@163.com>
To: linux-wireless@vger.kernel.org
Cc: stas.yakovlev@gmail.com,
	linux-kernel@vger.kernel.org,
	Sicong Huang <congei42@163.com>
Subject: [PATCH wireless] wifi: ipw2x00: fix use-after-free in QoS activation work
Date: Mon, 26 Oct 2026 21:53:05 +0800
Message-Id: <20261026135305.389366-1-congei42@163.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:_____wD3fzFDW99qIs6vCg--.23953S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFWDZr1kKr48Kr48AFy7KFg_yoW5Cr4Up3
	yYkryIkw48WFsrKa9rtF48XFyrWw18tFy7G34kJw15XFsxAF1FqF4IkFyrWay8u39IyrWS
	vF1qqr43uF4jvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRCeH-UUUUU=
X-CM-SenderInfo: 5frqwvrlusqiywtou0bp/xtbC9QZ6bWrfW0aixwAA3p

With CONFIG_IPW2200_QOS enabled, the receive path can schedule
priv->qos_activate to update the firmware's QoS parameters. This
happens when processing association responses or QoS changes in
beacons and probe responses for the associated network. An association
response without QoS parameters can also queue the work to install
default parameters. The work runs on the system workqueue and is
embedded in struct ipw_priv, which lives in the libipw netdev's
private area.

During device removal, ipw_pci_remove() calls ipw_down() and
synchronously cancels the driver's other work items, but omits
qos_activate. unregister_netdev() synchronizes with receive processing,
but does not wait for work those receive callbacks have queued on the
system workqueue. free_irq() does not wait for this work either. The
remove path then calls free_libipw(), freeing the netdev and priv
without waiting for the QoS callback to finish.

One possible interleaving is shown below.

  CPU0 (remove)                   CPU1 (RX tasklet / kworker)
                                  ipw_qos_handle_probe_response()
                                    schedule_work(&priv->qos_activate)
                                  /* Work has not run yet. */
  ipw_pci_remove()
    mutex_lock(&priv->mutex)
    ipw_down()
    mutex_unlock(&priv->mutex)
    unregister_netdev(...)
    cancel_*_sync(...)
    /* qos_activate is not cancelled. */
    free_libipw(...)
      free_netdev(...)
                                  ipw_bg_qos_activate()
                                    /* priv has been freed. */
                                    mutex_lock(&priv->mutex)

The synchronous cancellations were added by commit bcb6d9161d17
("wireless/ipw2x00: use system_wq instead of dedicated workqueues"),
which states that "All used work items are sync canceled on driver
detach". qos_activate was already queued with schedule_work() at that
point and was left out.

Add cancel_work_sync(&priv->qos_activate) alongside the other work
cancellations in ipw_pci_remove(), after unregister_netdev() and
before free_libipw(). This cancels pending work and waits for an
executing callback while priv is still valid.

Found by code inspection.
Fixes: b095c3819805 ("Catch ipw2200 up to equivelancy with v1.0.4")

Signed-off-by: Sicong Huang <congei42@163.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 8249d493ee22..2cdbdcb4e143 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11786,6 +11786,9 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&priv->led_link_off);
 	cancel_delayed_work_sync(&priv->led_act_off);
 	cancel_work_sync(&priv->merge_networks);
+#ifdef CONFIG_IPW2200_QOS
+	cancel_work_sync(&priv->qos_activate);
+#endif				/* CONFIG_IPW2200_QOS */
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IPW_IBSS_MAC_HASH_SIZE; i++) {

base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
-- 
2.34.1

