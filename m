Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872813A1A58
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547994; cv=none; b=QKowKr6Fvtl0jG8orREGPWiAJ8ktARWaOZ34sHv+IBtgtznmbAa/GzYQUzYBj6KpcRIa2VkPMSJd26sY1ZNjN8dJDUIoOWH5RCiKNvOrGAUPtH89HIjzuuXfjCxXLG/TER/M8VqyGgssFm2VSY5CLmFg1+xafPGWBVf7tcllmJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547994; c=relaxed/simple;
	bh=y2gGPJiatGzxbQVfdQeByTobg3OXQ4DC+xvDIE0EfeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nU81fQlIwqXxwIwas5Z7xyQgkfOl+dVkmF94uUHzsoHStF8uzu0ZwTL6FMyPE0n6/l6bOgdCVdPkzSMbIG+PK4Exe2u/27v4YWhQDOqDhcGxXy3fg0BVkl8vSl1EeNApa8hZtifnuVjUxaNtFETBGCnuSSTjHFKfWLoUtsLPOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPlxDXBE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPlxDXBE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso11654635e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547989; x=1789152789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BE4y4fN/tUoQAYLVgcEKGMivz/pT/xYPPBkli7XkLHY=;
        b=FPlxDXBETuA0sJVgSGf6ERYDJzJaoDkwDqK2YeThNw88xX5PH9SRN926hfVUyZfdmo
         V6XR30URej3fDGgOSxJNo/OZKyOTk/Yiv3m5aoDnznjD+cmM7YSvdeNE7wazW/d9l9wh
         NORUlnZJMrb/1ObhKcOPO+gPPmeriUshbCx5eus0+HPJw34ks9nH/2O8v/sClXzg7eOk
         RTimZZO/Q14bcjsCXTTlaVifu7CDgMDH65dM1/kgaoempqDX2N1HqLdFxYT4QhfcBn0U
         f7SUCkCiOsl7dmd1xEb13wsDirOk52uoXQVyb44PFvF3NuOvD+Y2RkRmAqQNuWQRkx98
         kITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547989; x=1789152789;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BE4y4fN/tUoQAYLVgcEKGMivz/pT/xYPPBkli7XkLHY=;
        b=jCEf7tuIACSKq9RIH9k1b9NpSZ8/uzRho8WDPnYmnQqi5cCh3C1mfaj8I8FAOTY6kX
         Z4rCaEA+Ul86IO+eOY851dFCp2hc46WKxffKyaSOhxkYwIIs6Esp5C2jzTKABKmdHvQz
         moMO9UF6PMGT12lK1o/zQCink5+uhc9JZbgUFxsFCx1K5Q1L5ivHJlcm9Vn5Asrf8M+m
         lA/mJnXsuOl0ZcYlBR/1gxcad1ZpGiV1elevAsDvYHzm8sfO8CPEKflNP6NUwww80d6o
         Dr3HAc5Z88yPECgfdKESTXG7Jrn1DgbGR2favIZA3Wss60R1fGTXyhBQrRr9/kqpz/dD
         ln8w==
X-Forwarded-Encrypted: i=1; AKwUvBzriNJC4hRqkQ4OfmIzogeqdhuez1H9t5EYKdlVC8HN4cYcZi7GvwmB2VFTe+VnzroXMpYeQE4EwrhK1rcSuA==@vger.kernel.org
X-Gm-Message-State: AFuF++ka/VR8i1rTt2yoa/WnVCuBXFdi9Gs2HSaaMSsnjSvKSG/uM7hA
	iN5iP80J2Z/Ik6eUJoRMcmp4H9OclU8Q1vm7fK8UoPC4w7LQ2OxKVhg=
X-Gm-Gg: AYBFou1TYbalnBSBNNVT9sHRqV8AmucKGR5956zJCjJzI368gOABzeHIXjuhsGdPf03
	PANQlbL9HCjyUt7DnOmdjwxfFPG9voSj+sgffFYMrF4vqCtcaUgFW+2dzxXd59/yLElaUsYLvN3
	X5wox/puSs5+LlCNdOaB4L75DLmmwrT75Mczrq9+YpHkDgGmjTPM+VqmKAxepzLddfaGbaq+nVt
	p1go8goiSxOGhre0VWSXUT6AX+/KENgPPGvhSrEDEXwEqeBV4Pl+3xShFpoNDdoZtYb4vyIYbke
	WDUHA+88PBEQ9tQM6Cec7FSP0b3Re82/d55ApilgNzf0W10gXbsJZ3D9o9YizOxy7SDGByEaYs9
	+A6V8BArujyONCDT7S3jLGq0LvuTqRlwa4Yf1pL61mzpL4sKaa9A/06KlyPLyFa7gnR8I37c2qF
	xShQZzg80bc8KPw49QA0HcS0tgIRjG/7/D1eEGCuw2FZ+f8ONHvhbWJRP4MDCJL2MZF9xZPL4zl
	2vgqeTE1LuEfgcJOFv7vzJkxAD0SR0qbpR+SboPris+e6PJcfmqgyROdgfRcnN8JLf3DDr1V5bU
	3UIq
X-Received: by 2002:a05:600c:3495:b0:49c:dadb:18a7 with SMTP id 5b1f17b1804b1-49cf8244260mr76754985e9.10.1788547989212;
        Fri, 04 Sep 2026 11:53:09 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:08 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] wifi: ath9k: cut USB round trips on channel changes
Date: Fri,  4 Sep 2026 21:52:48 +0300
Message-ID: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On the ath9k_htc devices every register access is a synchronous WMI
round trip, so a channel change that is cheap on PCI costs tens of
milliseconds over USB. This series removes round trips from that path
without changing the register values written.

Patch 1 is a fix: a multi-read that fails over USB hands the caller
uninitialised stack data; make it return all ones like a single read.
Patch 2 gives the 8-register limit of REG_READ_MULTI() a name and
checks it. Patch 3 replaces the per-queue ath9k_hw_numtxpending() loop
in ath9k_hw_channel_change() with two multi-reads and needs patch 1 so
that a failed read still counts as pending. Patch 4 wraps the
read-modify-write runs in ar5008_hw_set_delta_slope() and
ath9k_hw_start_nfcal() in the RMW buffer. Patch 5 skips the departing
channel's noise floor readout on a fast channel change over USB.

Patches 3 and 4 touch code that PCI runs too, but there the multi-read
is a loop of single reads and the RMW buffer callbacks are not
installed, so the register traffic is unchanged. Patch 5 is limited to
ATH_USB.

Measured on an AR9271 (0cf3:9271) with a local counter of WMI commands
around the driver's channel change:

                                   WMI commands     time
  full reset, unpatched                     182   ~92 ms
  fast channel change, patches 1-5           44   ~31 ms

The second row also depends on two changes outside this series: taking
the fast path on same-band retunes, which mainline does only for
off-channel scan hops, and the mac80211 change that makes a monitor
retune one driver channel change instead of two [1]. On mainline the
reduction therefore shows up on scan hops.

Two further patches that skipped the PCU re-initialisation and the
WMI_SET_MODE on a fast change were dropped before v1: the receiver
stopped delivering frames, because ath9k_host_rx_init() is what clears
AR_DIAG_RX_DIS and AR_DIAG_RX_ABORT. With patches 1-5 the fast path
delivered 90-97% of frames injected from a second AR9271 over coax on
the 2.4 GHz channels, against 95-97% for a full reset on the same
build. The spread is run-to-run drift of the rig; the fast path shows
it first because it does not recalibrate, which is also why mainline
limits that path to scan hops.

[1] https://lore.kernel.org/linux-wireless/20260904032235.355479-1-nerijus.bendziunas@gmail.com/

Changes in v3:
- Move the fail-safe multi-read fix to the front of the series and Cc
  stable, so it can be picked on its own.
- Patch 2: report an over-long multi-read as failed (all ones) instead
  of returning with the buffer untouched; comment reworded.
- Patch 3: kernel-doc for ath9k_hw_first_txpending().
- Add Assisted-by, rewrite the commit messages, rebase onto ath-next.

Changes in v2:
- New fail-safe multi-read patch: ath9k_multi_regread() copies an
  uninitialised buffer out when the command fails. In v1 that made the
  queue check random on a timeout; it also affects the ANI, EEPROM and
  register array callers, so it is fixed separately with a Fixes tag.
- Queue check: comment on why a failed read is safe.
- Other patches unchanged.

Nerijus Bendžiūnas (5):
  wifi: ath9k_htc: report a failed multi-read as all ones
  wifi: ath9k: name the register multi-read limit
  wifi: ath9k: check all tx queues with one multi-read
  wifi: ath9k: batch the read-modify-writes of a channel change
  wifi: ath9k: skip the old channel's noise floor on USB fast changes

 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |  2 +
 drivers/net/wireless/ath/ath9k/calib.c        |  2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 12 +++++-
 drivers/net/wireless/ath/ath9k/hw.c           | 21 ++++++----
 drivers/net/wireless/ath/ath9k/hw.h           |  7 ++++
 drivers/net/wireless/ath/ath9k/mac.c          | 40 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h          |  1 +
 7 files changed, 75 insertions(+), 10 deletions(-)


base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0

