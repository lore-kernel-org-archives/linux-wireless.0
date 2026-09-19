Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7F8379C2A;
	Sat, 19 Sep 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850645; cv=none; b=dzKXKNmWOeP+FVK8CS2wwNDrWksTOnL5AudFHp28sI86qvHdTGyxjq2nTb7/7iINJ6kR8SrCHietAVdBDMrm1u4ttKCbB4LWYscvUZoW+ianj1yNO0rPmC5o5Due4ldsNeMyc8RQdqMLzCiOTwGR2HhCGOEbKU2lCFZvtGm3o0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850645; c=relaxed/simple;
	bh=d3AcLn4a9qFXJlJjzccqYgcSQqR+1GNbo3HUaZ6Dgyc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JqvyAGquQZbhd+uCJQnqzWHRitK7ZB0k0zj/EfxpO+a/riSu/IL2UIR6SN7yyqNYL5cg07X1EY5/DGzw0nfv5DhEbzr8t6Lp/dzBeFdxK0SKQtGVJa3NJ7LfJDJTPOFTn+gLpyLrLrosU9KzWCR9pEfjMWQsMsxp7UXVRWHQtVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTyTMIZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTyTMIZo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC7CEC2BCB9;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789850644;
	bh=d3AcLn4a9qFXJlJjzccqYgcSQqR+1GNbo3HUaZ6Dgyc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=dTyTMIZoHr4JA9ZqlDEyG5opg1kRIwENbtlh6Ln26q/k9Ii2C5lv8EWXG6WKOeGF3
	 VnW+BoNhOPJruijHBEiPddTMclO/2epA3s5fP477GMeZfleYz/8JgLaoA0d5exSTSU
	 pbiRQ3pdxN9ITTibRT+4L1UUopehnDhObYjAnVNeBlwt7E2JY+nel5kd7PZH6ab9C1
	 L0OUljqvnq1/CyARdooit1A1DOj30yJvMWIfVOJb4x6JBzTt9W0jo8nvv58yYbJkme
	 iy2SE9rFPXG6e8TXcZU7XK/7LyEy+VV+F3a8SJFoUUNaiiZ8H+FdnnID5Tym4EFaka
	 DueS2dmrdqYVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E40C982D7;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Subject: [PATCH rtw-next v3 0/3] wifi: rtl8xxxu: keep RX requests available
 across transient errors
Date: Sun, 20 Sep 2026 05:44:03 +0900
Message-Id: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWMTQrCMBCFr1Jm7UCaSqFeRVwk6WhHNJXJtAZK7
 26i+Hbf+9sgkTAlODUbCK2ceI4FukMDYXLxRshjYbDG9mawBsM8UkbRB0rGtcO0+Ccrtv5Irh9
 sWwRl/BK6cv4en0H0jZGywuWXlM2dgtbf2vUuEXpxMUzV+rex+rDvH22yDfOkAAAA
X-Change-ID: 20260920-codex-rtl-rx-v3-submit-1b4ea6921111
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, kvalo@kernel.org, linux-kernel@vger.kernel.org, 
 Jes.Sorensen@gmail.com
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789850643; l=3892;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=d3AcLn4a9qFXJlJjzccqYgcSQqR+1GNbo3HUaZ6Dgyc=;
 b=PVDobP5412hrNvkdROl4fhz7cddNWT6/pJNIsO6Hgy8yahYI2/XJT7sZQNi+reDOAJoWAUTs2
 fgoBmASBR3UDpoq7TO6RmEd/Gmv5rpAX6q18sjXn+ZnArcQQLwK1Opn
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: Kim Wooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

rtl8xxxu keeps 32 RX URBs in circulation. Completed requests wait on a
pending list until more than eight are ready to be submitted again.
Completion errors free their URBs, however, so a finite run of errors
can leave too few requests to reach that threshold. At that point,
reception can stay stopped even after the errors end.

This series fixes that loss of RX requests, along with two problems in
the submission and startup paths: a failed submission can leak its skb,
and a failed start can leave earlier requests active or report success
after only part of the pool was allocated.

In v3, normal completions and recoverable failures return requests to
one pending list, serviced by one delayed work item. An error queues a
100 ms retry. When a normal completion takes the pending count above
eight, mod_delayed_work(..., 0) brings the work forward. ENOMEM/EAGAIN
during submission uses the same retry path.

The delay limits repeated retries when normal reception is not
progressing; it is not a minimum wait for each URB. During stop, the RX
lock prevents new reservations once shutdown is set. Stop then cancels
the delayed work before draining active and pending requests.

Changes since v2:
- Keep patch 1's code unchanged and retain Ping-Ke's Reviewed-by.
- Share the startup and worker submission loop, preserving their
  different handling of fatal errors.
- Replace the separate retry list and worker with one pending list
  and one delayed work item; normal completions can advance a retry.
- Remove the shutdown initialization added in probe.
- Drop the KUnit patch and its test-only hooks from this series.
- Use the confirmed author name and verify the Fixes references.

I built the driver at baseline and after each patch with W=1 under ARM64
allmodconfig and allyesconfig. Both full kernel builds also passed, and
the baseline/final sparse comparisons produced no new diagnostics.

The hardware tests used an RTL8192EU USB adapter on a Raspberry Pi. I
adapted the RX changes to the Pi's existing Linux 6.18.46 RT kernel to
run them on the device. V3 passed 52 tests covering allocation and
submission failures, all six completion errors, repeated failures,
scheduling, stop and normal RX/down-up. Two interrupt-URB tests were not
run because this device does not use that path.

Nine of the passing tests failed the first start after a fresh module
load, at the first, middle or last TX/RX allocation or fatal RX
submission. Each began with no previous start, cleaned up after the
injected failure, and received packets after the next start.

For the same 24 injected EPROTO completions in a 32-URB pool, the
unpatched driver stopped with eight pending requests and none in flight.
V3 kept all 32 and received 1,225 packets over 30 seconds without
restarting the interface.

The fault-injection changes are kept outside the series and exercise the
actual allocation, submission, completion, worker and stop paths.

v2: https://lore.kernel.org/linux-wireless/20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr/

Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>

---
Kim Wooseok (3):
      wifi: rtl8xxxu: free RX skb when URB submission fails
      wifi: rtl8xxxu: unwind incomplete receive startup
      wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

 drivers/net/wireless/realtek/rtl8xxxu/core.c     | 153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   2 +-
 2 files changed, 86 insertions(+), 69 deletions(-)
---
base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
change-id: 20260920-codex-rtl-rx-v3-submit-1b4ea6921111

Best regards,
--  
Kim Wooseok <5mghybrid@khu.ac.kr>


