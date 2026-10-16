Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9D23AA1B2
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124756; cv=none; b=V3rnO8ZNs7bc+uQX38jJw7X2RklzkNYGRJeYQ61aJpBujtsAQLKsvtk35DzwR7NBFk/I17ZqEc3/QfSmBOeiOfCZrFsY+AafR0F6j7x8siladHc5Dy74Is8yVKYWEYpa5Wl7krwx9tev6sSDA+9CPLQ5nFt344Dg1/EhB/kp7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124756; c=relaxed/simple;
	bh=DHeNoO/T/AedM5+MDKeWnkgv51M5pAI0hBkOhLePtRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A0J0sO16Po1ya7uX+LK9p0fDvTQAU/t0Q4PpAdW2dahvpgtXMUCvCTFn7j5DMuRSZwJ5UtR1gHLHQW8sTCH3I2lIYYqK8skI/JXbR+g0HVVNnGhVgthPhvLCV7tpN6vlfx8xxfbZjoLY2DnO9igdUwPNsZVHKlA2GGZSKDIlobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=DfysOqb6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="DfysOqb6"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e812e2b31bso35037305ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 21:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792124753; x=1792729553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HHVH+QuSmPSNDBRz9CAlQPe0vcztVPFNpVzUOQzNMfE=;
        b=DfysOqb6lJWHTQ3/O3d3aYvH7U8C6fgbBiM6i2e5QPliew2YhzgiOx4PdKuGsRlwuX
         JeN2W1hqLa6nmwM8qgM7gWQAkIz24z9bYu7z+Z6Dyg7Cr4rPUDolnfeMKPS16+e7/33M
         1zga/0Jqb5Z3Fu5iu5zYSD+fesOcXa4PdeC5KnipbYW4dNMxHjYknWeVRBRNYSlTbLMj
         OwsgZOBXutfv8spd9fUgSzWC8OE3pYib0sljvXVixScJEqlQVJ2Pg9t3EacWGtJibYa0
         WBem/1fq5DVVSf+7LxRGtzb7X9IW8Xhk2OWQH70STLWuuI/gY5JH8SOcHEEv2eKuJsag
         6Lrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792124753; x=1792729553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HHVH+QuSmPSNDBRz9CAlQPe0vcztVPFNpVzUOQzNMfE=;
        b=M5SzYwcybeq7CYBAwWNZzJRU3C7aoUVGeeShGLZL715gFLZRK0F7DMortCEYeaCwMF
         of3ZgBaPyD4Sq+fRVfmq9wEdw2SXKiAH0iyjx2dW/Huekr3Sq6L1Mz/vt5BSfylVGBBv
         HeZcGzDTlZjfK3lfZo4/mXi0X/zCEWoZFoZptkXHgKKIahucT0HOHyFQN/tIhMBVGWVD
         qXWfoGoeTZOFXR8yYswOD3A6/yzswgjZER4HupDAuxDcvxvCj9OZ+Q7qaNsFhBZP55wg
         3LL3i9jwbPI4/+mBlt/KVX3eShVL8exs+yfHHTLcPHa/+fJ7JekpC7B9m7DXJBW/VRjf
         GG5A==
X-Gm-Message-State: AFq9FYLM7dnPKqIvsXxlmKWfVoBdhgY3wn5ypjKV9aKal2xatTwJPfgm
	yxu+m+ZAaaEGOX1R+TfNwJ7jfRnhYCsnoGxXlcJ+go9NFnfw+SOMttSUOUAujQA1tks=
X-Gm-Gg: AYBFou0VApXnAqAeq6E15fySyY7Dt3APbIwTiTO8V2WwSOWDc1VuiSkDPk6lMdpV/Sl
	5lzvSOLD1HKaxf4QhENSpdsmCx14JVGQLa4PGIGVGh62GXuBZTjZvl+QXSMNZOvYmVnIxq6rteJ
	qqCdZ+Mu8hnM6t0Y6jSkzzD+l38ph03KyWPYBLz9HntjSXeR+7u2lqXLTJcWqt658nuF93MvpYf
	cgVIxNTjt9IIsXTFuTlrHDYirGKduq9dRjKvy9YXOiv+ySfR99XV3DNuH5IIO8btworjcHxrnmb
	eiymA4Y/WZPE1N9N6mf1aenDxVDVfbU6U1S/T/uTslMt1hMqvITdlDdSbK+7QSYwC9/WQX/xggm
	PiTprMy+fZyhQ/+4Xan9aJY+uiXsahjCjy6OJos/g0expJ9NH9eUm1pZnfNw0dgmXbMHp3fXW4t
	bZGnsrKV+u3khI5xjNRGI/k8sM/BIkYFviX7f63UKDzCXRkxip89AlFKxSK+3IPJjXirC0lOHQ0
	gOZ19/jpc+VS/ST9A==
X-Received: by 2002:a17:903:1965:b0:2e9:87a1:98b5 with SMTP id d9443c01a7336-2e987a19c92mr7925075ad.14.1792124752750;
        Thu, 15 Oct 2026 21:25:52 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6549b761bsm424443a12.15.2026.10.15.21.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:25:52 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/3] wifi: nxpwifi: fix the 11AX_CFG response handler
Date: Fri, 16 Oct 2026 13:25:39 +0900
Message-ID: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes both

  [PATCH] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
  <20261016014927.434473-1-yhlee@isslab.korea.ac.kr>

  [PATCH v2 0/2] wifi: nxpwifi: bound the 11AX_CFG response handler
  <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>

which should both be dropped.

Review of v2 found a second defect in the same function: the parser reads
a TLV's extension ID one byte past where it is, so v3 is three patches
and the order matters.

 1  nxpwifi_wait_queue_complete() detaches data_buf when a synchronous
    command is interrupted. nxpwifi_process_cmdresp() hands the field to
    the response handler as it finds it, and all three handlers in 11ax.c
    store through it without looking. Commit 068986fd6f2a5 ("wifi:
    nxpwifi: detach sync command buffer on interrupted wait"), which
    introduced the detached state, swept the handlers in sta_cmd.c but not
    these.
 2  the extension ID is the first payload byte of a TLV, which is what
    the send side of this command writes and what every struct in the
    driver says, but the response parser reads the byte after it. The
    HE-capability test is made on the wrong byte, the copy lands one byte
    off, and it reads one byte past the payload the response declared.
 3  the TLV walk takes its length from the response and bounds neither
    the walk nor the two copies, so a short response wraps the u16 length
    and an oversized header->len runs past both destinations. This is v2's
    patch 2, unchanged, rebased.

Patch 1 has to come before patch 2. On the base the extension ID is read
at the wrong offset, so a correctly formatted capability TLV is never
recognised and the unguarded store is never reached; correcting the
offset is what makes it reachable. Measured, not assumed -- see below.

The driver has not appeared in a released kernel, so no patch has a
stable tag.

Still open, and not addressed here
==================================

Patch 1 closes one of two windows, and I would rather say so than let it
look like a fix for the race.

When a synchronous command's wait is interrupted,
nxpwifi_cancel_all_pending_cmd() keeps the current command on purpose --
"no recycle probably wait for response" -- and the caller returns, which
ends the lifetime of a stack-allocated data_buf.
nxpwifi_wait_queue_complete() then clears the field under
nxpwifi_cmd_lock. But nxpwifi_process_cmdresp() reads it without that
lock:

	if (adapter->curr_cmd->cmd_resp) {
		void *data_buf = adapter->curr_cmd->data_buf;

		ret = adapter->curr_cmd->cmd_resp(priv, resp,
						  cmdresp_no,
						  data_buf);
	}

and calls the handler outside it. So the clear only helps if the response
path reads the field after it. If the response path read it first, it is
already holding a valid pointer in a local, the clear changes nothing,
and the waiter returns and reuses the frame while the handler is writing
through it. A NULL check in the handler, here or in the
three handlers that commit covered, cannot see that case.

mwifiex is in the same position. Its detachment, commit ef06882c7d8a
("wifi: mwifiex: Detach sync cmd buffer on interrupted wait"), is marked
for stable and was motivated by an observed stack-protector panic, and
mwifiex_process_sta_cmdresp() reads the field the same way:

	void *data_buf = adapter->curr_cmd->data_buf;

I looked at the contained fixes and none of them works:

  - reading data_buf under nxpwifi_cmd_lock only orders the read. The
    handler still runs outside the lock and the frame can still go away
    under it.
  - holding nxpwifi_cmd_lock across the handler call is not possible.
    nxpwifi_ret_sta_802_11_scan() reaches nxpwifi_scan_networks(), which
    calls nxpwifi_wait_queue_complete() directly -- that would take the
    same spinlock again -- and allocates with GFP_KERNEL on the way;
    nxpwifi_ret_sta_11n_delba() and the two addba handlers reach
    flush_workqueue() in nxpwifi_del_rx_reorder_entry(); and
    nxpwifi_ret_sta_802_11_deauthenticate() reaches
    cfg80211_disconnected(..., GFP_KERNEL).
  - recycling the current command on an interrupted wait drops the
    pointer, but it also puts the node back on cmd_free_q while a
    response is still in flight, which is what the comment above is
    guarding against. nxpwifi_cancel_pending_ioctl() does recycle it and
    says it is only safe there "because only cmd_timeout calls this path
    and no response is expected at that point". The curr_cmd test at the
    top of nxpwifi_process_cmdresp() is itself unlocked, so a recycle
    races the node as well as the buffer.
  - giving the callers a buffer that outlives them works, but 27 of the
    71 synchronous nxpwifi_send_cmd() call sites pass the address of a
    local, so doing it for 11ax alone fixes two of them.

That leaves the lifetime contract between a cancelled command and a late
response, which is the command-completion core rather than this driver's
11ax code, and mwifiex would want the same change. I am not sending a
patch for it; I would rather it be looked at by the people who own that
code than guessed at by me.

Testing
=======

I have no IW61x hardware. Everything below is a KUnit harness injecting a
fabricated command response into nxpwifi_ret_11ax_cfg() on a KASAN
kernel, with the TLVs laid down in the wire format the send side of this
command produces. It says nothing about what the firmware emits. Each
case ran in its own boot so that each KASAN report belongs to one case.

Three arms, base 2f2f7eeef8b0a:

  A0  base
  A2  base + patches 1 and 2
  B   base + patches 1, 2 and 3

A correctly formatted capability TLV, extension ID at payload[0], 25
bytes:

  A0  not recognised: he_cap.len 0, user_he_cap_len 0
  A2  recognised: he_cap.len 25, he_cap.ext_id 35, user_he_cap_len 29,
      and all 25 payload bytes plus the 4 header bytes byte for byte
  B   same as A2

A zero-length extension TLV followed by another header:

  A0  accepted, he_cap.id 0x00ff and user_he_cap_len 4, from a byte that
      belongs to the next TLV's type
  A2  skipped
  B   skipped

Lengths that reach past the destinations, and the two walk cases:

  A2  5 of 10 cases report, each one its own boot: a 60-byte and a
      120-byte copy 6 bytes into the 56-byte struct nxpwifi_11ax_he_cfg
      on the slab and on the stack, and two reads past the response
      buffer from the wrapped and the over-long walk
  B   0 reports, 10 of 10 cases pass, including a TLV that fills both
      destinations exactly

Patch 1's case is only run on the arms that have it: with data_buf NULL
it returns 0 and writes nothing. The unguarded store is not run, because
it would take the test kernel down; on the base it is not reached at all,
for the reason in the note above patch 1.

v2 -> v3:
- new patch 2: the extension ID offset, and require a payload before
  reading one out of it.
- patch 1 covers nxpwifi_ret_twt_cfg() and nxpwifi_ret_11ax_cmd() as well,
  not just nxpwifi_ret_11ax_cfg(), and returns 0 rather than -EINVAL, to
  match the three handlers the detachment commit already covered.
- patch 3 is v2's patch 2 with no change, rebased.
- the cover letter says what patch 1 does not fix.

v1 -> v2:
- new patch: reject a NULL command buffer before using it.
- the bounds patch unchanged, rebased onto it.

Yehyeong Lee (3):
  wifi: nxpwifi: guard the 11ax response handlers against a detached
    command buffer
  wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
  wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response

 drivers/net/wireless/nxp/nxpwifi/11ax.c | 38 +++++++++++++++++++++----
 1 file changed, 32 insertions(+), 6 deletions(-)


base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0

