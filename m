Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324262DCC1F
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181423; cv=none; b=N6JpKSxrLFJXoGisKBU2iJnlYFWe6adgzljYuGqepSCOT7XucFunHbsmp4JYbdzv8Xi4TEuGldBJBSuZjCjqiMIb1Y34/GaqSKT8bUDat66wJeabmrzTX6DpZb/rhJ4X/vVdKHNNHTQYg7kP1WP6EJgsAnhrSsFvuzg8MzQrtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181423; c=relaxed/simple;
	bh=j0S3huPVhLYX+6eEemnWow0e6Y8m1+FMbbbN0Acjnno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHUTFZUCKa6PlnNYz+ktob0Ge2Lz/4jbRCH2vOneuM1MFGI6rJE//YvOuoNvJBhFMVLXGxrJXnXx4VzhLvjHjwiJHJ7hyKFngXzucdljz6l1swayXAGGBJ4Gl4Mebp48m45ILPU78ZACVI0KnH99GhUruVN/B2Rs31e3Z1l58gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dr4G6lkH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dr4G6lkH"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cecdc24b1cso3145215ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788181421; x=1788786221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1fA07Hbd4bDEg1rAYcywkXfcD2j8BUvAe0Ylrh9j/9k=;
        b=Dr4G6lkHOG8ew5kzW2mKN0m4JCX34+vtZQy20q8MDDXiBIsFdn22A0Wl6y6icTTlsp
         kV34y8YWj35kfdRphfA0hu1BXI+1Q9yKFr921Ms64gV2mRzhwTAU273aAA/2i+L5Du+s
         xv5YFmrYG9c25eSgHd5vaP/md1C+lJwyokVdFaxdixCpVNcl1Qf+izOGW3bhuMxw/UaM
         CzvUOx4gfsY+yVf4UvXg7Hhq9NuAmYHFP/GFPDMpKrJenVGgTE+sJaLgwtLflnTWJAzA
         4uFjAPx1ovuMVk0ppGCgf0iZVgY86+LAt5IrmMYhNBcjYNDIE35WuDmfNVwHHVkd1d7c
         KhrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788181421; x=1788786221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1fA07Hbd4bDEg1rAYcywkXfcD2j8BUvAe0Ylrh9j/9k=;
        b=le6uAZ4lrxYRAGx4sUdrhUEg6Z63+6PQGp7e9l9ZX8TPrmmLSd3zN1ZeI/qY1xpyHq
         yWLhzkashiMGLiZkpdrNS1jPti+TKvHj4nxFEah/06609HquAQnGKYPjbdg1LaKQsB3m
         GhiVPcZdCu+tYZBJ5Luu/a5+kBOHH9AW/IF1RraK1W92UJJjLIRB2nhXlzRYbVZEiQmG
         lBy9mxS7G1vMXf7BfFP2v48TCApJeVJ18D3ZUjipmY75H9PUF7F5K1l+C9TvnjinD34e
         G/qv5EHpfPGir02XCR769lFFsfmMS0TDH15zFAnBq5W+aLDvLY4EWubQg46/w6qyaC0C
         CWyw==
X-Forwarded-Encrypted: i=1; AKwUvBwNDXZ6tYNSFlsUPT90imGObla6UHbe0xhVKxQ0maUlwNBBF/TbMA7PY59+Pi5zwW4YqBEsx/ORy7cRQAIZww==@vger.kernel.org
X-Gm-Message-State: AFuF++mVHLhqHsqKLNhI+rQBJLpvJwOtBzFcwuABEQBGWB2yo8VZOFRC
	Ommy4CLElCodwGSZBUQgSpDkoNV0xQGUt/qkDMHgGJmloKHzH5YSkU8p
X-Gm-Gg: AYBFou0+vm/Ggyj1V8QtdpWmIaSkALu9SfdazTMDx1nsbNUIrVGM++O2vEqc9kJr9qh
	fZlGFXAdpd4KG0O3Q5N8kr6qS80GtQDLsYFK/C7LPw5r2SQK12KcHj3646dHcsbw1MyedeceuKa
	zDlIObHi4ttT0e2gpUYpEON3WZcU3Kh6oaa5D0W3qxJQSNdCojEYcupN2LHhixyuhOBN/3g217z
	9iM/fQYKBLJVwP2vjuKS3JySMZ/gV4XaK8c7Q6u99ADKZE3CmKchKxt5FpqmFhWKAKMytJj6Qnq
	SOV6mGS7DEAFmabK+jqI9u/JAgCSIlRCUkLWA8Y4LZzlcVrqo/xCYPD2vehSX273F/YSnuo26nA
	Kv65oOS9mwQi57IaMd4rIAJp5BADhs20IixXAJddFumw51D3d8FivL1M/s6KcywC1WzIPnQZXOA
	ijS+4tkd4UFI+/97xE/Xhhx9tR1pzDM4AFZPRACfJT+movBPjNaxvyCnkyUleO1O/Kei2qiZIg4
	HqaruSEkQfixxiQc3qk4kXyXpjH
X-Received: by 2002:a17:903:2350:b0:2cc:f4d4:29a0 with SMTP id d9443c01a7336-2d74df5ef31mr232145955ad.3.1788181420171;
        Mon, 31 Aug 2026 06:03:40 -0700 (PDT)
Received: from cachyos-aura ([45.112.149.37])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7bf283sm32567749eec.8.2026.08.31.06.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:03:39 -0700 (PDT)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2 0/3] wifi: iwlwifi: recover a device that lost power in D3cold
Date: Mon, 31 Aug 2026 18:33:29 +0530
Message-ID: <20260831130332.323549-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a Lenovo Yoga Pro 7 14IAH10 (Arrow Lake-H) the Intel BE200 does not
survive D3cold: _PR3 genuinely removes the M.2 module's rail and the card
does not restart when the rail and PERST# come back. After _ON both the
power-enable and PERST# GPIO pad registers read correct and the link still
never trains; config space reads 0xffffffff until reboot.

iwlwifi already has everything needed to recover it: the platform-level
device reset walks _PRR and evaluates _RST on what it returns, and the
driver already speaks the vendor _DSM that selects the product reset mode.
The problem is ordering. The mode is only ever selected from the removal
path, by which point the device no longer answers, and AML gates that _DSM
on reading the device's PCI ID back out of config space - so the selection
can never succeed at the one moment it matters.

  Patch 1  stop concluding "no CSME" (or "CSME present") from a register
           read that never reached the device. An independent bug, with a
           behaviour change of its own; see the patch.
  Patch 2  deselect the mode at probe. The driver selects it and never
           clears it on the product-reset path, and _RST does not clear it
           either.
  Patch 3  arm the mode in .suspend, disarm it in .resume, and if the
           disarm fails *and* the device reads all ones, ask for a product
           reset.

+57/-10 over three files. Patch 3's new arming is confined to discrete
parts, but its demotion of a failure log to debug level applies to
integrated parts too; patch 1 changes me_present handling on all BZ and
later hardware, and patch 2 adds a DSM evaluation to every probe.

Since v1:
https://lore.kernel.org/all/20260829095437.44716-1-navonjohnlukose@gmail.com/

- v1 selected the mode at probe and left it selected forever, which is a
  permanent change to platform state for a reset that may never happen.
  v2 arms in .suspend and disarms in .resume, and patch 2 clears what an
  earlier driver instance left behind.
- v2 requires two independent signals before it removes and resets
  anything: the disarm failing and CSR_HW_REV reading ~0. A failed DSM
  alone is not evidence of a dead device.
- Patch 1 is new. It is the me_present bug I said I would send separately;
  it is here because it is the reset ladder patch 3 reasons about, and it
  is wider than I described then. It applies alone.
- Corrections to v1 and to my analysis mail: this is Arrow Lake-H, not
  "several Meteor Lake laptops", and it is one machine tested by me. I
  also said twice that the test would key on config space
  (pci_device_is_present(), "not answering config cycles"); it does not.
  v2 makes no config access of its own, because a device in D3hot answers
  config cycles while its BARs are dark. Config space is still in the loop
  one layer down, in AML's own VDID read.
- iwl_trans_pcie_reset() is left alone. A draft suppressed the CSME
  downgrade while the mode was armed; that premise only holds for a device
  already off the bus. The consequence is under the --- of patch 3.

Notes for review:

- .suspend does not reset anything and does not touch the NIC or the
  firmware: it reads the PCI ID through AML and writes an integer into the
  ACPI namespace. The reset only happens from .resume, through the existing
  iwl_trans_pcie_reset() path, and only from the work item it queues.
- This is recovery, not avoidance. The alternative on the list is the DMI
  quirk patch 3 Links to, which disables D3cold for the affected machine
  and costs nothing per resume, where this keeps D3cold and pays ~7 s on
  the resumes that fail. I am not claiming this is the better trade; it is
  the one that does not need a DMI entry per machine, and it shows the
  hardware can recover. If you would rather take the quirk, patches 1 and
  2 still stand on their own.
- Arguably the better fix is in the PCI core: for a device with _PRR that
  comes back from D3cold not answering, evaluate _RST in place of the
  speculative retrain pcie_wait_for_link_delay() attempts. That would
  leave the device alive before any driver .resume runs, taking the ~7 s
  to ~4.5 s. But arming is a vendor DSM that has to be issued while the
  device is still alive, so the driver is involved either way. I would
  like to do the core half as a follow-up.
- This is not the missing D3cold->D0 recovery delay from "PCI: Apply
  mandatory recovery delay on return from D3cold":
  https://lore.kernel.org/all/20260708152650.536604-2-mario.limonciello@amd.com/
  That delay is real and this device is subject to it, but I left the card
  in the failed state and polled it for 60 s across ten PCI rescans:
  0xffffffff throughout, link never trained.

Testing: one machine, one BIOS, discrete only. Five s2idle cycles, four
with wifi connected at suspend and one with the radio down, and the device
recovered on all five; with the reset skipped and nothing else changed it
stayed absent until reboot. Methodology and the untested surface are under
the --- of patch 3.

Patches 1 and 2 carry Fixes: tags and Cc: stable. Patch 3 carries neither:
the device dying in D3cold is not a regression from any commit, the driver
simply never handled it, and I would rather not invent a SHA. It is still
a fix in the sense that matters, since the machine loses its WiFi until
reboot. Whether that belongs in wireless or wireless-next is your call.

Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>

Navon John Lukose (3):
  wifi: iwlwifi: pcie: don't infer CSME presence from a failed read
  wifi: iwlwifi: pcie: deselect the product reset mode at probe
  wifi: iwlwifi: pcie: recover a device that lost power in D3cold

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 ++++++++++++
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |  4 ++
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 39 ++++++++++++++-----
 3 files changed, 57 insertions(+), 10 deletions(-)

-- 
2.55.0

