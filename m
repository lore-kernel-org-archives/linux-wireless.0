Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7B846A5E5
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758924; cv=none; b=EDJLQnQEdKTS0bBPo0iP+FAH4RhNeUoyuqWN1BY+FXU8kQNqJYKmdevcyy/2taZLaQGT7GGRev9zvicSopH7FKS9iXpeNbANJieKnhlq+THrgc2RIySCmPLkaYxHOdB98G0ttJffalB1uAShoXNaheXA1r1E+cRScr6jdPOjdaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758924; c=relaxed/simple;
	bh=+IpgA7jYufO99+UKvnT4+pwqS2EFIXRDbHH+DcOTbhs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ooo38G7syy6VdPtWbenADaZeLmlUsgEWs68jJQdWhGFoaMPL70gY1bZc/AEj7Li6ZA74SJFTeqx8uc/xNrWZ5SCM4nlJKYQVJVVzTYSvUcgoFU5SLQWZXjGrodxJ5v90od1nxwuV7WFp4eV6Eaw6WtSbHmlP0PV37q2PMAKZ7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=Y/Dy4tA6; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="Y/Dy4tA6"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2IOxOsyN; Mon, 12 Oct 2026 00:45:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758732; bh=+IpgA7jYufO99+UKvnT4+pwqS2EFIXRDbHH+DcOTbhs=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=Y/Dy4tA6yG9MsntOs5CKZ9Slq+R+lqZiBDIGWK4x60xd20CStvUkEtCm/yuII4y6H
	 7M0kgPBYjGUzKu4MFLwLy72sWv/b0I7GJfuvcpP7yGTpFQvyKmrxQKBef9KuN9LVaT
	 lpMmcRfewECqMKIMnL+V+A8rXyeNcWdx0uv1GQ/ljEmjTK51mcGMamSw1y7BC8Y3Du
	 O7QwpNJAfXp8ZDjscrz1qpVIxYMCJEj+P8ldqpUk8E3T9Fdck/2iXtfvHY6GnGdLZq
	 nH0s1Y786UyUnHBYxF7uQcu9MgYaxB2iotjUvxYyU0Sr85M3hKybbxyem2Xcbn2QIH
	 zP9/HURLaReng==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Mon, 12 Oct 2026 00:45:26 +0200
Subject: [PATCH v2 2/5] bcma: scan: support big-endian backplanes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-bcm6362-wlan-v2-2-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfP2cNQoSpltEWhkdtWFlmY8vumarz2zBu0G4omizKhl/O1KMs3UROV8wnvfzf9jv66Hka1krNUOchSfVMILfwtz6Xyn3OtJB1FE5YrbbRlYsWbF+UDpA
 aK6Q7XygWRAnrqECHPqKuP+8DC/fVu0/qNNcxJiUhnJRs/5DHC/IlY3+qHvzhRXqLsHs4iLXSxtFxqWUxNZlW4siVByqrbo9Ta/K5KicF9ePdxd+XygdmIBg
 Ho9aP2hKw/UWbH3TgWwS8Uoo7WiNmWG8bRg94CjIvDwxJw8n5rkpdyLID7xWVssf8EmoA6ctW0GTVcHQxb4sBTx9PBoSw2b6EmSQRKNZ4LxEHmCeMMu46v49
 0UOz52wxPZ3qGZrMZo8gDH+PqqxiftVRtbx1yEXQbfFM2xxe9eD5lCxBjLO0lqVbuNsff5G9YPD8PCQKw+74pgwbLTc2BCNaDkhJN8CbRDup1S46QVgSon9y
 uWWou51+3rMjTLqi3oBuv0UctdEv3aqG9uKPLPEVW+/PNyZMZaj1/WxZWXi/7ho7PlER+kE3AYzUFsJathJK+ybAafotwJ99IbBQJwafZnnFtKWabKCkOgeI
 wBpE+zxFRnF863MiU7IPwxzsoj4d6BQLkh5fnYGC2uEez+3OneAKIqHkbxOTqzkamgA=

On some SoCs the bcma backplane is a big-endian peripheral, so the
ChipCommon ID/EROM pointer registers and the EROM itself read wrong
 with readl().

Add a big_endian flag to struct bcma_bus, set by the host driver
before bcma_init_bus(), and use ioread32be() for scan-time accesses
when it is set. Core register accesses after the scan already go
through the host ops, which the host driver provides with the right
endianness.

Nothing changes for other devices.

Assisted-by: LLM sparse
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/scan.c       | 4 +++-
 include/linux/bcma/bcma.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 84742408a59c..983a62ddeebb 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -143,6 +143,8 @@ static const char *bcma_device_name(const struct bcma_device_id *id)
 
 static u32 bcma_scan_read32(struct bcma_bus *bus, u16 offset)
 {
+	if (bus->big_endian)
+		return ioread32be(bus->mmio + offset);
 	return readl(bus->mmio + offset);
 }
 
@@ -155,7 +157,7 @@ static void bcma_scan_switch_core(struct bcma_bus *bus, u32 addr)
 
 static u32 bcma_erom_get_ent(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
-	u32 ent = readl(*eromptr);
+	u32 ent = bus->big_endian ? ioread32be(*eromptr) : readl(*eromptr);
 	(*eromptr)++;
 	return ent;
 }
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 17fc50190014..7ab2b21e7238 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -362,6 +362,9 @@ struct bcma_bus {
 	/* We decided to share SPROM struct with SSB as long as we do not need
 	 * any hacks for BCMA. This simplifies drivers code. */
 	struct ssb_sprom sprom;
+
+	/* Backplane registers, EROM included, are big-endian */
+	bool big_endian;
 };
 
 static inline u32 bcma_read8(struct bcma_device *core, u16 offset)

-- 
2.56.0

