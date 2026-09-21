Received: from mail-pz2-f20.google.com (mail-pz2-f20.google.com [74.125.228.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C7146D5A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959133; cv=none; b=Yi0OfBp9RnW12hVaaNS6XRZt4GPdCMRX5DxEL1QI6qOIlc1Sxgm+xWLnQcXiEaj2qVuvN/fxC2UpUx5u2lmTbmuzOkDic4cIUa5SwzP9qzjM0ERflENY0tGP5VqOzmGErhsYf62G76Ou2zcnBzxa9E+NkaLmwEOqYe6uL38Jqa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959133; c=relaxed/simple;
	bh=h2dD0db92SpjqhCfa0xdaCHFfLpWGqs5rkJkN2HoJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YjYEBoqCr9N3fgPuxGuP/pbJXbPXQjv7V23VImjhB1Gud3paaQpAbCZNPoiXzxrOvoWYwgfEcKameNtrl50zsmWLSA78qipC7txcBK6yd5PTf/pmw9IbjaTQFf2IiJSgyS2M0Av4AYzy6I/sn6/hXrI2Kz6yBoZxZ3WE4xRKIOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfSpsDtq; arc=none smtp.client-ip=74.125.228.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfSpsDtq"
Received: by mail-pz2-f20.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso1719436a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 19:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959131; x=1790563931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YXkhBYcxaWnnUz9HqCApE8Lq+7q2sthOSZb8y27hjAM=;
        b=XfSpsDtqjUvjaMrHsw8L4jruXkVyfuqrykPSgLEWTigHwchsD/81IDp3wjHnnlLPZD
         baRIv0tj2BuTer1WsDTof2mYs3yLDahoFQreQErzvvXeXCTX++wKCbBQZ9OH2AXtDKCP
         OPntJhn4aKuZfIYP8O3E5zNZUkneqeNHI10OlbFYcvozJTX7pg925RcfkvSLjjebWBAq
         HEN4NXCFjW/lMftm8/kN3frnFEUvRdlxpveR6rH2dgKmVwxoPde/f3Z0apkJfHwTeQS8
         AtH3WH2nu3h4gvrPjt3LGPaqEj/WZo71M9ZhhhddTwryiWTRilFx7+j5sJFP2jEqwfTz
         qi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959131; x=1790563931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YXkhBYcxaWnnUz9HqCApE8Lq+7q2sthOSZb8y27hjAM=;
        b=Vk6ZV0WPo2XZFRLU5tsCx3fwz7w5X+7pAFPg9MpXInV1TMfmJgj/GnFDTvkJz0MpKP
         mDYkmPzor6TwEAnzc6jyyEkC0aTw+McFz67Ug55gohgdJhFcKCHaCP7Rdi+onIM/cisb
         0X2jnzSaxHlAs69nDUS4c08/Qg6GYlQO5E+gcY9Rq4uvGTKARw+f0DOoqkjNSInEa/Gs
         WACRD9oCoJW2ZUx0S7ObdbZx+S5cOBkc+IaKoSQZm3sk8rk8LE8Ybg5rU1IoZ3EoubOJ
         rvfbBTj/9UaSXHsjm6amXWFbanwnXWghOAxAO4xZCI7X0DLyPE3GfaEkswT16fDO48bj
         mBbA==
X-Gm-Message-State: AFuF++kskW6rw2ketNvHo4gOw85Igy3hreY+GGiCVsWocCEaG+JSk1dh
	DlSvIJtKm83Jij5/o2u+3huWWQHyw4YAb/4hwLQ9BxXLzoxfj3JLRfsxm2saq2sO2yHCEiMc
X-Gm-Gg: AYBFou1f0lroSdZ9NCu/LN5Dtr73AwCxEYMdcyBFfE2AcbaH3rEXWy2YO8iWG3uO9Bq
	0g4+hWXkhBVIsaS0e0jFhqkhiJQXH7i1J5fBTuUG1QwxS8KzYVlrjnYeGUheggONwFyWBQKPYyE
	lSMW1nOVSpTLaRhFs+h0v4fXKA3VW9f0a793HuiSqzQYj+SCst/+g4MHU1Ztx2N2pM1l1Lg6/y4
	0pJO4pSnNnUEgfa8RGPuxL5GTEzhCeqhdMpMbB0fvW14UgCiySJpHtxu2Y4rjtE7cSMdx36JxQ8
	rRJwiSmPGbbI1c8O5If/asosxcOt/6S6EqDaIMU3xTwoavHFE7OAVWrgZ0uJZulfx9Z6FtL9QSK
	+svlXCB7jFdJrtP1bRstq2HIsymMzShX29obKnVdGRRfN2XrMhcrK0yMXQHDp1iH28lULDxcE4O
	sc5luBKFmb9MlOHNzmF8/3boDVriAEt7mNxnCNikS3KBgdzNk/T9NQ416VG8T6VOkLLhyQuRcbD
	byOZdmSpHFYe0n3vIw71owGqcsnMlHn31YhNBP0MnAKzpwJ/de5Dekrl+bh1iQIRv9Rg/UY+WfF
X-Received: by 2002:a17:903:1450:b0:2dd:c053:e667 with SMTP id d9443c01a7336-2ddc053e6e5mr86260685ad.45.1789959130696;
        Sun, 20 Sep 2026 19:52:10 -0700 (PDT)
Received: from lenovo-thinkbook.lenovo.com (n11212025079.netvigator.com. [112.120.25.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2de217b3a97sm24898935ad.31.2026.09.20.19.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 19:52:09 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W . Linville" <linville@tuxdriver.com>,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH v4 0/1] wifi: mac80211: validate TX status rate metadata
Date: Mon, 21 Sep 2026 10:52:03 +0800
Message-ID: <cover.1789958876.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

minstrel_ht_tx_status() converts the HT/VHT rate reported in a TX
status into a group and rate index and uses those to index the
minstrel_ht rate tables.  Neither the common mac80211 status path nor
the minstrel validators checked that the reported MCS, NSS and
bandwidth are representable, so a malformed status report could walk
past the end of struct minstrel_rate_stats.

This is v4.  The substantive rework along the review comments on v2 is
unchanged since v3.

Changes in v3:
 - Move the generic rate metadata validation into the common mac80211
   TX status path (net/mac80211/status.c): the legacy ieee80211_tx_rate
   array and the rate_info based entries are sanitized before any
   status consumer runs.  This follows the review feedback that values
   such as nss == 0 are generally invalid and should not be checked by
   minstrel only.
 - Keep only the checks that depend on minstrel_ht's own tables in
   rc80211_minstrel_ht.c: the supported number of spatial streams, the
   MCS group size and the supported bandwidths.
 - Drop Cc: stable and the severity wording.  We could not identify an
   in-tree driver or firmware that reports such values; the reproducer
   uses the mac80211_hwsim userspace medium, which can only forge TX
   status for the radio it serves.  This is driver metadata hardening,
   not a report we can attribute to real hardware.
 - Restore the Assisted-by: LLM trailer that v2 dropped by mistake.
 - Rebase on wireless/main (fefaac1176bf).
 - v2: https://lore.kernel.org/all/20260529143446.1374404-1-n05ec@lzu.edu.cn/
 - v1: https://lore.kernel.org/all/
   0e3f97ca5cfbeb67a8e60ca5c266f4335950816b.1779619788.git.xuyq21@lenovo.com/

Changes in v4:
 - Cc the blamed author and maintainer John W. Linville
   <linville@tuxdriver.com>, reported missing by netdev-ctrl
   (a5f69d94d8e2 is one of the blamed commits).
 - Wrap the over-80-column line in the common TX status sanitizer
   (net/mac80211/status.c) that netdev-ctrl's checkpatch run
   flagged ("line length of 84 exceeds 80 columns").  No
   functional change.
 - Wrap the overlong crash-log lines below.  The v1 link is kept
   intact and is only split across two lines to stay within the
   column limit.

Review feedback from v2 and how it is addressed:

Johannes wrote:
> First of all, I think it's kind of overblown with the CC stable etc.,
> can you actually find a situation where a driver reports such a thing?

We agree and have reworked the description.  The only in-tree trigger
we can demonstrate is mac80211_hwsim with a userspace medium: the
medium requires CAP_NET_ADMIN in a user and network namespace and can
then return forged TX status for the radio it serves.  We are not aware
of any in-tree driver or firmware reporting NSS 0 or out-of-range MCS
values, so v3 no longer asks for a stable backport.  Driver-side work
is validating the same kind of metadata before it reaches mac80211
(e.g. the proposed "[PATCH wireless v2] wifi: mt76: mt76x02: validate
TX-status rate index before mac80211 handoff", 2026-08-26), which is
why v3 treats this as metadata hardening.

> Secondly, I don't think it's the right place to be checking, we use
> the data a lot for other things in status handling, and might expand
> that, so it seems that instead of having specific checks for
> minstrel, we should have most of the checks in general (e.g. nss==0
> is generally invalid), and only have the things that matter for
> minstrel specifically (say bandwidth) there [...]

That is what v3 does.  ieee80211_tx_status_ext() and
ieee80211_tx_rate_update() now sanitize both the legacy
ieee80211_tx_rate array and the rate_info based entries before any
consumer runs.  minstrel_ht only keeps the checks that depend on its
own tables.

> But I also think that if this stuff really comes from firmware rather
> than being built by the driver, it should be the driver's
> responsibility to not report nonsense.  I doubt we can protect
> against any driver nonsense here in mac80211.

Agreed - the sanitizing does not absolve drivers.  It only makes sure
that a bad status report cannot corrupt mac80211 state.  We do not add
a WARN_ON() for the invalid values because with panic_on_warn that
would turn a driver bug into a denial of service.

> Why drop it now, when before you were saying it was?

The Assisted-by: LLM tag was dropped by mistake while reworking the
From/Signed-off-by addresses for v2.  It is restored in v3.

---- details below ----

Bug details:

minstrel_ht_tx_status() accepts both the legacy ieee80211_tx_rate array
and rate_info based entries and turns the reported HT/VHT rate into a
minstrel group and rate index.  The validation helpers only checked
that an entry was present and had tries recorded; they did not check
that the reported NSS, bandwidth and MCS values are representable by
the minstrel_ht rate tables.  A VHT entry with idx = 0x7f (NSS 8, MCS
15) produced rates[15] in a table with MCS_GROUP_RATES (10) entries and
an out-of-bounds access to struct minstrel_rate_stats.

The patch:
 - drops invalid HT/VHT entries at the mac80211 status entry points;
 - rejects rates that do not map into minstrel_ht's tables in the rate
   control algorithm itself.

Reproducer:

A self-contained program enters a user and network namespace, creates a
mac80211_hwsim radio, registers as its userspace medium, configures an
AP with an associated station, injects a radiotap VHT frame on a
monitor interface and returns the first VHT TX status with idx = 0x7f.
It is unchanged from the initial submission (the full source was
included with v1, see the link above) and is run in a KVM guest with
CONFIG_UBSAN_BOUNDS.

------BEGIN crash log------

self-contained userns setup complete; injecting radiotap VHT traffic
data TX sample: idx=0 count=1 flags=0x100 addr1=02:11:22:33:44:55
forging malformed VHT TX status: idx=0x7f flags=0x100 event=1
[    1.026837] ------------[ cut here ]------------
[    1.026841] UBSAN: array-index-out-of-bounds in
net/mac80211/rc80211_minstrel_ht.c:409:33
[    1.026845] index 15 is out of range for type 'minstrel_rate_stats [10]'
[    1.026848] CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted
7.3.0-rc2-00458-gfefaac1176bf #1 PREEMPT(lazy)
[    1.026852] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.17.0-10.fc44 06/10/2025
[    1.026853] Call Trace:
[    1.026869]  <TASK>
[    1.026870]  dump_stack_lvl+0x4d/0x70
[    1.026879]  ubsan_epilogue+0x5/0x2b
[    1.026882]  __ubsan_handle_out_of_bounds.cold+0x4e/0x58
[    1.026885]  minstrel_ht_tx_status+0x98c/0xd70
[    1.026892]  ? srso_alias_return_thunk+0x5/0xfbef5
[    1.026894]  ? select_task_rq_fair+0x24d/0x1c20
[    1.026898]  rate_control_tx_status+0xac/0x130
[    1.026901]  ? ttwu_queue_wakelist+0x12d/0x260
[    1.026905]  ieee80211_tx_status_ext+0x2d5/0xc50
[    1.026908]  ? srso_alias_return_thunk+0x5/0xfbef5
[    1.026910]  ? sta_info_hash_lookup+0x95/0xd0
[    1.026913]  ieee80211_tx_status_skb+0x8a/0xc0
[    1.026916]  ieee80211_handle_queued_frames+0xb0/0xe0
[    1.026921]  ? __pfx_ieee80211_tasklet_handler+0x10/0x10
[    1.026923]  tasklet_action_common+0x159/0x260
[    1.026928]  ? tasklet_action+0xb/0x30
[    1.026929]  handle_softirqs+0xc6/0x300
[    1.026932]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    1.026934]  run_ksoftirqd+0x20/0x30
[    1.026936]  smpboot_thread_fn+0xf1/0x220
[    1.026938]  kthread+0xe1/0x120
[    1.026941]  ? __pfx_kthread+0x10/0x10
[    1.026943]  ret_from_fork+0x196/0x260
[    1.026946]  ? __pfx_kthread+0x10/0x10
[    1.026947]  ? __pfx_kthread+0x10/0x10
[    1.026949]  ret_from_fork_asm+0x1a/0x30
[    1.026952]  </TASK>
[    1.026962] ---[ end trace ]---
[    1.026963] Kernel panic - not syncing: UBSAN: panic_on_warn set ...
[    1.064263] CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted
7.3.0-rc2-00458-gfefaac1176bf #1 PREEMPT(lazy)
[    1.066479] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.17.0-10.fc44 06/10/2025
[    1.068420] Call Trace:
[    1.068978]  <TASK>
[    1.069454]  dump_stack_lvl+0x4d/0x70
[    1.070288]  vpanic+0x253/0x470
[    1.071011]  panic+0x66/0x70
[    1.071694]  check_panic_on_warn.cold+0xf/0x1e
[    1.072723]  __ubsan_handle_out_of_bounds.cold+0x4e/0x58
[    1.073906]  minstrel_ht_tx_status+0x98c/0xd70
[    1.074910]  ? srso_alias_return_thunk+0x5/0xfbef5
[    1.075992]  ? select_task_rq_fair+0x24d/0x1c20
[    1.077006]  rate_control_tx_status+0xac/0x130
[    1.078002]  ? ttwu_queue_wakelist+0x12d/0x260
[    1.078997]  ieee80211_tx_status_ext+0x2d5/0xc50
[    1.080033]  ? srso_alias_return_thunk+0x5/0xfbef5
[    1.081097]  ? sta_info_hash_lookup+0x95/0xd0
[    1.082074]  ieee80211_tx_status_skb+0x8a/0xc0
[    1.083068]  ieee80211_handle_queued_frames+0xb0/0xe0
[    1.084187]  ? __pfx_ieee80211_tasklet_handler+0x10/0x10
[    1.085356]  tasklet_action_common+0x159/0x260
[    1.086348]  ? tasklet_action+0xb/0x30
[    1.087182]  handle_softirqs+0xc6/0x300
[    1.088053]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    1.089129]  run_ksoftirqd+0x20/0x30
[    1.089930]  smpboot_thread_fn+0xf1/0x220
[    1.090835]  kthread+0xe1/0x120
[    1.091547]  ? __pfx_kthread+0x10/0x10
[    1.092393]  ret_from_fork+0x196/0x260
[    1.093242]  ? __pfx_kthread+0x10/0x10
[    1.094090]  ? __pfx_kthread+0x10/0x10
[    1.094927]  ret_from_fork_asm+0x1a/0x30
[    1.095817]  </TASK>
[    1.096458] Kernel Offset: 0x2e400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.099071] Rebooting in 1 seconds..

------END crash log-----

Best regards,
Yuqi Xu

Yuqi Xu (1):
  wifi: mac80211: validate TX status rate metadata

 net/mac80211/rc80211_minstrel_ht.c | 59 ++++++++++++++++++++++---
 net/mac80211/status.c              | 70 ++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 6 deletions(-)


base-commit: fefaac1176bf3cf002a8dc83339d6ed6a369941a
-- 
2.55.0

