Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2A73AAF70
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145992; cv=none; b=phVWe0Jftpg/1E6Lw8PSGfqlCfNuUNWI9jUzxdoSl1mkYlwpTVB1aFOf8IZUxgHhm4x+cXmA+OcjYTb69K4dtS4mJ35aN8uRdbpBjliSCQ6ToZEBX+CV/d5AQpne7MfWfPLewuxK90J8dZMFlpiMQ9C+lBTmHWzuI1Qa5OApj00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145992; c=relaxed/simple;
	bh=SxCA5XEAWKCcLkJi+5jHbvA5AUH+9sF5/jS3yVkOn+A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gFTJZ6aMCLfmJbXJZFAg5IFmnW6qHWq0f1vomkORUyXRIzXN801BymNCs7MV6uu3gZYqbBmXEJvAo0L5fQGJkex3u40HZ7nmpzVunrY8g08Z8L2UUIkDZ12hciSHi6n2zE/AQMJbRGzy9Ymtjv26Pbx93BnYobR/sF94vXxSf7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=anGZIaxG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ou4peQ2b; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="anGZIaxG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ou4peQ2b"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JD089T4045467
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uZm8p07OPUwjWzI9g+/BN5XpGEETr3ffQKeDhE670RY=; b=anGZIaxGsLZQRJhu
	tC8Tf1KIAXcfjXEgxXtHkEnY4f3lRaKQjfFctshUG7cuNcl/+ZxmgTwQCfBUA7Uy
	GYy/ug4hdsAVNdkcO09ckYeY8AOvxL8djFVmbv8kWey2FvLp1814TzGxxpEC8ad/
	k+jR1lBZ/W7mmfIKnzejZLp15yWU/UaqDlLl4CFGVvfwslMi4jBP/nlTZspabY4C
	k3zDvtC2vqnUSEVdp5LZUiEoO3Cowes/hw4UePbNf2NOOPmXIFgv9+o1tcVHrZ/3
	i9h+vbd1SF1P+4rJZe+5in5JdjhYnl1WpQvsm33dbnxQpqI/lHLJMsY3Pae5CEPb
	pIA6Og==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfkkest-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ccb6f6a3f4so13978375ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787145985; x=1787750785; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uZm8p07OPUwjWzI9g+/BN5XpGEETr3ffQKeDhE670RY=;
        b=Ou4peQ2bCeAFAHi3LIQ20uzK5i1se15YOhTf+LRISY7O7WQ58GXxRf0oK3SZjIOLEw
         YyUbp4gDaBysmlmsI7MWroD8uvIXO9T9KST3anN3WEN4nsVMxAZIRDas6on/NPTVdj8M
         61b4gnN8q2LcFPKhLWJyUCijlIY79kFQflhAn6evMYb3M/Y08DEqF4PT94lCNdKDfkR7
         6DB4zsXYV3NCEv/+4hSLQom0HMHa1r049udeBnMpFVmvVEkEAQm4AmQ7zv40EBZ3YX/c
         0jdCsZ/L0PzGR3BfteaNpR+E5W187YJ707ZMGzkdzPe6y2Ce5YbbS+x2kTY0d/FdrtCI
         IUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145985; x=1787750785;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uZm8p07OPUwjWzI9g+/BN5XpGEETr3ffQKeDhE670RY=;
        b=TaCzqOscQzuEPerEtE/l4Nwdh9i0FH3z2i3z89g2pU75LLFkOH++DvJHC2bOR78DGB
         5yOQU2YOP56591uyI9MDZrwTPovrsMcgDsSf9xaULIILrs1nz1ZKrpyr87VDuEwZW0Sq
         IOK2Pj4pCuntcmu3um+dEVXwN8/jUIXQPC9RDykg+/zVfaR8ue6f0L9G8MXGRFHdC4Aq
         2ViN6bvonY4sxDff+bMH0/sGiWYcftbyjtNqEzCakCXxfYlAmjxpOMWSB9AEwuDikh7K
         0NhCVScQYT1BjJKBCqoMFHLqLlvN6sQhPTBZ539UZeOagWde5TVCAvj7vMGSqW5Q/tNT
         miOA==
X-Forwarded-Encrypted: i=1; AHgh+RrTP4hpEhmhgz9rsSyKvuVmMjAbsQTGndU8I6JbA2m34QTiSkgeFB8Zp7QnEAG1nDxDnDTExPEZbgjuT23Zcw==@vger.kernel.org
X-Gm-Message-State: AFuF++n27+dy1QPmyjtfee47IvZYUI2a1eq54n2z7s/FJZPncS85RnfJ
	pP92Ja6bLWhIP1+CBEJ4zla+6Acwk02B1hUquphKenFYiVfOkki0uq2IncvWeScQKvdbXWSWd05
	GDAwNmzGiNvkrveAXz6gAR+X3qBPYCj4p06ab9z8KfvNQZvDolrRnCJYbB4xCu/IExG/MYA==
X-Gm-Gg: AR+sD10b7WAlCCl7afDUbtiHdF96MwpXW93dcu6xIY5AbHsDDjpx2viEyJ+kO2zQgNw
	jpOnyVHAYOd/M/8gtP2AEnWq2wcMq5mLF7lI9Yp0S7WSVUNJJ+UHnYNM0HPXPpqEkWitfAeqQuj
	vgtjkHraT8wWkv3yoN7hKoKCIVPdfVkRAXEKVEg1ODy4rcHeQ/yefzArjEpbfIanlw5kyaCpi22
	01nC0WlKh21oPpGwUYYG7DPIH1jywjPX7CxOh+g8oqKnBptML+1xGTPA+tq3YAW7FHK69uaMorz
	vy1Y4ZzKokSEghb36T6JgW5u5+NWpfS5yARlqOjh93puuVXCGsMTs8dMIdrhjIDlu3Vylv+EWkF
	ajynj0psjcOtQrQYps65Ly/D49+Hi07vGoyY=
X-Received: by 2002:a17:903:32cd:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d5fca022b5mr42665775ad.13.1787145985180;
        Wed, 19 Aug 2026 06:26:25 -0700 (PDT)
X-Received: by 2002:a17:903:32cd:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d5fca022b5mr42665355ad.13.1787145984708;
        Wed, 19 Aug 2026 06:26:24 -0700 (PDT)
Received: from hu-krichai-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c2a92406sm6126465eec.11.2026.08.19.06.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:26:24 -0700 (PDT)
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:55:52 +0530
Subject: [PATCH v5 1/6] PCI/bwctrl: Set host bridge OPP and optionally
 disable ASPM around link retraining
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260819-bwscale-v5-1-6dea79786b37@oss.qualcomm.com>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
In-Reply-To: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Manivannan Sadhasivam <mani@kernel.org>,
        =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        qiang.yu@oss.qualcomm.com,
        Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787145973; l=5454;
 i=krishna.chundru@oss.qualcomm.com; s=20230907; h=from:subject:message-id;
 bh=SxCA5XEAWKCcLkJi+5jHbvA5AUH+9sF5/jS3yVkOn+A=;
 b=+05IMJ0Y0LiMP+RJM/+lS+Ieb366h5UNezsjnd0NgWZJXOIggWGrqhPxMjNciQkqd7wJ9Tsh4
 r6NglZRdgamDYFX2v5ULcjIPuRYE0iQYRf+qfr13iweVLysNF1dR4Zo
X-Developer-Key: i=krishna.chundru@oss.qualcomm.com; a=ed25519;
 pk=10CL2pdAKFyzyOHbfSWHCD0X0my7CXxj8gJScmn1FAg=
X-Authority-Analysis: v=2.4 cv=NoPhtcdJ c=1 sm=1 tr=0 ts=6a85af02 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=m7h7XtmfQhPoxq-7kmMA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: SGnlr4SDtpZgEEpn1GZvkozLssZ1PI6C
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX5oOYgf+/4O+M
 9jLrqgK6n75KaNimPM7qISv2yNWRwsQ4j/WkMCiFGWWszZYTUZyJpVnn1y/1enFCiZcfxVpFTvG
 hCXhNx3qS++H1K2zrZc0j1JNC6Xj67E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX67KNGcjOYGZk
 +J1BG3Wr1VcUCCG3eOQ+eqidlEsGXfnxu2OSkuU37HqVDcFeCONDVbq9Q64ak0ru3cNzaoeLIJv
 ur4YM8LU2ombBd8CBK/Hdna3VzMO0y1a3VPkasVafHY6t/w0mqgBLHk8xtVZTp7/MLHBWtn8oZd
 ZpFy4HquzlwzXZ/4j5dHX0DQm2038mz/susDWFXFzZbY6CkrHLOyspDMtDNYZanoZTPZqNI1riC
 /nzzrfImFL5m21+CWvlrcBww+geTEyg4eDX2B8t4/ftBv3pWFB/x+TBlabhBXrTprOD96msPgHe
 IdMup2ylTVVaUO5nitiPFJtvBJRmvuMNR/tJXE2Zk7331xl0ICALmR4pbiOb6xZmrXqwQEFGWvD
 ZG9T/TjfVBGK6pQ/++Ev3LHk1WBPZzHPN1Fd1I4vrzkZQa/GgSh2133vbzDNGobhQIcKTQLfAbe
 G2CizG/MNPhPshsJ/8Q==
X-Proofpoint-GUID: SGnlr4SDtpZgEEpn1GZvkozLssZ1PI6C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190104

PCIe host bridge controllers may need their operating point raised before
retraining to a higher link speed so that hardware resources (e.g., RPMh
votes on Qualcomm platforms) are available at the requested data rate.
After retraining, the operating point must be updated to reflect the
actual negotiated speed.

Add pcie_set_opp() to look up an OPP on the host bridge parent device
using a key of (per-lane frequency in kHz, LNKCTL2 Target Link Speed
level).  Keying by generation rather than total bandwidth lets OPP tables
remain width-independent.

In pcie_set_target_speed(), call pcie_set_opp() before retraining only
when upscaling (speed_req > cur_bus_speed), since only raising the
operating point requires pre-staging hardware.  After retraining, call
pcie_set_opp() unconditionally with the actual cur_bus_speed to settle
the votes.  Both calls are skipped for downstream ports of PCIe switches,
as those are outside the host controller's scope.

Some controllers also require ASPM to be disabled around link retraining.
Add a disable_aspm_for_retrain flag to pci_host_bridge; when set,
pcie_set_target_speed() saves the child device's ASPM state, disables all
ASPM link states before retraining, and restores them afterward.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
---
 drivers/pci/pcie/bwctrl.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h       |  1 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index c4c8d260bf96..6fa1522c47db 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -28,9 +28,11 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci-bwctrl.h>
+#include <linux/pm_opp.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -120,6 +122,38 @@ static int pcie_bwctrl_change_speed(struct pci_dev *port, u16 target_speed, bool
 	return pcie_retrain_link(port, use_lt);
 }
 
+static int pcie_set_opp(struct pci_dev *pdev, struct pci_host_bridge *host,
+			enum pci_bus_speed speed)
+{
+	struct device *dev = host->dev.parent;
+	struct dev_pm_opp_key key = {};
+	int ret, freq_mbps, width;
+	unsigned long freq_kbps;
+	struct dev_pm_opp *opp;
+	u16 lnksta;
+
+	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
+	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
+
+	freq_mbps = pcie_dev_speed_mbps(speed);
+	if (freq_mbps < 0)
+		return -EINVAL;
+
+	freq_kbps = freq_mbps * KILO;
+	key.freq = freq_kbps;
+	key.level = pci_bus_speed2lnkctl2(speed);
+	key.bw = 0;
+	opp = dev_pm_opp_find_key_exact(dev, &key, true);
+	if (!IS_ERR(opp)) {
+		ret = dev_pm_opp_set_opp(dev, opp);
+		if (ret)
+			dev_err(dev, "Failed to set OPP for freq (%lu): %d\n",
+				freq_kbps * width, ret);
+		dev_pm_opp_put(opp);
+	}
+	return 0;
+}
+
 /**
  * pcie_set_target_speed - Set downstream Link Speed for PCIe Port
  * @port:	PCIe Port
@@ -140,9 +174,12 @@ static int pcie_bwctrl_change_speed(struct pci_dev *port, u16 target_speed, bool
 int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
 			  bool use_lt)
 {
+	struct pci_host_bridge *host = pci_find_host_bridge(port->bus);
+	bool is_rootbus = pci_is_root_bus(port->bus);
 	struct pci_bus *bus = port->subordinate;
+	struct pci_dev *child = NULL;
+	int aspm_state = 0, ret;
 	u16 target_speed;
-	int ret;
 
 	if (WARN_ON_ONCE(!pcie_valid_speed(speed_req)))
 		return -EINVAL;
@@ -152,6 +189,24 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
 
 	target_speed = pcie_bwctrl_select_speed(port, speed_req);
 
+	/*
+	 * The host bridge driver may need to be scaled for targeted speed
+	 * otherwise link might not come up at requested speed.
+	 */
+	if (is_rootbus && host && bus) {
+		/* Get function 0 of downstream device */
+		list_for_each_entry(child, &bus->devices, bus_list)
+			if (PCI_FUNC(child->devfn) == 0)
+				break;
+
+		if (child && host->disable_aspm_for_retrain) {
+			aspm_state = pcie_aspm_enabled(child);
+			pci_disable_link_state_locked(child, PCIE_LINK_STATE_ALL);
+		}
+		if (speed_req > bus->cur_bus_speed)
+			pcie_set_opp(port, host, speed_req);
+	}
+
 	scoped_guard(rwsem_read, &pcie_bwctrl_setspeed_rwsem) {
 		struct pcie_bwctrl_data *data = port->link_bwctrl;
 
@@ -176,6 +231,12 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
 	    !list_empty(&bus->devices))
 		ret = -EAGAIN;
 
+	if (bus && is_rootbus && host) {
+		if (child && host->disable_aspm_for_retrain)
+			pci_enable_link_state_locked(child, aspm_state);
+		pcie_set_opp(port, host, bus->cur_bus_speed);
+	}
+
 	return ret;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 18e814064b51..d1f2d382189d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -662,6 +662,7 @@ struct pci_host_bridge {
 	unsigned int	msi_domain:1;		/* Bridge wants MSI domain */
 	unsigned int	broken_l1ss_resume:1;	/* Resuming from L1SS during
 						   system suspend is broken */
+	unsigned int	disable_aspm_for_retrain:1; /* Disable ASPM before link retain */
 
 	/* Resource alignment requirements */
 	resource_size_t (*align_resource)(struct pci_dev *dev,

-- 
2.34.1

