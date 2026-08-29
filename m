Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409952D12ED
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787997297; cv=none; b=YbSV4AyfWZVujPCnyEkMYZ4jVMZKCQqn52t58V6dNopiC23AaYnP1N82dFaUAWimQ0DOpuWN22QrJhvgKIpExKitrOPq+hEl/23boHZcq6teNGnWqasl26GfQUBembgIk7X/h7A7maeWVN/aTBg713uMhhQOlGq5ImR3yBjaq9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787997297; c=relaxed/simple;
	bh=7hM5WaRrHs2c3LW1CjwRnik2dDd+6Q2n4lB4uydT71o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpiY9/3OtGm/OcEQR4UqS6oVtcLGTsZ65I51AjHdleDG934pzn44FEehALqgbX0i6lrQep1/s7liT+9ipvlUGhad/v/8rNksG6yTA1Ifrt9iLcDcaIf79vZvejLPCGIks8gUmiEbdhNRN9BxtE/bhjUJBcepfImZUiTGtUyg9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpXUncpn; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpXUncpn"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d590f4c291so5027765ad.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 02:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787997295; x=1788602095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+bx+HWR1lJgM1IpCVaNlI18J07SWUFh64Ef3O2YpAQ=;
        b=CpXUncpnnvrvuLB+Fg4ojrZzSGnwrTN3kZkN69xW619n0Zst/ynY1HhErtHPEvrQUA
         n86qnV3ppao0z4gDC39rjx+sFtZTtkJmT8FrYg9V1ekF3QbTY3x9I9PkowZFzDF5kbaU
         K1cVlVh1kj7CzSCY6pjDhwwb58Kwh7NZOSbjE1dWi8VeU8WaxKlGYxabWy45CUcu+9az
         PArZv4c5Sp48HZrLiClVn8GkvNz5OvgAmDiaAE9wSXBQJzzin+E4YJD8wRl+enlRmgz0
         3bw50s5V4iNvPlCsKqdDV3lwL1ajGex+vnOF7T2/5TYfhlDGvv1f/Pu5XRULq4wTT1BX
         M3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787997295; x=1788602095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+bx+HWR1lJgM1IpCVaNlI18J07SWUFh64Ef3O2YpAQ=;
        b=ZkoHIxFMLE0Pm7Ruffr8YKKuMuU4rTkN/MrlNt3b8g3L3ldt34uI4RNiPpXl8rw1pC
         Q9vy8lxOJD4AnsiVpQnVk+bHJyl06131D5+GJvJm3Hkl9bkOdrPADNn9XeCOQn9IsJNN
         HUNWNXJaM9ntTTxJ+xx5p4sIO/oB0iDZ1E21g25mjYr/z44YKWDCAYKmglac3aoA1JiE
         jFgp7XHEktVE6t+pJDB0FyQK5rw5PWqoQTko8nDTl9jeNRCxwtJM+OuvumkupzBN3nov
         MG/BvhrAF3hLS2sSRWoWlr9q4pckjO5xQTSnbQZGFn4zSBBw3vT6J2efxzEl61lhNy+k
         nrOw==
X-Forwarded-Encrypted: i=1; AKwUvByppJLApx9A7UL1xClOetoCRF/TCPF+bnpU2WKWFk3DkZvX8sI96SS4JsZhtsZSMQsw99it58d/bOjhr8kh5A==@vger.kernel.org
X-Gm-Message-State: AFuF++l5CpY4ktkwQJRNBldJCvyRh8bl8mC88+0/0ligSz74iU9H8eDx
	Axp8WQntwlxwK7CoOg1iS3A5OJqOlPDlMvu5Yc1/iaPu0ODLreXXIuKk
X-Gm-Gg: AYBFou1vSaINQG03bh/Wg4CU8dwHoGYBlQeXsVzXw8OSwkbjZ/UJq/ch3O9XBh/djKr
	UYCakOhD//1qOp3EseKgdqyKdHzhcfedOHceMR9E48c3YTYJlYTRhxRrOw/VCLjFRieQqQ4jZHC
	1CLgZOh2mSPtkgBclF/6ZgA1Y0GhUhBCx4U/ibgferGB+T9RCJbKzMev9wX4o86gNOXnzkLI4ZI
	jPvpfWvn96gEroKVOM7e0rzcbA//tXoISQA5hrdKbT38njhHQD8PV9QwYo7eOWdV0NVuo1lTQEM
	FMlt2g3I46VGTpRKvRhxeKWR9D/6GODKdSvTgHBor9elFI2GHhJUcBhhqukXN6uIjIwT4KwyCbY
	L8EOVL4hpAamwdk7LYmgIb7cwi5yVU6egeUove6R40F20bHzKy4in4VtBo7u/wrknJnNLAP1+q4
	NOp8Ne+40YbqSlUQ01BVbm9LqlGPTitgTwbcIaOwfAEhv2LfRLNe8bePW55vx174lTiq9nxbgP1
	yak5aGvWX3/AmdpyQXXaEkn6912435tJg==
X-Received: by 2002:a17:902:d2c7:b0:2c9:ed4a:c3a4 with SMTP id d9443c01a7336-2d74ce38075mr120434055ad.0.1787997295482;
        Sat, 29 Aug 2026 02:54:55 -0700 (PDT)
Received: from cachyos-aura ([2409:40f2:3104:d691:c7eb:3b03:2c8d:127f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f783c37sm15775697eec.6.2026.08.29.02.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 02:54:54 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org
Cc: nika@nikableh.moe,
	emmanuel.grumbach@intel.com,
	helgaas@kernel.org,
	markpearson@lenovo.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Navon John Lukose <navonjohnlukose@gmail.com>
Subject: [PATCH wireless 1/2] wifi: iwlwifi: pcie: arm the product reset at probe
Date: Sat, 29 Aug 2026 15:24:36 +0530
Message-ID: <20260829095437.44716-2-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829095437.44716-1-navonjohnlukose@gmail.com>
References: <20260829095437.44716-1-navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver already implements the platform-level device reset (PLDR):
iwl_trans_pcie_call_reset() walks _PRR and evaluates _RST, and
iwl_trans_pcie_set_product_reset() arms it over the vendor _DSM. But it
is armed too late to ever help.

set_product_reset() is only called from iwl_trans_pcie_removal_wk(),
i.e. once the device is already being torn down. On these platforms the
_DSM dispatch is gated on the firmware reading the device's PCI ID back
out of config space:

    Method (WIST) { Switch (ToInteger (VDID)) { Case (0x272B8086) {...} } }

If the device has lost power VDID reads 0xffffffff, WIST() returns 0,
the _DSM never reaches the vendor functions and acpi_check_dsm() fails:

  scheduling reset (mode=6)
  ACPI _DSM not available (-19), cannot do product reset

So the reset stays disarmed, _RST falls back to a plain function-level
reset and the device is unrecoverable in exactly the case PLDR exists
for. Observed on Intel BE200 (8086:272b) on Meteor Lake laptops, where a
D3cold transition removes the M.2 module's power rail and the card does
not restart when the rail and PERST# are restored.

Arm it during probe instead, while the device still answers. The mode is
sticky in the platform's namespace, so it is still set when the device
later disappears. _RST is only evaluated when the driver actually asks
for a reset, and a subsequent non-product reset re-runs the existing
disarm path as before. On platforms with no such _DSM this is a no-op.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221695
Fixes: 9673c35486d4 ("wifi: iwlwifi: implement product reset for TOP errors")
Cc: stable@vger.kernel.org
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4252,6 +4252,11 @@
 	iwl_trans_pcie_check_product_reset_status(pdev);
 	iwl_trans_pcie_check_product_reset_mode(pdev);
 
+	/* must be armed while the device still answers: the _DSM is gated on
+	 * reading its PCI ID out of config space
+	 */
+	iwl_trans_pcie_set_product_reset(pdev, true, mac_cfg->integrated);
+
 	/* set the things we know so far for the grab NIC access */
 	iwl_trans_set_info(iwl_trans, &info);
 
