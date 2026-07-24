Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F11B3B3BFA
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 20:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784925215; cv=none; b=cJH3iIPha9U+shD4YbvyqC7un0w6FFz1ea4f+/DzrOuI0ZVwD0QlpMp6JWEj5FcJGN+hwDOTvyD2Oc46cx0SKWM8MWMA4xxkDvUANTdLYYAQU4DjnFfP2qD+u2dWN6UiFDZMsBJrvPrHhN9tTdKryNxKi61o8aPQU+XOb9qYv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784925215; c=relaxed/simple;
	bh=Zk/sFfO0P3Zc5xIDecphI5VF2UB8/fuN2Q0noue8ons=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Awz4cHcDRoxhQJI/OEyh49UASvL3v6wXjq6ssP7hkovMbkJ7DII73HQRIC3GSDVxsEjcASighdhgsS0bDnOC49z9V9oWNyBaOajS/71+8xv2S0yxkct3Atsb900PSRKAAUg7UeWZT4FSsk7pK+fY79zuYqV+mXfPjpeKPuT9vEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhvCEONQ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhvCEONQ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cad8076b01so9766945ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784925214; x=1785530014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqO55og8W7BHslOf6Z0mSPTkO0lYXWtdruA0wlaytcE=;
        b=HhvCEONQHnbIk9gAobdXUbHrILlYRqwWyrmFpksA4NKb2I2Ypq+I3tLjDNNoTmMKTR
         zDqfbde5wRJYLSzH24C5kf1ehUGdPWFgDmDgYG/zx5f8o4IQIVXFevQ0zVePJERJDF4e
         DsMr+w9PoldTPeSjU2T3TekW6O8634sDOGHxbimEioNJvYufFK0yEDPy8vpYHwXCSPsR
         W4xLpD11E1rN0lXc6khhL5rYIG7ihddup/eSAC6lQ/iCGyx5jjii35WjKYNk6tISl53Q
         2kVCPpahTCFFEO/JAbZo25wQHFlXvNvg+BOML3MYprNjlzEr3O1KShEOET/oM6zPR7i9
         h1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784925214; x=1785530014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqO55og8W7BHslOf6Z0mSPTkO0lYXWtdruA0wlaytcE=;
        b=c2V3bmJwURiflNHUjBy2roWhBRyQTdlTvqt5kgihIVgR48uOOFKlh6U0HG8cwJENI6
         WnAZpeOOFOPz6FrtRH2r0wP2Izg9BcHiQ550C1Pa/UaSOmYcwXQhSPTqHzlPSR9Q2Y3w
         6OhDQdDZvKqx6z1WQtgPualGqPRopMAiTK9wa1FndJNgC3TLxEDXd7v0d0QTwrGOI5HV
         4tSWZMB/gQNoofDiIqLfUtJBlyNHRP4iobbt3tqXM6SUcPvdMjrDpk9WXnAkm1c5XQd8
         0DIQjDRl5s8Pzod616IoJjYaKL6oC19IJ3UITYjy8ITlSf2wNKdZZ/q1mpLbL82P7glf
         zOyw==
X-Forwarded-Encrypted: i=1; AHgh+RqtVy2yB7DjTvYuADgsGrsMAHykKE8NKvv4qMjgO4woM92vFJxYdKjKb3LBlCb75OxvOJAP4QEaf82vueyAaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ+8p1zXDau9WIMp9YQAXbH/dh0utWgIGrWgXd1+S2taIPDk0L
	L6oMcWzv3SBbmdgPgDfv0qqvUzPLETXi11laMZ/j8+xSBTjLSyG8x3xN
X-Gm-Gg: AR+sD13sE++KSTsPvYOsdaAUJ345RZAUKLUKSfi0/8iL4uIMuXWx763h5WuxBI+09P7
	t+/f1gttvkloGmDcSHZc4fBkJAKfCDQArJuyUyLwF3VYlAZuEumg+y6fMDcamuLi9Z+4sOmqCKA
	SKMe9B9Fg4ALKtWTfrCS2MOUmBFGKzbKOFZXTHKmWcP8jpTviuNEvKk0Tde+2A8zrRBvlG2HuPq
	nc0/fjjbG7s9343K1CMFAR7Y3JVGmedWrq54+wL1J60Qpb+ZGinSr1FITdXk4YInh+Otr+iLG6K
	9flmhlBJGVqSiXZQWUgc0bYsQUg6RqtTAbTHey6V0uMpRTFctWm19N3lNkscRPfd6BiaUafEQik
	lUDcThSRd/OEPxXTL18wL/QNEDpp2rr9uR2HAgFRkP7sksfCPv0UIC6x159hqSWBgbOdL4WbHew
	vcfGGzsSCOvuVkXLTxJAY5oJXX8+sBEwomGZdbIxPpkI4Xjz70QeE=
X-Received: by 2002:a17:90a:c890:b0:38e:dc4:3fbb with SMTP id 98e67ed59e1d1-38ec68982femr8118870a91.43.1784925213668;
        Fri, 24 Jul 2026 13:33:33 -0700 (PDT)
Received: from fabio-X870-EAGLE-WIFI7.. ([2804:1b3:a801:60b4:ddf8:a4ba:150b:5c93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm48918684c88.2.2026.07.24.13.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 13:33:32 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: johannes.berg@intel.com
Cc: briannorris@chromium.org,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	Fabio Estevam <festevam@nabladev.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: mwifiex: Detach sync cmd buffer on interrupted wait
Date: Fri, 24 Jul 2026 17:33:19 -0300
Message-ID: <20260724203320.78793-1-festevam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@nabladev.com>

mwifiex synchronous commands keep the caller-provided data buffer in
cmd_node->data_buf. Several callers pass stack-allocated objects there.

If wait_event_interruptible_timeout() is interrupted, the caller can
return and release that stack object while the firmware command is still
the current command. A late firmware response then reaches the normal
response handler, which can copy data through cmd_node->data_buf into the
stale stack address.

This fixes a stack corruption observed during repeated association and
disassociation cycles. The panic trace showed the command wait being
interrupted immediately before a bad pointer dereference:

  cmd_wait_q terminated: -512
  Unable to handle kernel paging request at virtual address 002c583837384662
  Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
  ...
  Tainted: [M]=MACHINE_CHECK

The fault address decodes as little-endian ASCII:

  0x002c583837384662 -> "bF878X,\0"

which is a fragment of the VERSION_EXT firmware string exposed as
debugfs "verext":

  w8997o-V4, RF878X, FP92, 16.92.21.p153.7

The same runs also showed corrupted control data containing:

  0x2400372e333531 -> "153.7\0$"

which is the tail of the same VERSION_EXT string. This points at a late
VERSION_EXT response writing through a stale stack-backed data_buf after
the interrupted wait returned.

After cancelling pending commands on an interrupted or timed-out wait,
detach the caller-owned data buffer from the still-current command. This
preserves the existing command cancellation behaviour while preventing a
late response from writing through a pointer whose lifetime ended with the
waiting caller.

Tested on an i.MX8MP board using an 88W8997.

Cc: stable@vger.kernel.org
Fixes: 3d026d09b28d ("mwifiex: cancel pending commands for signal")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 9460d5352b23..19196848778c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -57,6 +57,18 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
 		mwifiex_dbg(adapter, ERROR, "cmd_wait_q terminated: %d\n",
 			    status);
 		mwifiex_cancel_all_pending_cmd(adapter);
+
+		/* The command response path writes through cmd_node->data_buf.
+		 * On an interrupted wait, the caller can return and release a
+		 * stack-allocated data_buf before a late firmware response is
+		 * processed. Detach the caller-owned buffer from the current
+		 * command so a late response cannot corrupt freed stack memory.
+		 */
+		spin_lock_bh(&adapter->mwifiex_cmd_lock);
+		if (adapter->curr_cmd == cmd_queued)
+			adapter->curr_cmd->data_buf = NULL;
+		spin_unlock_bh(&adapter->mwifiex_cmd_lock);
+
 		return status;
 	}
 
-- 
2.43.0

