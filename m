Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792970305;
	b=NXrj9gkqzvOItMBT4dQTCoWfUafHG1P26mij3bRwmE4BSJrrR9lMs2ajfnqDuUBmAwxn
	 2RbTw2F/MMBcosSumL+B5/s/NbQasuCnVFzGYeIRBeUrdR3DcHUHEe87N47BW5p68jgBr
	 Ce/YSyb8dHT/4KQQuMY8Q5l6gS5Hr7tal7ynQHCAECu2fHsr4OgAwDgJiq9Vu9xBkTrC6
	 RXizKHLuTNEoYLKsOs/iDcgeBfijwqkjwSQrtopPVlfSzhT2En+BoCtUGcCqolHFAkGqp
	 AhavLOsJu2akY9vFXCnbfzEz30myxEF0ezCfn3FiX4JnOSW/chTQNWC66S5gmLctfrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792970305;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IsDZuYe/u31Z24m1fo53qcD2/S0Aflbxvhhbas7bU0E=;
	b=NDNbWGBAsCjGny+/+8AjsetJJWhmEADOcQ3bDHuGf6slfCf8DjhSwo3oe481xYgbUPUm
	 N6C2jISNEevfEJgK2dIY5PKbMmK8A2xQ7G4X72XySsihbaDyL8RaGeZHehkBU8nqa6DfC
	 6dYZp423vDWvsR5W30wztK+7VGQDdhhvi7dyP/GNWRd9GekFS/nZzYipRAb47jDKBYQqD
	 QyUhMgmnqH6YkAife4DlE1X2cu+egh8C1Ggze6Pn0FVz4l1pgNuYCHsCrNDplfsmwJ8Nb
	 TTX4/7DS0feIRfdMb9uv01uHLUBrnujkLLzgDg0nF7U/Rt5CCA8ogDANaZJE+3XG1yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YKeT6MzV;
	arc=none smtp.remote-ip=91.218.175.225
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4C606A31F
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 23:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AD4C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YKeT6MzV
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=giFcj/H5TeeaY7RoTLdlL7KXSHlcCEvpCSpIOsC9ork=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792970302; v=1; x=1793575102;
 b=YKeT6MzVWMiM10TIAp+pbD9GT3ydozIH/vyyY8c2+lgGpwjaei8W/1u1raHaF4yWVwv9cM+n
 0AUTWzCeoXfoVlKSIAIHSE/f45CkUkVRn3cyQoNT6e9v3FI5lmyEsWnpp8Nj/1FIgIZ+xQzyJ70
 q76hVH0R/2zKvgUPXVkvVXkc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7259c9b1e57365a6;
	Sun, 25 Oct 2026 23:18:22 +0000
X-Mizu-Trace-ID: 7259c9b1e57365a6
X-Migadu-Flow: FLOW_OUT
From: Denis Benato <denis.benato@linux.dev>
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com,
	emmanuel.grumbach@intel.com,
	linux-kernel@vger.kernel.org,
	kernel@lists.opengamingcollective.org,
	Denis Benato <denis.benato@linux.dev>
Subject: [PATCH 0/1] PCI: Disable D3cold for Killer BE200-family WiFi on MSI Claw A1M
Date: Sun, 25 Oct 2026 23:18:12 +0000
Message-ID: <20261025231813.128649-1-denis.benato@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

The MSI Claw A1M is an Intel Core Ultra (Meteor Lake-H) handheld gaming
PC carrying a Killer BE1750 WiFi card (Intel BE200 silicon, PCI
8086:272b, subsystem Rivet Networks 1a56:1774) behind root port 00:1c.0.

During s2idle the platform removes auxiliary slot power from the card
(D3cold). On resume the PCIe link fails to retrain:

  pcieport 0000:00:1c.0: Data Link Layer Link Active not set in 100 msec

and the card reads back all-ones from every register: iwlwifi dumps its
complete register state as 0xffffffff and the device disappears from the
bus, so the machine has to be power-cycled. This is the resume half of
kernel Bugzilla 220223; the detection side of that bug was addressed in
commit 224476613c84 ("wifi: iwlwifi: if scratch is ~0U, consider it a
failure"), but the recovery path still does not bring the card back up.

Keeping the card in D3hot with the PCIe link in L1.2 during system sleep
(not letting it fall to D3cold) makes suspend and resume work reliably:
the card survives every cycle and NetworkManager reconnects without errors.
The SoC still reaches S0ix during the sleep; measured with pmc_core
slp_s0_residency_usec, a 241 s timed suspend accumulated 239.5s of
S0ix residency (99.4%) in this configuration, and the fix is independent
of the platform's ASPM configuration.

Patch 1 adds a DMI-scoped quirk disabling D3cold for the BE200-family
device on this board (pci_d3cold_disable()). It mirrors the workaround
distributions already ship as a udev rule for the AX200/AX210
(8086:2725), which suffers from the same class of failure; doing it in
the kernel removes the need for userspace workarounds. I kept the quirk
DMI-scoped to the Claw so that D3cold behavior is unchanged for this
card family on platforms where it works.

Testing: MSI Claw A1M, BIOS E1T41IMS.10D, kernel next-20261023. Multiple
suspend/resume cycles with an RTC-timed wake (240 s). Without the quirk
the card is lost on the first resume (all-ones register dumps, "Data
Link Layer Link Active not set in 100 msec"); with the quirk it survives
every cycle, reconnects, and d3cold_allowed remains 0 across resume.
No AER or pcieport errors are logged in the resume window.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=220223

Denis Benato (1):
  PCI: Disable D3cold for Killer BE200-family WiFi on MSI Claw A1M

 drivers/pci/quirks.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

-- 
2.55.0
