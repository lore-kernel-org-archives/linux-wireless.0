Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB13E169B
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 11:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224150; cv=none; b=caDk618O+3WM3DPoQAM5Ner8vEU14og3uFyKhKW2RlSmOzosE5a6gu2g+5/b3oXIyfQD9Q6p2mEqwGd75rO3vLC6Rqwps60Fi68rbuWwmWqjcqArnkEvUcaj2RVRrqmiGHrKsrKHOHeEDGb8dOdJdaBNo5aQOmFlWjVCeuXsvE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224150; c=relaxed/simple;
	bh=Pdy7WD1j3cCQvvlH5VMMkIeYGC0ITBssJ8Ug/ckRuAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWfxhXnsUFRIF2gCesR+ZjC2lbfDEqa7Ez5uc4XNHzen9kQxoQ5UtkKAAYyHzQ5F56DrQR3L4LhD1hkJz3EX1wG8BMho5KN3QycQCTeVdQN5vBDpWA3Q0B0ajhMUWAFzWU6wKkOfwROIciTWYNm9DqrQkrUKj5iQInAy5fcbq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DiZ7UbgR; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DiZ7UbgR"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso1725771a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 04:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787224148; x=1787828948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yRalZkTDb5ms3yiI9vWbgfiQlKD4y5bEfSKwEXCrSGI=;
        b=DiZ7UbgR4O35oPKbu4l2d6dL5OYMNX+q6RKlRU+iX1AA3ZqxKi1H7/acGaMdDKDIox
         ISXLqPyfAc4m/3X2Y6eV2JgFN3fCdhUAyrtrthlJurqsK0b8MEfYBEZP3tii86Zd+sfZ
         CP/KIJhkiRrNGTA4CJeZaQ1GImmU6Jc35+dAQdrTtOjG1wtDar6ekr97I3A/VEqQean2
         maeR3+TZLormrrc9QTAQ8jS/QLdwOA9IIfz56Hd45dhQGytsZAsCZg3Z0yuJuFTNQ0Wc
         teBgsGOL4EuOmQaFJRV+Q/WmiUFrgtCjcxVls9nIHk0Gy/lZWFcaoEftUG5SAtKVl8bm
         fVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787224148; x=1787828948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yRalZkTDb5ms3yiI9vWbgfiQlKD4y5bEfSKwEXCrSGI=;
        b=LG3FHm2vzwASNxPSw7MQhy89qKxKwts9E5mkcla+97c27xt76+7gOYmGb+bxNIpOrs
         9FIkC21uMWUM9J8h5vCZbDboE03ZxexUj319fua/tdXUgF5PpYYgnrY51NU2rcN7z+6+
         4l24iqPKIEvyr/SZvDTEHoMazQyTbY5QZeavEsmZE9MkM75ajCfBotfVg5PzAM2Ayu90
         W5gf3nPj/bnP0udaehQuEydoy6IilHophYD+Yg7Fok0LK3Y58lStURHbfXOogCjKRKSC
         GUR0tJWFQvaydhfkJVRxZqLG9MyNcB9h6ksTSidBMJ8s37mcIh5i1zhP/fUkEhLeWl1a
         RzgA==
X-Gm-Message-State: AFuF++k/VrjZrPTYsQd5wXiDcm1cWYsz3/wal/f+pM4CV7Fvimqf1+6H
	pilwHf5y6q4poVtjPFKAVSMNBs2Dp2nmUeMcClbCYph4GgzHYrOkC9UV
X-Gm-Gg: AR+sD13Aav0Galh42OHaP4d8DdLrPdJ1NkxI1mzaTgpfiIrEFfBRJTUcjMq/Gzm/unk
	ZdfoBwHmq58myMXg6WgoHuJGwEbbxYB8Ks2JQIcpWlZcuLupwi0vDwYPnseXEZAC9U+RX8YViub
	i2aTDFyPo5Q+zE8cdZh4sH3OxdMTm4aUQJ1RxL2wKNN9C/SwYuJdLwckubeR9PMGlWZ31hXCSPT
	mgAJpM286SKVeHR4FMo58h+bhDdLBvEQjn6kGI68TotbIohtJO39EK8zejHzWlknIfvWGwqIcFX
	iKKj8Ctb3qMcywNeruf+ID/dZAdoG+9S+TJR3EQdwV/TwpAPeYER4106yIL+tJs1Ry0XYbVMdlZ
	loHkvJdv2HM+Bwf9vtgXr9ADdMZIMWfcogM6ZygWoAsSckyVvxrZSBNtkInXC6rpUk4qH2UAn6n
	BtrHzWWdAmWTfZ/EyidJ6Jx9gfOKaAZDprXnS/GLsE8wmZth3FInK0TfstUYn1EHmWIZyKh7VPz
	ez89RUIF25K3So=
X-Received: by 2002:a17:90b:5748:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-39580aa259cmr22837499a91.7.1787224148152;
        Thu, 20 Aug 2026 04:09:08 -0700 (PDT)
Received: from localhost (220-135-95-34.hinet-ip.hinet.net. [220.135.95.34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbba811sm6979673a91.13.2026.08.20.04.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 04:09:07 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Alex Hung <alexhung@gmail.com>,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Aaron Katzin <aaron.katzin@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] wifi: iwlwifi: add new pci id for 6235
Date: Thu, 20 Aug 2026 19:09:03 +0800
Message-ID: <20260820110903.1823629-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@canonical.com>

lspci output:
Network controller [0280]: Intel Corporation Centrino Advanced-N6235
 [8086:088f] (rev 24)
 Subsystem: Intel Corporation Centrino Advanced-N 6235 [8086:526a]

Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
Resending on behalf of Alex Hung, who has since left Canonical.
No code changes from the original patch.

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a3e6c9e09a3b..7b4f4c63e91b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -208,6 +208,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6030_mac_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6030_mac_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x526A, iwl6030_mac_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_mac_cfg)},
-- 
2.53.0

