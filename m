Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D34A1E02
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183710; cv=none; b=fJPR7hUvjlvmgo6lGCv1i7Gd7/vdqQpdF7IuCAYcjJ7OVan4T5wHUzyj7cOTj02ZfdujL1i1qFLvAq+f66BBG8YipsEMINR4v+VL0rV+e5DWFgJji7KNcXOTZqnVj98min2nfFgO61vgcmwJAuM4Yq5epaqgHDxLrI7+Q2Djv6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183710; c=relaxed/simple;
	bh=IMH5XC1IQty2kDprL4vVOLUz5Rdo2SwjUCPUHF5zKr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gWXRfUoIB+NMQNMrbrCnUpIgUoIu/DXV04ohJP0sQvZuhE4h26WGROYW3Wa24jm8LfBnOEOMdNR3GYKXfS+SOY/aKUKwwqlbPMqdmbo4lPYDLuvmOo4fcFAmuQ+6OunCRcMMsYv0TaXICCLrvkv0zR9LB4f/15Uv6BC3dBg7e2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+7dIIom; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+7dIIom"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbe4592c193so673882a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788183707; x=1788788507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KrvWK7y12wmzNf9yKs8qJQvTPbcMwwSOqP849lffmgI=;
        b=f+7dIIomVJa6uRIKV5UlrAw23v8IxJO0is8Mwl3aHFseDGbGnDZ3GbUyCY7JzADIyu
         KlqKspw7kPOpEdZ/mrVqsyUaNp0/ePM3CFNe4mWoj1qtgW6i2eG0O0yv/0Cd42hrN41T
         chKc/ZvyV0OhqcvvCj1NsqvClxRAYH1Y94cjpaNywRHVn1vEl2iXxlQSU9JpEzFwqMe7
         x8urBPi2JVu2haxMMnQEV6a5fO7Fr0uaqgCNuSaHf6ef0tm5jnnQkqwiFBSqoIpiroHl
         tAcGtgV/CZgx+6fgUBzlmYKnluEIK8oRUb0csW5PbfZqXLOLnL/lqzQAMzR8xK0IFxVa
         3VOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788183707; x=1788788507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KrvWK7y12wmzNf9yKs8qJQvTPbcMwwSOqP849lffmgI=;
        b=cMnMqzPx7FTLh/ZeVyQWbSvyu/+9Kaz8HN48vWeQ+zFr0VvK9uqnV+PGJBKQPxxCzJ
         oDua5Q8YiJNku//eDxjnMiih9Z+uvlnRCjWquYOL8xA/zZWNKJajUQsL9wEfW3Q28Irq
         LZrMFCaIchYwMJgd4Qs2rTOBj0q3+dzuBf/x2prTTvdgIQjO8miI5Ygv1TfRGQig9ICx
         42Hk4LpztgVMntLBncPivce7GMYWn8y4JbSMI0q2H+tUH2MpfwzdlGY7PWOOe8VYMXCF
         uzRlSU/SIcMlYsmjHWkDvICW51YAvJXQYndeUjGwREGKfS5szO2HCvGl0cyx8GJAfIP6
         Y15g==
X-Forwarded-Encrypted: i=1; AKwUvBw/ff91sfXXjc/pj+wyU6eKbYJv/bccKasgaDDRC9UpghNG7+360Yb31olZZPqEY5eOewOCpzdFIW0GgSpjgw==@vger.kernel.org
X-Gm-Message-State: AFuF++mSaV2FDD6uMch/n0bWWaolB31t/5wvazfRFGP0GqBAf7nSzBvt
	GEi9aw25ckCwYWR08JvY/505lmbGHbeoQlVeQxtzsHrWzEBtDWyymJQ1
X-Gm-Gg: AYBFou0u87+0GVMsD4UNK3iz7OMj+qW3/jBeEcPf4dEgVrhVnxh8GoRfy6N8vuZMGxt
	yBy6YKma0x47B0cfojxttI4qzYgdsqrgM0H0cghd3okwZXGhXTVhfkvubI9A0Hx0uNrK4V7xTJw
	k3GgqP/0PsmSBIEZEB9KFSt448wCDHmtt26sThD1tgowWLAkPPpsRN54KgR4p8M0Hkd4unc+nb9
	KQM6Jxf0FYAzE/5W4eqLdUcUy35AwyozyzaOOOJjGangM9JJPdpxJ1RDw4MB5jQAaSuWH0jI2ae
	Ki8u4Bxv72mCup3RV6ISVS0zpN9siafrGB2aWnaUAPJMD3vihemXk/uTHbS/GK2xEmfDWnoIj5T
	uK9t/AJIiE0HQbucILW8nS2Ru+8y88FZU8OweR6hq0OPeflqE6j3NVfhPN7EpV2bzVGimMoyLDM
	qPrV7u98k/ebOnAp3YGg63cODsMat4iZMXsuGEqMngdoiLrqP5yjD/Jqkk9kSDriTPB3neZuEa1
	lJH3Vi3X6+N/KsPIjJmch452v8M
X-Received: by 2002:a17:90b:4ad1:b0:38e:76f8:fcbb with SMTP id 98e67ed59e1d1-398bac28133mr12752617a91.4.1788183707208;
        Mon, 31 Aug 2026 06:41:47 -0700 (PDT)
Received: from cachyos-aura ([45.112.149.37])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7be440sm34752102eec.7.2026.08.31.06.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:41:46 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: iwlwifi: pcie: cancel the ME recheck work on probe failure
Date: Mon, 31 Aug 2026 19:11:40 +0530
Message-ID: <20260831134140.480276-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwl_pcie_check_me_status() schedules me_recheck_wk a second out when it
cannot decide whether CSME is present yet. iwl_pci_gen1_2_probe() calls it
before iwl_drv_start(), and if that fails the error path goes straight to
iwl_trans_pcie_free() without cancelling the work. The trans, and with it
the delayed_work and the trans_pcie the callback dereferences, is freed
while the timer is still armed.

iwl_pcie_gen1_2_remove() does cancel it, so only the probe error path is
affected. Cancel it there too.

The window is narrow: reaching the schedule needs both reads in
iwl_pcie_check_me_status() to fail, and iwl_pci_probe() already bails with
-EIO on an all-ones CSR_HW_REV before iwl_pci_gen1_2_probe() runs, so it
takes a device that answers config space and CSR_HW_REV but then fails
iwl_trans_grab_nic_access(). I found this by inspection rather than by
tripping over it, and I have no way to force that state on the hardware I
have.

Cc: stable@vger.kernel.org
Fixes: 41fff83fe6cd ("wifi: iwlwifi: pcie: check for WiAMT/CSME presence")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 28b276c..a30854d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4369,6 +4369,8 @@ int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
 
 	if (IS_ERR(iwl_trans->drv)) {
 		ret = PTR_ERR(iwl_trans->drv);
+		/* iwl_pcie_check_me_status() may have armed this */
+		cancel_delayed_work_sync(&trans_pcie->me_recheck_wk);
 		goto out_free_trans;
 	}
 
-- 
2.55.0

