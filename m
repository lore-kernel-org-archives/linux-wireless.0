Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9C93264C3
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181433; cv=none; b=BEzwisOr6CAkMSug862B9mNsvwkw1R1TsYVHPp8VXVoOzvgqNHWCvbccsavyMiXdHI8eSqDoJ+zYFkbY+xIPXxI/6DAtZW56LXcP8bjD0Ios+PBFGaMtn3fKf3tIPwyckxfacNPHEeglqgfV0Pl3gSE1/WWVQXCca542oiOHTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181433; c=relaxed/simple;
	bh=V//q0jtU9XTTbMl5NPi6UcTLSaqr0Evx37P5sMiaSJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c542yedSYc99bTXskQ2x8lLNLeT97yGqZzfvA4jGzyfb+EcRmareSZHrLBxibmfSctZGADzGug8ISRoEADZDVCmqC9KXkj7xaTsHUE+pxNvjRi6dC5WU/QEw0Av4TnJ9Qd0MyYWQDtIgGJ8mrB1M8rCZHwkRnDV+YkauMzHIE2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DxKPQpjb; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxKPQpjb"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1cb48db3eso371833a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788181430; x=1788786230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RIkEaTsAou/6x2ZpYenzr6Kjhqg+r06MkNAF+XMgBd8=;
        b=DxKPQpjbegPTpugshIwSDtMDpy+IWy8STxYwpvacmGquHLR3FStiBIvcOAovzr1eXB
         84RtL43V9rcMH5cSz93AMxFIwjgHMntKi6hGF+++1uO6e+UuwAvwkt0Le8ROMDNTH3Jd
         uXBueXeEjQu9qegDp0KfqwLsuEm/kleGtLwizmlEHYBQwUAWpy/IB5dicayxU13Ywi+h
         lmV+Q7N/CsZ9JYKvBF14qR0GrZ4DA2MlLqLcka86xOCbelviVNEDIbshSa1yF2bpaTvs
         cchAMIdPx92qiC9OhTWLzk+chWiTiW31dQ/62pqnrzguWGAQ9WrAvAjIscy8DKEj/aba
         tQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788181430; x=1788786230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RIkEaTsAou/6x2ZpYenzr6Kjhqg+r06MkNAF+XMgBd8=;
        b=fpqytjiVkRKnkFdZF7tMxWm6EtA4q+v8LPfdoFS3+wduRrisFtktvW4oLaaXyKbg4w
         Q+U9DjQOmHWpieUp8D3vNmswAmWvdUKkPhz692+1m4JDr6/YN464sM/aLqDkYz0QjvN3
         7h84MDKXDy8wiqeZSLB5urf/lfkMuvYNrh5l0C3TKuj/+Axn/xcmEcgWrmNOiv1F8Uz2
         24ol99XP7t/btaQfTRA8HCZ2bxu5X+Ukb3iIvQeQgOL1eUhZPGc+ww77P0QGoKN8fb5X
         MSuWnt6q1SZnQD2t06tYv1aEecAnDAQ1DeHn6//TRCR7f8Zt3SS4yUbVsvVt0bjwQ05H
         mG/A==
X-Forwarded-Encrypted: i=1; AKwUvBwdvPz7OMBt9TrJ1N79agkPmtNoGu7+Mvh4pN6TA8ns5Qf54moXSE164Wfwrn4EoZqn4NdBmrxlDyJzJrgloQ==@vger.kernel.org
X-Gm-Message-State: AFuF++l5qDOJ0STkqyaTYbbLZUtU9J29YLhGLaeIGuGoHo33MFPdSuVe
	zYT89GzER2+S5Zwn+DEuwC+ZlKxXdXWBMpK6zDs9A58X2iQ9jdrqYDbZ
X-Gm-Gg: AYBFou0KvwOX+TNN6Zyt8yQy4H/3I/QiB6RAFhWX6T9E0FhK8VrZr+HKV46zTgLmAHi
	UlR/Wa4Rnp3PlusLOLodSAzfyOUSRdQrsePVOLIpinFj+TBgjYAl0XaMndG1l3LOTea3WcrykUu
	1BUVyaBzZGLy+sxPgCc9pprtJyf+5p2l/bsNsBmWEFkz5lPv/cA4LvTk/Z49QgFzXjvBlo3FeeT
	Xsed87yU11QyRHq3BqUTKBMTsGjHgiIfvfc3/G99PdTIVRKlQcJGx5NhpL+RDmYYuyQhUtaM1ZA
	A5srnAd5mDskl9zlSIJ0Dg52O59Mmo6mRhdHMUL6HiTVJFnunyM9Y7coH6hifHu0Fye/dHuAv9W
	PtH55UuOKz77ZxqDw8z/T/h3TIX9doSu9KmRcEUZwbkG5a4sz5dvI2BZaq5HO+yH9y1vvFon1dq
	RWfXxwJLDd3OQsO3Bncepk2Mtk2R+ozA/Lfw9DMNo4Jd0M0zilA/epXwqt0iEJzuYwiazM4QTFh
	lJnuO3acDAy/l98YZGXXejcp8Vw
X-Received: by 2002:a17:903:1106:b0:2d6:f09a:da1f with SMTP id d9443c01a7336-2d74e0bab6emr217965675ad.4.1788181429982;
        Mon, 31 Aug 2026 06:03:49 -0700 (PDT)
Received: from cachyos-aura ([45.112.149.37])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7bf283sm32567749eec.8.2026.08.31.06.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:03:49 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Nika Krasnova <nika@nikableh.moe>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Mark Pearson <markpearson@lenovo.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless v2 2/3] wifi: iwlwifi: pcie: deselect the product reset mode at probe
Date: Mon, 31 Aug 2026 18:33:31 +0530
Message-ID: <20260831130332.323549-3-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831130332.323549-1-navonjohnlukose@gmail.com>
References: <20260831130332.323549-1-navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mode that iwl_trans_pcie_set_product_reset() selects lives in the
platform's ACPI namespace, not in the device, and nothing deselects it on
the product-reset path. iwl_trans_pcie_removal_wk() selects it, evaluates
_RST via _PRR and removes the device; the rescan re-probes, and probe only
reads the mode back for the log rather than clearing it, so it is still
selected. (A later removal with a lesser mode does pass enable=false, but
that is the path that does not need it.) It is plain namespace state - on
the platform I have it is a named integer written by the vendor DSM and
read back by the reset method - so it survives S3 and s2idle. Neither the
driver nor _RST clears it.

That has a consequence. _RST branches on the mode variable, does not
clear it, and iwl_trans_pcie_reset() takes the caller's word for which
reset to run. So after any product reset the next escalation can do the
wrong thing: iwl_trans_determine_restart_mode() asks for
IWL_RESET_MODE_FUNC_RESET on rung four of the ladder, no CSME involved,
iwl_trans_pcie_removal_wk() skips the Bluetooth teardown because the
mode it was passed is not IWL_RESET_MODE_PROD_RESET, tries to deselect,
and if the device has stopped answering by then that deselect fails
silently - the DSM is gated on AML reading the device's PCI ID out of
config space. iwl_trans_pcie_call_reset() then runs a full product reset,
Bluetooth kill GPIO and all, with the Bluetooth function still bound.

Deselect at probe, after the two calls that already read the mode and
the previous reset's status back for the log - so the inherited mode is
still what gets logged. That bounds the window to a single driver
lifetime.

Note that on discrete devices this is not literally a write of zero:
iwl_trans_pcie_set_product_reset() also sets EN_WIFI_FLR and EN_BT_OFF_ON
unconditionally for !integrated, so the write is 0x6. EN_PROD_RESET is the
bit the platform's reset method branches on, and that is the one being
cleared.

Cc: stable@vger.kernel.org
Fixes: 9673c35486d4 ("wifi: iwlwifi: implement product reset for TOP errors")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
Patch 3 also depends on this: it is the only thing that clears the mode if
the rescan after a recovery reset does not bring the device back. That
dependency runs patch 3 -> patch 2, not the other way about, so this one
stands alone as a fix and is tagged for stable while patch 3 is not.

 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index c6a771e..df89fb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4256,6 +4256,8 @@ int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
 
 	iwl_trans_pcie_check_product_reset_status(pdev);
 	iwl_trans_pcie_check_product_reset_mode(pdev);
+	/* a previous trans may have left the mode selected */
+	iwl_trans_pcie_set_product_reset(pdev, false, mac_cfg->integrated);
 
 	/* set the things we know so far for the grab NIC access */
 	iwl_trans_set_info(iwl_trans, &info);
-- 
2.55.0

