Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD4388E7A
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334096; cv=none; b=lUlSeh8TPFHVHXEE0qhJn/UkDGdq7jm1AOlbw4HCpinnzWFqBnLLFiVXO3VXIFl+hTMzvgImYEPK4RL1W3/VBF/PRiNtpFGxpeq7mOpGFd5wc027VMEBxNr+JaPhoWqoGYd6YF06HSufz7XyAUsMPKPGyahM1gYGtD6Wl4G8Xo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334096; c=relaxed/simple;
	bh=6QTSFu+QYOXAVxnu/+LpbdSsP3vJnCO72sARPcer6a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCHgj1/PeXpu/ffZSqIIS6IAfHhhfKkR94+a/Em4eI3kZnE0CLPflkZsbrLrRa5TjLqKZPZhwTVIuwjH5vp7MxiRenUS2dQIFrq/JZHi/X2uZlXFSkaFvKNijA0BuXx71PgIaGwp77j9PTbOq2+qKIkaINJbTt0kWHs8bDgGfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlFyf5pM; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlFyf5pM"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d6ff3936easo1757875ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 14:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789334093; x=1789938893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FAwWGoInaiibNI+PkowbPr1zLMnMrJfky1hPSvm8w8c=;
        b=FlFyf5pM3GAYs+p80ct4FtxkI7VJKlxyKL40ziyCnozRwlo7z7NDVd/8l7j99srd50
         R2reYFKpF/w5fROIsmB5++KmacplBm5+Pv/RMIDZ2EhWGB2OpJLSIOdiNfsRYh8XPVy1
         +KWhz+SikqZnPFlHW3Muchys0TjeK9BbFHhZ2FBuVZkBnSts9dTWLEN7cTzacP/1VSE7
         9g9LnMo9J9f42Ms4UjjFtYMuB7zwgKbrQfuI6EU0JmT5QMEXP2fLJ5xjdek3EQ0Rp2F1
         cid3JtjAQCdi9CG7Zq5sIIedUZmG4gDHq7b/PRfWD358gPpSoXMkm1QtzsdDNQWQ1wrO
         v5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334093; x=1789938893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FAwWGoInaiibNI+PkowbPr1zLMnMrJfky1hPSvm8w8c=;
        b=cI2ahDMXhiYIR80k89a9pPkqvGE+8/Plo3M8w4pbCN6cG9Z+HeoaEpGF0tCU+NaC+P
         ITTyHBIxM23Yum+qlFpaAZYkgDv4w/SRHWSxyhQphBWj4o6/Il7iQsND98So+PxBMw8P
         Gt6JUY+Ad63PMKBXyEDqq8nB6TZhkE2mJ+u2p66yl2OnjZtG8ufMDmb1wnoF+DLv8rhR
         SdtGuDS2al0rucVmlOv8B/uNFWQxIpyoyFUkyHZUheGQLxUkE70jS2B5nepyU3x2V4Ps
         +2kbAaKptnma6Q+MTO9fdPk9l0H/8lMMvqVvxs37lcOLSvEv2XGAaOP9533MgDlaI7EN
         5xfQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5CKjiZzy7f43ApXnxN5m7t8crpy7siLSI0e2XBmd+adqeSny4Oki0m7d70MetZHMt+Igih72gO1FvZX3NIQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mAJ2jWYzgM+DTmikFkusF4KKIASdI8opHI4x7bYOo9E9ywxp9u
	4/+W30IFgWJSTChHbkoO0km3HXLTMfHQahgvDtWV0PyDdGN4vSSXmEWp
X-Gm-Gg: AYBFou273LH3pH5CjVX38fj/l3n+oif0Kc0RNZAUSe+IJ1AlgjHLGumhtkwwVXASEcw
	3ea8dwsCqoPwJGQfijV6Am+S3hayurHSpqd38Dr/ZBIUGG2Z+M+JNjlrrUU1T5hxN81y3MNJ0uh
	2tM3wPp2wq7ehqW2f/cXqtF3KJmbOKLkYI4ZGoAgrxso3o+te/Tz9/8tEbZO8NP9yF3+CACAHWl
	ci9mG66k1cDjf5HUgKndwJUzANeDoFxBtrAzHpuEyCx3u7XnMYj2hy3PBIHphuvlzg9Qa3hpJnm
	X+lOXoecYj6746wZxU/UF4gz/1RjW4E/8M0JfbX4etOr/aDCpEK3hzlbYw8JmzZICqmUV2mNy0L
	RILlUzOehCxWv1Fo+g9z7xZXz3kGoqj7C2huQQb3L+0r2sTuqLS43Pb36goOR02D8LHJ4aW/ntc
	kIg1WO3bq0BeUwYGx3ubaGufjkL0jDNnuGjWwBMBY1+bgth85/vtrAV9qD0KaJm6gEgTYo9/qMO
	gAReeSlX/pu5iE1QgmqLhkv/zslsnF82bxKyqpMv7kUlkCrg+M9G/Wfq9UWOnIBPauSqWLTJlfp
	W9SUc4nSb9woB6AiEWEg
X-Received: by 2002:a17:90b:3808:b0:38e:76f8:fcbb with SMTP id 98e67ed59e1d1-39d9c2249c2mr15929475a91.4.1789334092888;
        Sun, 13 Sep 2026 14:14:52 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.109])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b348cbsm21382925c88.3.2026.09.13.14.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:14:52 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	helgaas@kernel.org,
	ilpo.jarvinen@linux.intel.com,
	emmanuel.grumbach@intel.com,
	nika@nikableh.moe,
	mpearson-lenovo@squebb.ca,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless v3 3/4] wifi: iwlwifi: pcie: deselect the product reset mode at probe
Date: Mon, 14 Sep 2026 02:44:27 +0530
Message-ID: <c370900547aa57b4397e5ea9b7b456b82256ddea.1789333511.git.navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789333511.git.navonjohnlukose@gmail.com>
References: <cover.1789333511.git.navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The product reset mode lives in the platform's ACPI namespace, so it
outlives the trans that set it. _RST branches on it and does not clear it,
and the deselect in iwl_trans_pcie_removal_wk() is a DSM that fails once
the device is off the bus, so a later request for a function level reset
can get a full product reset instead, with Bluetooth still bound. Deselect
it at probe.

Cc: stable@vger.kernel.org
Fixes: 9673c35486d4 ("wifi: iwlwifi: implement product reset for TOP errors")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
Patch 4 depends on this, not the other way round. By the time a recovery
reset runs, the disarm in .resume has already failed, so the probe deselect
after the rescan is what clears the mode. This one therefore stands alone
as a fix and is tagged for stable while patch 4 is not.

 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index e5edcc2..d93d8f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4256,6 +4256,8 @@ int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
 
 	iwl_trans_pcie_check_product_reset_status(pdev);
 	iwl_trans_pcie_check_product_reset_mode(pdev);
+	/* a previous trans may have left the mode selected */
+	iwl_trans_pcie_set_product_reset(pdev, false, mac_cfg->integrated);
 
 	/* set the things we know so far for the grab NIC access */
 	iwl_trans_set_info(iwl_trans, &info);
