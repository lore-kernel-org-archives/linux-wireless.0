Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5C37EFE4;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789284812; cv=none; b=fFg94CGpX9sw49AkM9Z8+n+94+BM35cFHS+utJvw8LYILsew2aHtXoMs0XMesdDJGx8YEuOjcrqQ3ayCpgoAwR9UmkwFOZRCuBN9EsvrtY/qibETNvKVT08xv/wLeyH5zbue66DDsMLfyLJ8H2mWu6y24ZLZSX73tVA5VsDdehg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789284812; c=relaxed/simple;
	bh=RBuppGYN9JIqPwxc9VsY+/5iSz70Aght3JSaf+MDnwc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=q/hpsfHD2x5jeasHEYN4G53d0/pQmy9+6Na+7uHczZi+pc+tXwcmjZxUi4JysB7jwDydXgMGBR2SgWL0b40Kqn9H5p+iXgwDM8dufTh1DD1VHMv2r6sDy02TfwHdrBMT/Xqj+ZWWmkuj2lJ1to8HusLkavpLGQTcRiL+eBJYNww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RP7gj4Uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RP7gj4Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CDBEC2BCC7;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789284812;
	bh=RBuppGYN9JIqPwxc9VsY+/5iSz70Aght3JSaf+MDnwc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=RP7gj4UhlZDcBG0VjwWtzZnu6KWaeM8BqWIT02XYuiM1cUGTnAqLaEglsKetXxz/F
	 dFAwWgqwQQXYjAxgaPcXJF+0m4b4TQMBIjc3mGxhzFVfBOnX2azfG6CyRu0Ma6uIt0
	 OJtIKIPCI71EH2YBumYC+0z5YnGlK2YHJHiV9z77wKv6JkaoFoS2pwgsl+B1xysB9D
	 +MfIuBa9lH6/m6Y7r3DKOKXaWzFF//xQdUClAnk7jEqZBJthEfV1yt6VITzLTEVyoD
	 kLkjAnsM7HT0aSPeJ0ZDqtcrWhqtrY1obXYRxeSE4AmYn7dCETRpI5BPg3viqpQOIk
	 dYHhe/y3NxOpA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF8AC88E5C;
	Sun, 13 Sep 2026 07:33:31 +0000 (UTC)
From: kimwooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Subject: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests available
 across transient errors
Date: Sun, 13 Sep 2026 16:33:18 +0900
Message-Id: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL9RpmoC/yWMSw7CMAwFr1K9NZZSV+J3FcQCEgfMIkVOWiJVv
 TspLEfvzSzIYioZ526ByaxZx9SAdx3885YeQhoagx3v3akfyI9BKln5kFWamWL03LvD4I4holl
 vk6j1V7xguyWpBdf/kqf7S3zZgljXL4SBtZd9AAAA
X-Change-ID: 20260913-codex-rtw-rx-v2-ffc2107308df
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, linux-kernel@vger.kernel.org, 
 kimwooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789284810; l=3885;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=RBuppGYN9JIqPwxc9VsY+/5iSz70Aght3JSaf+MDnwc=;
 b=wN/1ZeL/quUqGmF/Fqh8k21cHqwzvXRcDfpHOfSnAvGcSlSNA5oaL16DLhkISE7D5iNr41D83
 r8ei9ZEwK1PDtHBABWsBO2wABWEL44oRn9yfdxVe4vusBBUnYD1nY7t
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: kimwooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

rtl8xxxu maintains a pool of 32 RX URBs. Successful completions return
their URBs to a pending list and schedule the RX worker when more than
eight URBs are waiting. The worker allocates fresh receive buffers and
resubmits the queued URBs in a batch.

Completion errors free the affected URBs, reducing the pool. Once eight
or fewer survive, their completions can leave all remaining requests on
the pending list without reaching the worker scheduling threshold. If no
request is in flight and no worker is pending or running, nothing triggers
further submissions, so RX remains stalled after the errors stop.

Temporary submission failures can leave requests in the same state, while
retaining an skb that the next submission attempt overwrites.

This series fixes buffer ownership on failed submission, unwinds
incomplete startup, and preserves requests through one delayed retry path.
The retry worker schedules submission even for a single request. A
separate error list provides a 100 ms batch delay from the first error
while preserving normal successful RX batching. Shutdown drains retry
work, submission work and active requests in that order.

Completion retries cover EPROTO, EILSEQ, ETIME, EOVERFLOW, ECOMM and ENOSR;
ENOMEM/EAGAIN from startup or worker submission uses the same retry path.
Cancellation and removal keep their release behavior. EPIPE endpoint-halt
recovery is outside this series.

With 24 injected EPROTO completions, the original driver stopped at eight
pending requests and zero in flight for about 30 seconds. Under the same
error budget, the patched driver retained all 32 requests and resumed RX
without restarting the interface.

Validation:
- ARM64 QEMU KUnit: 11/11 cases passed, covering the actual RX helpers,
  worker, buffer ownership, startup failures and shutdown.
- RTL8192EU on Raspberry Pi, kernel 6.18.46-thesis-test-rt+: 13/13 cases
  passed using a compatibility backport. The lab fixture substitutes
  completion statuses and injects submission and allocation failures.
  Each of the six completion statuses recovered after 32 completion
  errors followed by 96 submission failures. Error-window, pending-retry
  stop, startup failure and clean RX/down-up cases also passed.
- W=1 ARM64 allmodconfig and allyesconfig builds passed with incremental
  caches; the changed driver and KUnit objects rebuilt in both.
  Sparse added no diagnostics relative to baseline.
- Each intermediate production commit compiled, and sequential patch
  application reproduced the corresponding source trees.

---
Changes in v2:
- Target the rtw-next branch of https://github.com/pkshih/rtw.git.
- Send the patches inline as plain text, without attachments.
- No code changes; the base commit is unchanged.
- Link to v1: https://lore.kernel.org/linux-wireless/CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com/

---
kimwooseok (4):
      wifi: rtl8xxxu: free RX skb when URB submission fails
      wifi: rtl8xxxu: unwind incomplete receive startup
      wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors
      wifi: rtl8xxxu: test RX ownership and recovery across failures

 drivers/net/wireless/realtek/rtl8xxxu/.kunitconfig |  16 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |  11 +
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |   3 +
 drivers/net/wireless/realtek/rtl8xxxu/core.c       | 236 ++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   3 +
 drivers/net/wireless/realtek/rtl8xxxu/rx-test.c    | 461 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rx-test.h    |  27 ++
 7 files changed, 707 insertions(+), 50 deletions(-)
---
base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
change-id: 20260913-codex-rtw-rx-v2-ffc2107308df

Best regards,
--  
kimwooseok <5mghybrid@khu.ac.kr>


