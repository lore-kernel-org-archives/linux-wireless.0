Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBEF486430;
	Thu,  1 Oct 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845148; cv=none; b=bELIaJ+B/6NWbvTudWuNxp3ebbGnTpRJRXomrqHYiTUs6sY4u1V2XUptgTa9buhDvBSkkk4y5RdJkogsTIvK864YFr+qZIn7ZIF3DUNW6cusyY/TU5bI+vZmPB/r3in/dr8EgLPT0X8B1aNS6fxVb9RiO0qp+AHqcM0/CplKgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845148; c=relaxed/simple;
	bh=USU15RAmkIfypqza9ahT9tglspbbxsALKGaI/8Ch51E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ0AZz165q32mhhjXNqGOHvlrdPPuX8eAsURWCQY2WHARmhVefv64hvvFCDFCrXd/cE9vRIgKNAJB/JmsD30T2c2M8B24ZaPusNFcunFdBD8XwU9z7jE7RcW60jKmDcns9C8VaSrl5DneG4ZN9o+06jc1tXLZy/7usauRihMDI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks; spf=none smtp.mailfrom=deq.rocks; dkim=pass (2048-bit key) header.d=deq.rocks header.i=@deq.rocks header.b=WS3SxfXM; arc=none smtp.client-ip=91.216.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deq.rocks header.i=@deq.rocks header.b="WS3SxfXM"
From: Andre Eikmeyer <dev@deq.rocks>
X-Lima-ML-UUID: 394562be-8666-4d0b-9712-3cb345edd73b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1790844791;
	bh=USU15RAmkIfypqza9ahT9tglspbbxsALKGaI/8Ch51E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS3SxfXMmIfSaoz+QnojdeplGZBGq9KBowKNA/6QB+tLyMmwkne2uZIgUUQdBZa2f
	 Qm/CbqOn+HPF9iT/A72izu7jZH2/v0M5OZ4eAl+N+lZtJajrgdZHVuoyHK4AkmWgiU
	 T0bsAE9Jxp+EXJ+hZroQGA9MaVXQil92/2NYHhoyNUyd+JPUUKv9uuRLvUHTA9Fay4
	 8u2A6OWX0PuhJKTm92U6Ml9mL46p2uL2iJxKUn/8CowP7WL+r2FSltLjFVxkg+WkcT
	 rjKOQthAQ7aBN7cCFy32mVVNTsgoih47wKCoLd8FWPzzVZNmn5b9AnhkEq5WYuJ077
	 6yBvahid6/nLw==
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Aditya Garg <gargaditya08@live.com>,
	kernel test robot <lkp@intel.com>,
	oe-kbuild-all@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>
Subject: [PATCH v2] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
Date: Thu,  1 Oct 2026 10:53:08 +0200
Message-ID: <20261001085308.1688049-1-dev@deq.rocks>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918213014.1890677-1-dev@deq.rocks>
References: <20260918213014.1890677-1-dev@deq.rocks>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BCM4377 on the affected T2 Macs does not acknowledge HOST_D3_INFORM.
The current PCIe suspend callback treats this as fatal and aborts system
suspend.

When this happens on BCM4377, mask the mailbox interrupt, preserve the
bus-down state, and let generic PCI/ACPI suspend proceed. On resume the
existing recovery path tears down and probes the device again instead of
relying on a D0 mailbox transaction.

Tested-on: MacBookAir9,1, MacBookPro15,4, MacBookPro16,3
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
---
Changes in v2:
- Drop the redundant DMI allowlist; BCM4377 is Apple-exclusive and only
  appears in the three affected MacBook models.
- Keep the device check inside CONFIG_PM, fixing the CONFIG_PM=n unused
  function warning reported by the kernel test robot.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b97..e2e050395 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2652,11 +2652,18 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
+		if (devinfo->pdev->device == BRCM_PCIE_4377_DEVICE_ID) {
+			dev_info(dev, "D3 ACK missing; masking PCIe mailbox interrupt\n");
+			brcmf_pcie_intr_disable(devinfo);
+			goto done;
+		}
+
 		brcmf_err(bus, "Timeout on response for entering D3 substate\n");
 		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
 		return -EIO;
 	}
 
+done:
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
 
 	return 0;

base-commit: 1631d79ae57dce2c5f88ad278307028638a8b4d9
-- 
2.55.0
