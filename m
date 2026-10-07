Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA489493639
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364447; cv=none; b=BK3MJ7qFsdNpFjBIVMJx4+S1k9g3btzxQ0nWThnKCIPD58fDOB8WS/MqJn74p+sLPyUWuWx5O69mKTjIfk1P++hRLOK2kktIbnXFocJk3n8DxZ1cib47szIddIR+i0RRfD0a6SGKQJ8uEtP+m9ybl3DN+66ApbyLpRcMLTigSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364447; c=relaxed/simple;
	bh=J/y1H3eemnVhW06Ctyt4QVgncGhn8rhFQ+PbyfP1y1s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nhE1zOZ4psylsCF925gYgVF54ISCRpzAAMaLYsB0CumiECVtCmT2LbXpO63qG06to/NiOZSRXfrt78olipcGfFke43OqSte6iI0slRGUGFlgA7htk0eUQFYaKTaF1zt24mSDQNn6K4vRt6piHedI64aqRhju8RY7HByM/gcbZ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=packett.cool; spf=pass smtp.mailfrom=packett.cool; dkim=pass (2048-bit key) header.d=packett.cool header.i=@packett.cool header.b=eJkgOcS4; arc=none smtp.client-ip=95.215.58.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=packett.cool
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=packett.cool
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=packett.cool header.i=@packett.cool header.b="eJkgOcS4"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J/y1H3eemnVhW06Ctyt4QVgncGhn8rhFQ+PbyfP1y1s=;
 c=simple/simple; d=packett.cool;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791364318; v=1; x=1791969118;
 b=eJkgOcS4z7rXaLJ08GMlL5UPMnRJRkpmrZpI02UZSB0ovIVvUmT8E3iQLHSYlf8emgDF60r1
 wQd3Fd2+Ef6aOzyZixmWHgm52XDi1Tr8H2wn/THFAREPo/9QZlJs1fGmFPu9G2IPBeOSTruo+zL
 oVuwo+FOcG5bmzk1Myd+iIf4SRFgUnqciZMkQa9OxzdOgJl8RUG0AarO43sNAURHs9stkGQfxD1
 o8qIOZjkQHo3W5YAqeXoP+KdBZ0Q9z+So2eecafMZLBidSS5Z/9jopn2ax/NAyjKfWZDjzFGkBu
 QNboamxyEBarOMDCkmee+Jvtp2iflV9bq+6nR0sLNXcmQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7d4030431edfb94a;
	Wed, 07 Oct 2026 09:11:57 +0000
X-Mizu-Trace-ID: 7d4030431edfb94a
X-Migadu-Flow: FLOW_OUT
Message-ID: <f189cfc2-c36a-4bf5-bac7-36ddb15cc7a4@packett.cool>
Date: Wed, 7 Oct 2026 06:11:46 -0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Val Packett <val@packett.cool>
Subject: Re: [PATCH v5 1/6] PCI/bwctrl: Set host bridge OPP and optionally
 disable ASPM around link retraining
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Jingoo Han <jingoohan1@gmail.com>, Lorenzo Pieralisi
 <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>,
 Manivannan Sadhasivam <mani@kernel.org>,
 =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 qiang.yu@oss.qualcomm.com
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-1-6dea79786b37@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819-bwscale-v5-1-6dea79786b37@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/19/26 10:25 AM, Krishna Chaitanya Chundru wrote:
> PCIe host bridge controllers may need their operating point raised before
> retraining to a higher link speed so that hardware resources (e.g., RPMh
> votes on Qualcomm platforms) are available at the requested data rate.
> After retraining, the operating point must be updated to reflect the
> actual negotiated speed.
>
> Add pcie_set_opp() to look up an OPP on the host bridge parent device
> using a key of (per-lane frequency in kHz, LNKCTL2 Target Link Speed
> level).  Keying by generation rather than total bandwidth lets OPP tables
> remain width-independent.
>
> In pcie_set_target_speed(), call pcie_set_opp() before retraining only
> when upscaling (speed_req > cur_bus_speed), since only raising the
> operating point requires pre-staging hardware.  After retraining, call
> pcie_set_opp() unconditionally with the actual cur_bus_speed to settle
> the votes.  Both calls are skipped for downstream ports of PCIe switches,
> as those are outside the host controller's scope.
>
> Some controllers also require ASPM to be disabled around link retraining.
> Add a disable_aspm_for_retrain flag to pci_host_bridge; when set,
> pcie_set_target_speed() saves the child device's ASPM state, disables all
> ASPM link states before retraining, and restores them afterward.
>
> Signed-off-by: Krishna Chaitanya Chundru<krishna.chundru@oss.qualcomm.com>
> ---
> [..]
> @@ -176,6 +231,12 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
>   	    !list_empty(&bus->devices))
>   		ret = -EAGAIN;
>   
> +	if (bus && is_rootbus && host) {
> +		if (child && host->disable_aspm_for_retrain)
> +			pci_enable_link_state_locked(child, aspm_state);
> +		pcie_set_opp(port, host, bus->cur_bus_speed);
> +	}
> +
>   	return ret;
>   }

ASPM is not actually reenabled here:

LnkCap: Port #0, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <8us
         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM Disabled; RCB 128 bytes, LnkDisable- CommClk+
         ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt- FltModeDis-
LnkSta: Speed 2.5GT/s (downgraded), Width x4
         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-


Because as the comment for pci_enable_link_state(_locked) says, "note 
that this does not enable states disabled by pci_disable_link_state(). 
Use pci_force_enable_link_state() for that"!

This needs something like:


diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 4bad311dc7..c54f2658e0 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1709,6 +1709,12 @@
  }
  EXPORT_SYMBOL(pci_force_enable_link_state);

+int pci_force_enable_link_state_locked(struct pci_dev *pdev, int state)
+{
+    return __pci_enable_link_state(pdev, state, true, true);
+}
+EXPORT_SYMBOL(pci_force_enable_link_state_locked);
+
  void pcie_aspm_remove_cap(struct pci_dev *pdev, u32 lnkcap)
  {
      if (lnkcap & PCI_EXP_LNKCAP_ASPM_L0S)
diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index 623731b96c..530b9047a0 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -211,7 +211,7 @@

      if (bus && is_rootbus && host) {
          if (child && host->disable_aspm_for_retrain)
-            pci_enable_link_state_locked(child, aspm_state);
+            pci_force_enable_link_state_locked(child, aspm_state);
          pcie_set_opp(port, host, bus->cur_bus_speed);
      }

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9f20bae6d7..59d7b67c9d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1960,6 +1960,7 @@
  int pci_enable_link_state(struct pci_dev *pdev, int state);
  int pci_enable_link_state_locked(struct pci_dev *pdev, int state);
  int pci_force_enable_link_state(struct pci_dev *pdev, int state);
+int pci_force_enable_link_state_locked(struct pci_dev *pdev, int state);
  void pcie_no_aspm(void);
  bool pcie_aspm_support_enabled(void);
  u32 pcie_aspm_enabled(struct pci_dev *pdev);
@@ -1974,6 +1975,8 @@
  { return 0; }
  static inline int pci_force_enable_link_state(struct pci_dev *pdev, 
int state)
  { return 0; }
+static inline int pci_force_enable_link_state_locked(struct pci_dev 
*pdev, int state)
+{ return 0; }
  static inline void pcie_no_aspm(void) { }
  static inline bool pcie_aspm_support_enabled(void) { return false; }
  static inline u32 pcie_aspm_enabled(struct pci_dev *pdev) { return 0; }

(the addition of the new force+locked variant should go as a separate 
commit, but well)

With that,

Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455

Well, tested without that too, but losing ASPM is not good :)


Thanks,
~val

