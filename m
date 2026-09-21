Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67B44F553;
	Mon, 21 Sep 2026 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977592; cv=none; b=hP0uyiAKeUXrLgxRWTPp3Q29p6TVbw9YBds3dzKObyPZd9+AgzQ7A+2SflMs9dc07aiohTBrKmS5OJKD9coUOyiGNv9NplwsLf3k4jWN0xxKDPA8cUqDwYW8JDDIuoWsr7JhNVC4zedLHoUUF9+HP/r1t+2f0iiyB/3ndgv0Ses=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977592; c=relaxed/simple;
	bh=SmvhrJEU24sW5LU8DytMNLC3sHmZyGqZmfauFRtK3ng=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JboRFWkYseZtE138/V3g9rDfkSm3mXjazqJLiQ1Neif/oJTRnAjlkdn7o3JasXZwMkCSF0wHcVXgDu2N7wki2czu4Kb3RSCFAQMSdlm2S+lGG6ygkX3CwborbEwrVvPM56tDBsEI5zum6GqoD3frh7DMjt97wHoG7sexx4soTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGQnCm61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGQnCm61"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCA58C2BCFA;
	Mon, 21 Sep 2026 07:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789977591;
	bh=SmvhrJEU24sW5LU8DytMNLC3sHmZyGqZmfauFRtK3ng=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=QGQnCm61dgAVXwQIpNp+lsRzjn4B8gTWeaQhAaugxbJ2ihp26vHQ8c3K8q6oBTiw0
	 fPAZIaSJfJSb01Vbnia3zd5ksopSsrqN1m5EpHhhZT9jv3Thk+i4hA319FdxcN3UVg
	 ylvKmJ0EhRSAB1muiKzVk4SMsUtGnCyL9GxxXjTYVTTQVfQcuU/spTcG/tPb/gDkH+
	 5fEf+XafoJxm76azApq/ty+482QXlELYGTg93wng1oH9npszRkt9J3xkHtxG9ILOhC
	 YenFAb1TjonV5k+NZRvPcq0ZyTv+ppANgO9kYXYXbX+cne7QAVztGXaf2XdU7qpJnF
	 9WgaCQ1ibee/Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9294C982EE;
	Mon, 21 Sep 2026 07:59:51 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Subject: [PATCH rtw-next v4 0/3] wifi: rtl8xxxu: keep RX requests available
 across transient errors
Date: Mon, 21 Sep 2026 16:59:48 +0900
Message-Id: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4VOSw6CMBC9ipm1QyhFAq68h2FRyigVLWZaEEO4u
 y3GtbOa981bwBEbcnDcLcA0GWcGG0C+34HulL0SmjZgyNKsSKssRT20NCP7O/KMk0Q3Ng/jUTQ
 5qaLKRDgI4SfTxcxb8RnYv9DS7KH+KiFzI+1jb/Q2yhE2rKzuIvVzY+Sj3hnnB35vGye5Nf6bE
 74Uy1K2QsiDqAp56rsxUTrpGep1XT8V2yEZ+AAAAA==
X-Change-ID: 20260920-codex-rtl-rx-v3-submit-1b4ea6921111
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 linux-kernel@vger.kernel.org, Kim Wooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789977589; l=2887;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=SmvhrJEU24sW5LU8DytMNLC3sHmZyGqZmfauFRtK3ng=;
 b=zQIRZTigf6m5OBJGnNqPeiVrjGcO35JlN7AJ61tmmv+u+IZrwsHTUYP+5UrCb2gWzQGGySH73
 NPPslW8JH/AAd7rQ1l84s8AMteA49CkH2ar4lFNxyF+xM9iQPEwHGYa
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: Kim Wooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

rtl8xxxu keeps 32 RX URBs in circulation. Completed requests wait on a
pending list until more than eight are ready for resubmission. Completion
errors free their URBs, so a finite run of errors can leave too few
requests to reach that threshold. Reception can then remain stopped
after the errors end.

This series preserves those requests across recoverable errors. It also
fixes an skb leak after failed submission and startup error paths that
leave requests active or report success after only part of the pool was
allocated.

Normal completions and recoverable failures use one pending list and
one delayed work item. Errors schedule a retry with a 100 ms delay.
When a normal completion takes the pending count above eight,
mod_delayed_work(..., 0) brings the work forward. The delay limits
repeated retries when normal reception is not progressing; it is not a
minimum wait for each URB. ENOMEM/EAGAIN during submission uses the same
retry path.

I designed the v3 tests around the error paths changed by this series
and exercised them on an RTL8192EU with the RX changes backported to the
Pi's 6.18.46 RT kernel. I checked resource cleanup and reception after
recovery and restart.

With the same 24 injected EPROTO completions, the unpatched driver
stopped with eight pending URBs and none in flight. V3 retained all 32
and received 1,225 packets in 30 seconds without restarting the
interface.

For the changes in v4, I rebuilt the driver with W=1 after patches 2
and 3 using the existing ARM64 build configuration. Both builds passed
without warnings. All three patches pass strict checkpatch and apply
in order to the base commit.

Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>

---
Changes in v4:
- Leave patch 1 unchanged and add Ping-Ke's Reviewed-by to patch 2.
- Initialize the RX worker's priv pointer at declaration and add the
  requested blank lines.
- Rename the queue helper's retry argument to defer_schedule.
- Use schedule_delayed_work() for delayed retries. Keep
  mod_delayed_work() to advance pending work on normal completions,
  using system_percpu_wq instead of system_wq.
- Link to v3: https://lore.kernel.org/linux-wireless/20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr/

---
Kim Wooseok (3):
      wifi: rtl8xxxu: free RX skb when URB submission fails
      wifi: rtl8xxxu: unwind incomplete receive startup
      wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

 drivers/net/wireless/realtek/rtl8xxxu/core.c     | 154 +++++++++++++----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   2 +-
 2 files changed, 87 insertions(+), 69 deletions(-)
---
base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
change-id: 20260920-codex-rtl-rx-v3-submit-1b4ea6921111

Best regards,
--  
Kim Wooseok <5mghybrid@khu.ac.kr>


