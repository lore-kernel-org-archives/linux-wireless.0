Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792715262;
	b=rEEsiSaej4/Cd9qj9umqW+RbMSbB5KOzOMHlQb9mICcZLjah2Ba1MVu02+TanJlVfMtG
	 P1RVCjqSteNIadRrXsWRNTVtQtKVvjiwcBx5S6aoTgb7Q1hcgp+zY8X7VroeffD3DOlH5
	 yp8fg9bo2g4qOMaTKPHkrSSu7+QD+A8EuAgja2crJmbG1n+xddfQ6zMbR3qyj88pb6QvK
	 eNs8Yn+Elpx0tEJnuHVVLVMueJA3+XIXh4yScYtI8WAX4+BoEhTlwXpT/zmU4xc1l4n4J
	 rdtS7L3gZNd9aq8xgZj2fzvLY3p62bRSNS//bJBy3bPXGDY41R6fvOtR7KG9Uw49iuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792715262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:MIME-Version:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=pm5vW6+ujd/T3Jp6qSlsmMMIGHmE+dhdU3UAkNEbxAA=;
	b=5VzX047RKmpnhP4+0pYVzz7e7HsBXLdDFV7RZIsgSGjwVrLZcerAvdMzaSQtaWZzBlQ+
	 yuD8feao6udjvqNzmOSfTxMNk1fSPUBI4spjsIIDVfIKT8v3+TwS5yArGTJ/83KTiQ+Z3
	 3akaUmzv5UQuB6DEEhP1sONcS9NlpNI0FyQ7p0FjxlIsmdGs0ywS/MRqXQ0gGWycawcza
	 6mdKghWmanMLEgdG7jemTfMMOCUybyov2m4ta/uMBsyXP958/ZyBTjlsw1y3nK0wASuh0
	 zozMkPvrk/YxTYwinXUrlRn9QrChn5HgRocTS/wnouU7oVHGvmX5jd+KXmM7ng+o7YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XrfPgVoR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71407606A319
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71407606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XrfPgVoR
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48df4f540ebso164165f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792715260; cv=none;
        d=google.com; s=arc-20260327;
        b=Ou4YIaofe26cb5378mj36gAsM2ILuQDdjSet6SjbUHKkcXnf9rnptQGwLQHI5os2EC
         7KLRjweth+hoAEdB2DSKslDMCsuPqXpWpi2k4dh8LYfaEPsU/fz3Ec0PPPPCfmUmfe1s
         tH3SOAiiFZwJpaLcxZIT7OAQ93DD0PHclX/mQIL4AAnEJBGXq0gvT8CC/Du09b3JKuHd
         PR2d7Nk6YYJ2+Q04q4LbE4oXVdFUBOvt9X4gOaqdx3KzjeCCJvIA2QOstzd9Nm1+thXN
         ClZnibqei66YasBAqYNWW14keAB3W3F3PXYSkYQ0vrtnDokConwd33poexobb7dNPYte
         mEPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pm5vW6+ujd/T3Jp6qSlsmMMIGHmE+dhdU3UAkNEbxAA=;
        fh=2I65mHAh8sZVWWOzQNC941p152I/Gz/ikx9BmhEsOBw=;
        b=K7YG/SsBFLhnIvB6TiLNwVnL9sFYRcQcw7LKY1AwSInckVDsTrl8xie2AlZUZTzR94
         om4QqvJSQ0weOdtGLh9lTuB86CXTBpmzSoEZPWbftHBabCCxQW8h5O+6gg2uqsfOkG/H
         5gY3NiNpPMsRbvyInc/ZJwTfKPDqDbzFNZl2KFEatvK8OK3PaJxZifalZVYCFdgw7/5I
         Aq9xEkyH4fbuZxLi+r2jwOLnUpFUHwq3mxWpTEsH08enYuEsjRmwHO2qUYwXlHG2DgbU
         a3xYgJyDrXO6jRJhnSrHJlLCqjxG6mOeG1njEbIb1b0nfEqFQwlUkYckziiJtCbbXAS0
         E+xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792715260; x=1793320060; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pm5vW6+ujd/T3Jp6qSlsmMMIGHmE+dhdU3UAkNEbxAA=;
        b=XrfPgVoRZ690/eV7JuTIHc/lddot231N2axusOP2nNqW3MOE1kehnATJZkGASKIFNc
         28TNHJGO1/GFVS4v816H9j9eQxykSeBQjwmsOE3wQLKuJg5mLUec9qutSOLAh7BxzeBN
         8Wyqx9YPHrqiqSz/6NNoirDISdya+AQrU6VNWBov+/szTpt4M6wA96XK+H8mrlFylRqy
         x6WD7NhHusn4yoklGhP4xCOph0EUNR/kTVFRVjCS0UM7ZVm1f+F81ydvDwovBTFiW3Ez
         67HPUGEXwhZEc+quj9K4evXGJLLTBhYkua2cR4RQDsVt+/d2awsiwtVRHFhMgYe264Y6
         zsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792715260; x=1793320060;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pm5vW6+ujd/T3Jp6qSlsmMMIGHmE+dhdU3UAkNEbxAA=;
        b=2GMVmYHNPv5gwo8i3WPcN0ZF5r1nFf33XMTQ5WhII29M7gMM8voiSAD+1kzBamBilJ
         G6vdC2e/J+5qOY0/dOBE/A644/hTaXCZkYxj17i1t61S/YHO0h8fKgd766LxkIvqFAWY
         TK70dYO2OYFf6Qb2SABslDXxQI4lb7lHKCjzsEqZuuN9mDNVnzw3dthlvDMOV2KRXYa1
         fDA8KQMbUUa9K2NpyulCGOtYeSJKBl5f2WTE3p/rCyhjdiyV1QiQ2xLDlvJpU3000KQz
         7L5W11bIcV86zHEzFK4YiuHKZNCsyzEJ7DBHB5Mf3q3NHWsQ6gCUT8rlA0vGniVgCj/6
         +2RQ==
X-Gm-Message-State: AFq9FYJhrMv+ubCx/2OZdokVFSaFxEGrpKdcVHLYsUHLf7ZUxWLvU/Pw
	jcHb9/2j3/DSWDgbK9mr7eF9+mKiBVK+7YVAYCWgXd7HyDEGxyiWEEz7rO3WLOcGDCidwkhdyTT
	G57wX2eEKCBl6PWyKjZaKSbGv0/mkle2qZNw4
X-Gm-Gg: AYBFou0zjOv1UrqvDZWyTgb3KwfRKo3cY0egsfOwKc/uObSRBiIKqZxJWTJsk7kJ5cX
	NSvcFg0FU1d22KKnGPBH6+iuS3hdQ40bhmsFZpc6ifmHkhlUnfswe1UI0FL5Zn5xfYx+MmxRUrt
	4CtCX39WbLbqBmLSMKJHzPhRlDxqxm6kIkvMqZDmNFtZBf5yLaq0G5ozU3ogvYsNfmvRpin0OTA
	ZQyBu+NuEQ4PcfIf19fQu4BbzlyWkovhSQ7uMnk3AoMwIATE0CPyR4ERN5sMKJHZuzrSItOezut
	mO4Ew3DD3hEU1/IvOLX1UCDIiuFHzh973qvEiMzJHdWk3Gta/3Iqx8vSNlQHVyPzi0LflNdlQCm
	gCZLiQyoEp0udpP/hf7VkZ3PYcfL77qgQH78=
X-Received: by 2002:a05:6000:2310:b0:48b:f93:3b87 with SMTP id
 ffacd0b85a97d-48e3859ce44mr661422f8f.30.1792715259541; Thu, 22 Oct 2026
 17:27:39 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Oct 2026 17:27:39 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 22 Oct 2026 17:27:39 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Jared Hooker <jaredroberthooker@gmail.com>
Date: Thu, 22 Oct 2026 17:27:39 -0700
X-Gm-Features: AclHuK86yoixlVm3vzD4CaxyQYWPY_UVQZ7lW8AWoOKc9kl0usLhMeTXtpquANY
Message-ID: <CAF4x=YaDUpjBZSmFZzX2FwE=6uzq8V-r78KSRwfg_=NX-buSAA@mail.gmail.com>
Subject: [PATCH] wifi: iwlwifi: stop peripheral polling when NIC access fails
To: linux-wireless@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When an AX211 loses power across s2idle, RX shutdown can poll an
inaccessible peripheral register during PCI resume. The register-read
helper returns 0x5a5a5a5a when NIC access fails, hiding the failure from
the polling loop. Each iteration can then incur another NIC-access
timeout, although only the polling delay is charged to the timeout
budget.

On a ThinkPad L14 Gen 3 running 7.2.8-9-omarchy, function-graph tracing
measured 7.91 seconds in iwl_poll_prph_bit() for the RX stop caller's
1000-us timeout. The surrounding PCI resume callback took 8.26 seconds,
leaving the desktop visibly frozen after opening the lid.

Acquire NIC access explicitly for each peripheral read and return
-ETIMEDOUT immediately when acquisition fails. Preserve the existing
acquire/read/release sequence, mask comparison, polling delay and retry
budget while register access succeeds. This also avoids treating the
failure placeholder as a matching register value.

With the equivalent change backported to the affected 7.2.8 driver,
the poll took 76.24 ms and PCI resume took 400.79 ms. Wake responsiveness
and Wi-Fi connectivity were confirmed on the affected machine.

Link: https://github.com/omacom/omarchy-pkgs/pull/1493
Signed-off-by: Jared Hooker <jaredroberthooker@gmail.com>
---
Submission notes:
- Rebased onto iwlwifi-next/next at 3627924ed81f, where the helper is
  named iwl_pcie_poll_prph_bit() in pcie/utils.c.
- Hardware testing used the equivalent iwl-io.c backport on
  7.2.8-9-omarchy with an Intel AX211 (8086:51f0), firmware
  89.d2579d43.0, and ThinkPad L14 Gen 3 BIOS R1XET52W (1.34).
- Before/after function-graph timings:
                          before          after
  peripheral poll     7,914,548 us      76,235.97 us
  RX stop             7,994,772 us     152,336.40 us
  PCI resume          8,257,866 us     400,792.70 us
- Six mocked-transport C regression cases pass against the actual
  adapted helper. The original helper fails the access-failure case.
- The affected driver module subtree builds against the installed
  7.2.8 headers, as does the updated pcie/utils.o from this upstream tree.
  A complete build/boot of iwlwifi-next has not been performed.
- checkpatch.pl reports zero errors and warnings.
- This fixes repeated polling after access failure; it does not establish
  why the device lost power or identify the original version regression.

 drivers/net/wireless/intel/iwlwifi/pcie/utils.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
index 8aa43e5..0962df4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
@@ -139,7 +139,16 @@ int iwl_pcie_poll_prph_bit(struct iwl_trans
*trans, u32 addr,
 	int t = 0;

 	do {
-		if ((iwl_trans_read_prph(trans, addr) & mask) == (bits & mask))
+		u32 val;
+
+		/* Do not retry register reads when the NIC is inaccessible. */
+		if (!iwl_trans_grab_nic_access(trans))
+			return -ETIMEDOUT;
+
+		val = iwl_trans_read_prph_no_grab(trans, addr);
+		iwl_trans_release_nic_access(trans);
+
+		if ((val & mask) == (bits & mask))
 			return 0;
 		udelay(IWL_PCIE_POLL_INTERVAL);
 		t += IWL_PCIE_POLL_INTERVAL;

base-commit: 3627924ed81fd7783394fb2555ea179c6606a231
-- 
2.56.0
