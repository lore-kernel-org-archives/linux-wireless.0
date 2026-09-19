Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2A3C3C0E
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807618; cv=none; b=u6OHJFOcxAdOO/dmmAtHbEomgKPiQCtuQn/1TJNzrqfcnOaCxpmnxHjW/qh9HOyRQdUuqwIVMG05TFdcFVfBeifnSWxaSZQZ13mUWokY+EifxBgeT3LZxiw2qKxiJ3fz5h1Ta3SJMWcoeKGwrnX+hAm0WFT9ZwcBR+olo7C65Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807618; c=relaxed/simple;
	bh=wN7MJCqqprNEjxsaGKW5gvUmTcAO3K7dsLmzTTV+A3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rSy5Oi3wLREc43sOha1C9VsttgX9QVMLJMsKaWaQDPgm6d0GSMeGol1KJlKWyNUSNdeKu98oBL3glgyP23H0J7ATSRUwF3IM3b6ZNhsdu2DeT7fwX3G+vzoRQLJrrQeeC+vXb07XlVXgQUi9jp4WK5ClyVCSw4nILYVw4b6rVu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qxppaplv; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxppaplv"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccdaea76so640793a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 01:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807614; x=1790412414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KRazOrlVHQa2NGAOgwzsRIopOuiEfzmLQ9s0vRsa4Gs=;
        b=qxppaplvB6ZY+fiTEnM/wMHN4F95Ukczj6MULx57gzYUfXuRB3+VfKozCJAmpxboaQ
         1ttiJ/ge9L19OCdRcfqDw7zUXcUU1D9i6VrEEQ+wgCVKrEKZX+VMLVZBt9TA5NIbrwl+
         Gx/13/pU45VK2kHhyDtfkS8ltoXvAWEA52chkJs3LkWcXr8ZvxFJG8Rg365Y0L1mHCly
         S0ryYa33hxGntyFydsUHXxhQHl4EkSqNy6qG1+sM2sFXNSpuFpEMtXpOlUHgapU/2+6N
         acJzN2aIV+S1O5Uo1mWl4UZRWFr2qOBM7l3QQRCmML4+EYgMN2E+KiM4/SR5e9DQEkxx
         B/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807614; x=1790412414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KRazOrlVHQa2NGAOgwzsRIopOuiEfzmLQ9s0vRsa4Gs=;
        b=uVBwUZTfzQFx85LHtNhxsGesYFHfMex0QO3nIK+SdyRIxHB9vX9Ds6mqsn7bLGOqiX
         puRTvll0G0c/L76YsTjzNMWHlgkbeWsfvucPyRE3qbByGt/cL7SBUkHOpOflExnkougf
         aJ6+vAfKhN2DTQ9iZUBZXfU854leYqLz7rLPJKh2/dw6pIQ3y2Tl4V8dV9501dnceqdI
         CMkUrZEhK83QpdFf1EnH4IgN7WWH+6mUSRu5dhqqiY2Sg6NuOJGIB4R0BWWehjx7aai7
         5nMnKqXhH/t9zpVHXYwwOWX/tAjCgT5ofPRSOOwbsOUHHiuXmNc2ybkBqrQ8CkJQl1i2
         TOsQ==
X-Gm-Message-State: AFuF++nVq/Dae2dZ+e70fUWCMT8F1EEk9cc9zp8tgrNcmtMne2VrAHLK
	VL6/s9FTQ4PN52nslv1R4iryXKr2wd3v+l631zd3CjKrUXk+pj2JhmfCy2+/yMGInlAxglVC
X-Gm-Gg: AYBFou1ozVpgLbn2/366Tao1avyDxF/DzzxoFQdtMWUCLbaKmIay0b8Mq8blfmIe1nq
	ljCzKP4ouV7T7qIvSqvWe3YO6jV7z6RQtbjhkyqdumi4qofv71WqDOxKepz1u37wBwKtuZ6Uge8
	WeKN8zB2DdoyXIrBE4UpnPmwZpxsHaTndCL8opRiCk0BL6ww4ee5qZT2GrQGhWQUsXkd2jK2kUr
	YcH3O3wG3HjK0HibxIapDQ2crdSSOSOwWAahlE9OE/Z9WYsynk670o3dHwdw/0OwzUHMc7cab2R
	eyVUpRagR8skepI5tgbgvAA4Ti7BK8NVT3Y4Zoad+t2VpDUXkkv6gO9eN1l4O3EeOhSpffzBq5a
	OaVxmRyDucx9lDv7fVxlU0c5mvTs2ZhssHsttSWmB+Wa4XSBGRFu3KOHW191B/sWZD7iO+jY/jW
	E6arDWLaBzSNchdC+TxReuqRcdcCP94+UDxoEOC63yrEXv3DU+2soKVOE5Jp5xcN8SPPojPgdfZ
	kN8zciyWvMOh46vnbOkCHNRZWMTqypRTMmKcJurmIVDbSPd9cBfC6bhGkPmBR9kVLEutw==
X-Received: by 2002:a17:90a:d2ce:b0:39e:429b:1e2c with SMTP id 98e67ed59e1d1-39e556ac4cbmr5889273a91.15.1789807614207;
        Sat, 19 Sep 2026 01:46:54 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37a88csm3511800a91.8.2026.09.19.01.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:46:53 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH v3 0/1] wifi: mac80211: validate TX status rate metadata
Date: Sat, 19 Sep 2026 16:46:40 +0800
Message-ID: <cover.1789801378.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Linux kernel maintainers,

minstrel_ht_tx_status() converts the HT/VHT rate reported in a TX
status into a group and rate index and uses those to index the
minstrel_ht rate tables.  Neither the common mac80211 status path nor
the minstrel validators checked that the reported MCS, NSS and
bandwidth are representable, so a malformed status report could walk
past the end of struct minstrel_rate_stats.

This is v3, reworked along the review comments on v2.

Changes in v3:
 - Move the generic rate metadata validation into the common mac80211
   TX status path (net/mac80211/status.c): the legacy ieee80211_tx_rate
   array and the rate_info based entries are sanitized before any
   status consumer runs.  This follows the review feedback that values
   such as nss =3D=3D 0 are generally invalid and should not be checked by
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
 - v2: https://lore.kernel.org/all/20260529143446.1374404-1-n05ec@lzu.edu.c=
n/
 - v1: https://lore.kernel.org/all/0e3f97ca5cfbeb67a8e60ca5c266f4335950816b=
.1779619788.git.xuyq21@lenovo.com/

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
> minstrel, we should have most of the checks in general (e.g. nss=3D=3D0
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
the minstrel_ht rate tables.  A VHT entry with idx =3D 0x7f (NSS 8, MCS
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
monitor interface and returns the first VHT TX status with idx =3D 0x7f.
It is unchanged from the initial submission (the full source was
included with v1, see the link above) and is run in a KVM guest with
CONFIG_UBSAN_BOUNDS.

------BEGIN crash log------

self-contained userns setup complete; injecting radiotap VHT traffic=0D
data TX sample: idx=3D0 count=3D1 flags=3D0x100 addr1=3D02:11:22:33:44:55=0D
forging malformed VHT TX status: idx=3D0x7f flags=3D0x100 event=3D1=0D
[    1.026837] ------------[ cut here ]------------=0D
[    1.026841] UBSAN: array-index-out-of-bounds in net/mac80211/rc80211_min=
strel_ht.c:409:33=0D
[    1.026845] index 15 is out of range for type 'minstrel_rate_stats [10]'=
=0D
[    1.026848] CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted 7.3.0-rc=
2-00458-gfefaac1176bf #1 PREEMPT(lazy) =0D
[    1.026852] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-10.fc44 06/10/2025=0D
[    1.026853] Call Trace:=0D
[    1.026869]  <TASK>=0D
[    1.026870]  dump_stack_lvl+0x4d/0x70=0D
[    1.026879]  ubsan_epilogue+0x5/0x2b=0D
[    1.026882]  __ubsan_handle_out_of_bounds.cold+0x4e/0x58=0D
[    1.026885]  minstrel_ht_tx_status+0x98c/0xd70=0D
[    1.026892]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[    1.026894]  ? select_task_rq_fair+0x24d/0x1c20=0D
[    1.026898]  rate_control_tx_status+0xac/0x130=0D
[    1.026901]  ? ttwu_queue_wakelist+0x12d/0x260=0D
[    1.026905]  ieee80211_tx_status_ext+0x2d5/0xc50=0D
[    1.026908]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[    1.026910]  ? sta_info_hash_lookup+0x95/0xd0=0D
[    1.026913]  ieee80211_tx_status_skb+0x8a/0xc0=0D
[    1.026916]  ieee80211_handle_queued_frames+0xb0/0xe0=0D
[    1.026921]  ? __pfx_ieee80211_tasklet_handler+0x10/0x10=0D
[    1.026923]  tasklet_action_common+0x159/0x260=0D
[    1.026928]  ? tasklet_action+0xb/0x30=0D
[    1.026929]  handle_softirqs+0xc6/0x300=0D
[    1.026932]  ? __pfx_smpboot_thread_fn+0x10/0x10=0D
[    1.026934]  run_ksoftirqd+0x20/0x30=0D
[    1.026936]  smpboot_thread_fn+0xf1/0x220=0D
[    1.026938]  kthread+0xe1/0x120=0D
[    1.026941]  ? __pfx_kthread+0x10/0x10=0D
[    1.026943]  ret_from_fork+0x196/0x260=0D
[    1.026946]  ? __pfx_kthread+0x10/0x10=0D
[    1.026947]  ? __pfx_kthread+0x10/0x10=0D
[    1.026949]  ret_from_fork_asm+0x1a/0x30=0D
[    1.026952]  </TASK>=0D
[    1.026962] ---[ end trace ]---=0D
[    1.026963] Kernel panic - not syncing: UBSAN: panic_on_warn set ...=0D
[    1.064263] CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted 7.3.0-rc=
2-00458-gfefaac1176bf #1 PREEMPT(lazy) =0D
[    1.066479] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-10.fc44 06/10/2025=0D
[    1.068420] Call Trace:=0D
[    1.068978]  <TASK>=0D
[    1.069454]  dump_stack_lvl+0x4d/0x70=0D
[    1.070288]  vpanic+0x253/0x470=0D
[    1.071011]  panic+0x66/0x70=0D
[    1.071694]  check_panic_on_warn.cold+0xf/0x1e=0D
[    1.072723]  __ubsan_handle_out_of_bounds.cold+0x4e/0x58=0D
[    1.073906]  minstrel_ht_tx_status+0x98c/0xd70=0D
[    1.074910]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[    1.075992]  ? select_task_rq_fair+0x24d/0x1c20=0D
[    1.077006]  rate_control_tx_status+0xac/0x130=0D
[    1.078002]  ? ttwu_queue_wakelist+0x12d/0x260=0D
[    1.078997]  ieee80211_tx_status_ext+0x2d5/0xc50=0D
[    1.080033]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[    1.081097]  ? sta_info_hash_lookup+0x95/0xd0=0D
[    1.082074]  ieee80211_tx_status_skb+0x8a/0xc0=0D
[    1.083068]  ieee80211_handle_queued_frames+0xb0/0xe0=0D
[    1.084187]  ? __pfx_ieee80211_tasklet_handler+0x10/0x10=0D
[    1.085356]  tasklet_action_common+0x159/0x260=0D
[    1.086348]  ? tasklet_action+0xb/0x30=0D
[    1.087182]  handle_softirqs+0xc6/0x300=0D
[    1.088053]  ? __pfx_smpboot_thread_fn+0x10/0x10=0D
[    1.089129]  run_ksoftirqd+0x20/0x30=0D
[    1.089930]  smpboot_thread_fn+0xf1/0x220=0D
[    1.090835]  kthread+0xe1/0x120=0D
[    1.091547]  ? __pfx_kthread+0x10/0x10=0D
[    1.092393]  ret_from_fork+0x196/0x260=0D
[    1.093242]  ? __pfx_kthread+0x10/0x10=0D
[    1.094090]  ? __pfx_kthread+0x10/0x10=0D
[    1.094927]  ret_from_fork_asm+0x1a/0x30=0D
[    1.095817]  </TASK>=0D
[    1.096458] Kernel Offset: 0x2e400000 from 0xffffffff81000000 (relocatio=
n range: 0xffffffff80000000-0xffffffffbfffffff)=0D
[    1.099071] Rebooting in 1 seconds..=0D

------END crash log-----

Best regards,
Yuqi Xu

Yuqi Xu (1):
  wifi: mac80211: validate TX status rate metadata

 net/mac80211/rc80211_minstrel_ht.c | 59 ++++++++++++++++++++++---
 net/mac80211/status.c              | 69 ++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 6 deletions(-)


base-commit: fefaac1176bf3cf002a8dc83339d6ed6a369941a
--=20
2.55.0

