Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893541C68F;
	Sun, 21 Jun 2026 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782024906; cv=none; b=h9lX8pMZ2UemwY3AoKBKlOlpNo8yZAiFrIUdrBa0ek5PWJGfgKZr/t5sGlFDxREhCtM1rxk0UdqXohohAB6CxFBZR/KqX/uMOh+GT50T5NXZt4YQPtBG5RbuCiP2eK7K3QADbLhPe7au1Yo5dvQyc3y/+TU6xpx21DInur4l7M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782024906; c=relaxed/simple;
	bh=Wx01uP3faFngXSSrd1jm6na8igotzoZExmtNPTQ84ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ex3TdRvcEPSXt1bHAXY13tPcP5lWL3KScWx+wSBbgPFwjby8No3V+7TDdQH7+Blfxo/D+TZ0ldD9tUFLT2DBzagOcYTsReTgkn5+FmfXg5XgQr/ZYyUTDWltyqSSAq/afqKf3VG12uT4gNRFX7DlljPzEhc/tGAUuYWm9R6als0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c5jhijwH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c5jhijwH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782024904; x=1813560904;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wx01uP3faFngXSSrd1jm6na8igotzoZExmtNPTQ84ss=;
  b=c5jhijwH4PG3lsj0wJ8wt7mT8i4Ye1OOkC2hoN1QZ8olMk7obPbm7hvM
   I3d+pMmUH/5Sjscus779lCa5bDwotIIOOyA/WVVlRCnAiTXSOi0QUT0LM
   U7NwerslBt8uSkESLK3FbCm2aRLfYG59oNutRH2CpwkXOYuyX7/pNTUyy
   8vmJ/jKmyOatz6gXHg5VHvUz7BQ9o5FJUgWt3YUrSrseuP6Wms56+UFcp
   36JMdbhlgdDWPv/gY2LpCVWfmTSwbjN1OfVZtwST1IW2aTpuXdU2s2eo6
   TX+DMjcJ/qv7RevHXbHUGfFfIw4Q8AH30AmFHt/z6YjjSVifVZLvXVsBN
   g==;
X-CSE-ConnectionGUID: TGuTOx/uQMWmNvj4UX6Hdg==
X-CSE-MsgGUID: wBsp2JiZT2aHN0q/fgFUQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11823"; a="93444611"
X-IronPort-AV: E=Sophos;i="6.24,216,1774335600"; 
   d="scan'208";a="93444611"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2026 23:55:03 -0700
X-CSE-ConnectionGUID: KbyF/pl+Svet30DepINh+A==
X-CSE-MsgGUID: maxN6Em8RdK8YKWY1jUL3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,216,1774335600"; 
   d="scan'208";a="247809376"
Received: from egrumbac-mobl6.jer.intel.com ([10.13.65.199])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2026 23:55:02 -0700
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-pci@vger.kernel.org,
	helgaas@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] PCI: Disable NoSnoop and Relaxed ordering for Intel wireless BE200
Date: Sun, 21 Jun 2026 09:54:51 +0300
Message-ID: <20260621065451.21650-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel wireless BE200 device fails to copy the TLP Attributes from a
Request to the Completion.
Since there is no caching involved the device anyway, disable the
NoSnoop and Relaxed ordering on the root port.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/pci/quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c0242f3e9f06..e9f070d07b2c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4674,6 +4674,13 @@ static void quirk_chelsio_T5_disable_root_port_attributes(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 			 quirk_chelsio_T5_disable_root_port_attributes);
 
+/*
+ * The Intel wireless BE200 fails to copy TLP Attributes from a Request to the
+ * Completion it generates.
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x272b,
+			 quirk_disable_root_port_attributes);
+
 /*
  * pci_acs_ctrl_enabled - compare desired ACS controls with those provided
  *			  by a device
-- 
2.54.0

