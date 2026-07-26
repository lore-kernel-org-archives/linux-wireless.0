Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488F352020
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093955; cv=none; b=cz1MQZXBWx9SW8xpyPtrXg8rpmvxwO6h5uoXmhPkc0BATHJXe8XcD+JOUNb1rM+DyJaHtJglZVRFt1pZ95Jl9shS8s8mvbptbUOm4UziI8yxlauxtgdJQFnj2eY2D/vGsZX0IuTZQb4Sq1tl6htmhKvpjs18u1p2/y4zThzFHpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093955; c=relaxed/simple;
	bh=76JWXwdJ8UUupISIOQJZSc9ghowhYAS2iqBJ1IssfPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mEZCoSQSyL2rMp0sA24V0jjhpLz9es+XAeyHgiMWkUsTiBySgA+9ZHlhtWvcKxGswjMislMDwuzLurKylAYeYxXgYvI3UZqp49vsNn9aMDJ71DzPaSi+toBBa6A3bylzLkyj0LRJJnBHlow2Xh2JFpYnBXUDP5XI9DgWS85/W3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ngh+0oNA; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ngh+0oNA"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2ceb096e675so23895965ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093953; x=1785698753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aQRSdU6GiunRTylMtdJjDeAsENSZJAWyer9Z3w+0XiQ=;
        b=mxTluwSedBU+/6af1Ra8uG5Qlsk7rSmcOzpw1UtCEt8LgNl9EhZ9A/WJsdZCyfWeGx
         a5Sd9v/gFcX0YGh8Mri0B/1tQ8ztYS8xpWcVivNNP+GghiwMLxd8oF5plgiwbIZB+4zR
         p81xxObLAK8TXaW3UJWSFTBNj6cQTFmjMcjXPjqwZWjaVaxPjiufE/fka3oGA0LsyQqa
         KfcjSQCp3hyARQAPg65Z8N9dmAfFOCg4DwirHiPPPr2nshKirPfHo7HpJQdWOnijKqjS
         FWPwCQIe+ndemM+iadHj5jIzVG2dpPszJve+CCC2Jo47IHctyOAkahktCfakxp9VxrSa
         4ZaA==
X-Gm-Message-State: AOJu0YyjuJIpC9QLp3l0EMzCT5n312uKky7TqKmVdYlrbdb3k1sO0w61
	D6FfxEYZnaCscjuNBIEp1xcU5CLnGhGb61ZbRPCV1hIIymvrVrA5viGHuxqt/P7S2ZCGuo1d6Bh
	lB2H4PlVtGLuEERsMxfVIRyl8tHJ0keBZ9JoW+rlx6UE6WcHU+JAQf0PGLmwLlpPOh5apDNVh/b
	DTvFMxSdb8G12lu9m3Ri9ZbJ8tsOgk9O+tU+S8vRNnAv8EHJVxVA3bEq5+f56C6jtEb3Jzv7GE3
	Nl/T4kkD50Xn+5au873EiZ4JjaB
X-Gm-Gg: AR+sD13MrvjTLtWqvLzscVJaLzoJpPCNoTkuW2PQrsz6vT11PozBeOWOiXsJp/Cl5LY
	c4NXB3kdLPnoK41MyXtFn1kTFXNKoFz3/uUOkPAcNnif2gAYBNvg94joQab8zjl81ag5vfRtwn7
	ourEboDmAVXABYz3Td5DpenvNt5QrE4tFBeEgb9Q/5Ld64vmIMlvisOC4jaw6ZuHRhaNJVixeGR
	pXTcHcSIdWWeWwndf2YjwYctr0ca1cSt++bW7u5f+BemgX3ArARoeH++C8Q6b39L7aQwZeis1md
	O7z709ZDOb6uUD8zDfG0XkaYkBs+Hg+IFmCEgrM0Bi1TvD7b5QHr/MNeH6PqkmQkiWxLD7BHAhb
	xJEpJGv+2KIkp+fpaqKcQAo3wJ3Eoo5cR58W6x0mSKluFcjXb9nkyLbGxaudKi5lrjS9+hAn94s
	eE4zzlCSz3BSuRNQnwXcTuDpqP8iQ2e2NdsBTr2I8=
X-Received: by 2002:a17:903:238b:b0:2cc:f7c6:834e with SMTP id d9443c01a7336-2cfde880ce9mr56345625ad.32.1785093953346;
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde78fffcsm5214155ad.33.2026.07.26.12.25.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so38414665ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093950; x=1785698750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aQRSdU6GiunRTylMtdJjDeAsENSZJAWyer9Z3w+0XiQ=;
        b=Ngh+0oNAAMqk7z2Y2jeAQa1tEnukoOIc1+oPiy6x9qsR0zWX9Ybwfmx6j8AXpR+92e
         qmQjZM3eaKWIwe1jfXdYS6XO5O1cpY7rjb5wHq1N+pPAdKq9gqKOsdmzn5Mefn2Wj5hL
         AO/ZqQS0LB3X+qBzxTM3GaNXszbgXR2WyFwHs=
X-Received: by 2002:a17:903:2342:b0:2cf:7f6b:8c8a with SMTP id d9443c01a7336-2cfde85f46cmr52310145ad.30.1785093949926;
        Sun, 26 Jul 2026 12:25:49 -0700 (PDT)
X-Received: by 2002:a17:903:2342:b0:2cf:7f6b:8c8a with SMTP id d9443c01a7336-2cfde85f46cmr52309945ad.30.1785093949449;
        Sun, 26 Jul 2026 12:25:49 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:25:48 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 00/10] wifi: cfg80211: consolidate cookie assignment for async ops
Date: Sun, 26 Jul 2026 21:25:31 +0200
Message-ID: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

NL80211_ATTR_COOKIE is a userspace-visible u64 that correlates an async
nl80211 operation with its completion event. Three cfg80211 ops currently
delegate cookie generation to the driver: remain_on_channel, mgmt_tx, and
probe_peer. This produces inconsistent strategies across drivers: some use
an incrementing counter, some use get_random_u32(), some use a CID cast to
u64, and brcmfmac's mgmt_tx always assigned zero - which is arguably broken
since cfg80211 treats zero as an invalid cookie.

The add_nan_func op already does this correctly: cfg80211 calls
cfg80211_assign_cookie() before invoking the driver, ensuring a unique
non-zero value without any driver involvement. This series applies the same
pattern to remain_on_channel, mgmt_tx, probe_peer, and tx_control_port.

Structure
---------

Patch 1 is the enabling change: cfg80211 pre-assigns the cookie in the
nl80211 command handlers before the rdev_* call. Drivers may still
overwrite the value at this point; subsequent patches remove the per-driver
generation. Patch 2 updates mac80211, which has its own internal cookie
counter (roc_cookie_counter) that becomes redundant. Patches 3-9 are
per-driver cleanups. Patch 10 finalises the interface by converting the
u64 *cookie output parameter to a u64 cookie input parameter, making the
direction of data flow explicit. tx_control_port is excluded from patch 10
because its cookie pointer is nullable (passed as NULL when dont_wait_for_ack
is set) and that nullable semantics cannot be expressed with a value.

Non-obvious aspects
-------------------

ath6kl (patch 3): when the destination STA is in power-save mode, ath6kl
queues the management frame in a software queue (struct ath6kl_mgmt_buff).
The cookie must survive enqueue and dequeue so that cfg80211_mgmt_tx_status()
is called with the correct value after the frame is eventually transmitted.
This means the cookie field is threaded through ath6kl_mgmt_powersave_ap()
and into the queue entry. The vif->last_roc_id and last_cancel_roc_id fields
are widened from u32 to u64 to hold the full 64-bit cookie.

Synchronous mgmt_tx (brcmfmac, wil6210): these drivers call
cfg80211_mgmt_tx_status() before the mgmt_tx callback returns. The status
event is therefore sent to userspace before the nl80211 command reply that
carries the cookie. Userspace must buffer the status event and match it
once the reply arrives. The pre-assigned cookie being consistent across both
the status event and the reply is what makes that correlation possible.
Previously brcmfmac passed cookie=0 to cfg80211_mgmt_tx_status(), which was
broken; this series fixes that as a side effect.

qtnfmac (patch 9): the qlink firmware protocol has no frame-TX-status event
type. qtnfmac never calls cfg80211_mgmt_tx_status(). The previous code
generated a random u32 short_cookie and sent it to firmware purely as a
debug identifier; it was never used for nl80211 cookie correlation. After
this series qtnfmac simply uses the pre-assigned cookie for the same debug
purpose and discards it. The absence of tx status reporting for the
wait_for_ack case is a pre-existing driver limitation not addressed here.

mac80211 0xffffffff removal (patch 2): the old code assigned *cookie =
0xffffffff for the dont_wait_for_ack + need_offchan case to ensure
roc->mgmt_tx_cookie was non-zero, which distinguishes a mgmt-tx ROC from a
regular remain-on-channel ROC internally. That dummy value is no longer
needed because cfg80211_assign_cookie() guarantees a non-zero result (it
warns and skips zero if the counter wraps). The cookie is still not sent to
userspace in the dont_wait_for_ack case.

Arend van Spriel (10):
  wifi: cfg80211: pre-assign cookie for remain_on_channel, mgmt_tx,
    probe_peer and tx_control_port
  wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
  wifi: ath6kl: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx
    and probe_peer
  wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: mwifiex: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: wilc1000: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and
    mgmt_tx
  wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
  wifi: cfg80211: convert cookie output to input parameter

 drivers/net/wireless/ath/ath6kl/cfg80211.c    | 22 ++++++---------
 drivers/net/wireless/ath/ath6kl/core.h        |  5 ++--
 drivers/net/wireless/ath/ath6kl/main.c        |  1 +
 drivers/net/wireless/ath/ath6kl/txrx.c        |  1 +
 drivers/net/wireless/ath/ath6kl/wmi.c         |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h         |  1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c   | 12 ++++-----
 drivers/net/wireless/ath/wil6210/p2p.c        |  6 ++---
 drivers/net/wireless/ath/wil6210/wil6210.h    |  4 +--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 12 ++++-----
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |  2 +-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    |  8 +++---
 .../broadcom/brcm80211/brcmfmac/p2p.c         | 10 +++----
 .../broadcom/brcm80211/brcmfmac/p2p.h         |  2 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 20 +++++++-------
 .../wireless/microchip/wilc1000/cfg80211.c    | 19 +++++--------
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   | 20 +++++++-------
 .../net/wireless/quantenna/qtnfmac/cfg80211.c |  4 +--
 include/net/cfg80211.h                        | 18 ++++++++-----
 net/mac80211/cfg.c                            | 18 ++-----------
 net/mac80211/ieee80211_i.h                    |  7 ++---
 net/mac80211/offchannel.c                     | 27 +++++++------------
 net/mac80211/tx.c                             |  4 +--
 net/wireless/core.h                           |  2 +-
 net/wireless/mlme.c                           |  2 +-
 net/wireless/nl80211.c                        | 11 +++++---
 net/wireless/rdev-ops.h                       | 12 ++++-----
 27 files changed, 105 insertions(+), 147 deletions(-)


base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
-- 
2.54.0

