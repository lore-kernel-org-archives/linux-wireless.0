Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514CF40F755
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834615; cv=none; b=MLQd1zUdZRjQn1EvNSLsXeS2rD4BHqF0a0j0XfV7LCthyILNwJfpj8RLwp3yQ2fvotrmUfusziF1KOP12zd4CZJrPcZnSmh/bVt6um5QViEQmBSHpzwW/KePiWPIPV0w9/lKT5eTANef5kSYTdQcsh2ZJa4EDHWr8HSUu4P4Od4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834615; c=relaxed/simple;
	bh=n9WR3ATZuYJtweK4TbsSpXqNJg8ItWkcIaJHhzhu7nY=;
	h=From:Message-ID:Date:Subject:To:MIME-Version:Content-Type; b=QdCMy8is7g8Ds/yMKI07v7RJNH+Ofa54NbH9pQow1s7rlNxUIDdAKbMcL0bF758CXwrfXMxI6A2+nHjlaabr36uWuxJRaMYfSN3jsVM8notmZGIqvTwMuqJUUg3P2irAWpbLsjvBRBSDhdIf/T0ta94S9VE13KCI7jYcbL6V14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=MLgMqY9p; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=OYxkDRE9; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="MLgMqY9p";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="OYxkDRE9"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834607; x=1788439407; bh=xe9WDSkYADTRTVbdgb
	wjf87ZWh3NcSJd9Q58QZsmXds=; b=MLgMqY9pxHfCj2/VTXAUwYjv603tK5ooQpQRFk9M8OOCT
	XJp2umw2z3En8ocqMyPuP3s9iE7FL2N8VWjgS7fqkAj9wy880UiKpsBhGPVueP1gFpgFG6xkR80
	D7IMxcRu7a5xHhWcQjvuj+mhBWDb10Z0teWyfJksFJ4gLt0GsxKnvqUxFwhuQ0igPDoFBWJyuO4
	0pzWdDcYK+ehmSyaI/0LO6jcoNJYowKy308pnnoK6VD4icS8rGK0uTNbjRVxt08eBOj4ccfx7GB
	f6pN5tB5mRIIyYnZCdF6+07guCqzSzW+E7r2qFcf46PrupbpLDFCBQ3f3aOMecI4sB7USWJg==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834607; x=1788439407; bh=xe9WDSkYADTRTVbdgb
	wjf87ZWh3NcSJd9Q58QZsmXds=; b=OYxkDRE9Py2N6kuO0eFiWnNttsAuH1tCL+H6W8Szkmcsq
	dk0gIGz4wzLg16hcXJiD21KiYS1A5nSJM/PiOo2tL+fjj8CGyphQXQgGRzSKBWEBkDq07OjlW7Z
	QhcC/5C7ym0imfQLNxnHd7He9zHHRaMSldeDyek7gmNOS4/3u7B4z9ex/AR3tWSmHnW6RPfjY5U
	yIE8XbNZjQwFrPbsYDljmBgCgETgI7hQSAqxiN/nSXPEqwyIpP4jpnmdzBHpDg1jM4K8WgEMg5K
	7fUnMyeSQt1ytqLEPVKZod4wQ/Z9Ec+USg5rYBsfsqPWq4KtjQWyXd/6SvgXiGvS0jXLuCaw==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+a27ae3497f0074da@bugs.sh>
Message-ID: <K9HvthWDvq4gyjBVMeGsnsvA26mYMZ9v4gW7@bugs.sh>
Date: Thu, 27 Aug 2026 12:43:17 +0000
Subject: [BUG] drivers/net: out-of-bounds in ar5523_cmd_rx_cb()
To: linux-wireless@vger.kernel.org, "Petr Mladek" <pmladek@suse.com>, "Geert
 Uytterhoeven" <geert+renesas@glider.be>, "Kees Cook" <kees@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Josh Poimboeuf" <jpoimboe@kernel.org>, "Song
 Liu" <song@kernel.org>, "Biju Das" <biju.das.jz@bp.renesas.com>, "John W.
 Linville" <linville@tuxdriver.com>, "Pontus Fuchs" <pontus.fuchs@gmail.com>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    drivers/net/wireless/ath/ar5523
    crash   out-of-bounds in ar5523_cmd_rx_cb()
    commit  4e15e89faac9 ("net: bnxt: ring the doorbell when SW USO exits e=
arly")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+a27ae3497f0074da@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/a27ae3497f0074da/patch.diff
        report.md   https://bugs.sh/b/a27ae3497f0074da/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  4e15e89faac9 ("net: bnxt: ring the doorbell when SW USO =
exits early")
    VM setup       https://bugs.sh/b/a27ae3497f0074da/run.sh
    config         https://bugs.sh/b/a27ae3497f0074da/config.gz
    poc            https://bugs.sh/b/a27ae3497f0074da/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: out-of-bounds in ar5523_cmd_rx_cb (drivers/net/wireless/ath/ar5=
523/ar5523.c:83 (discriminator 6) drivers/net/wireless/ath/ar5523/ar5523.c:=
125 (discriminator 6))
Read of size 18446744071562067968 at addr ffff88800df00024 by task swapper/=
1/0
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0+ #56 PREEMPTLAZY
Call Trace:
<IRQ>
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:595)
kasan_check_range (mm/kasan/generic.c:186 mm/kasan/generic.c:200)
__asan_memcpy (mm/kasan/shadow.c:105 (discriminator 1))
ar5523_cmd_rx_cb (drivers/net/wireless/ath/ar5523/ar5523.c:83 (discriminato=
r 6) drivers/net/wireless/ath/ar5523/ar5523.c:125 (discriminator 6))
__usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1657)
dummy_timer (drivers/usb/gadget/udc/dummy_hcd.c:2019 (discriminator 1))
__hrtimer_run_queues (kernel/time/hrtimer.c:2067 kernel/time/hrtimer.c:2124)
hrtimer_run_softirq (kernel/time/hrtimer.c:2141)
handle_softirqs (kernel/softirq.c:645)
__irq_exit_rcu (kernel/softirq.c:679 kernel/softirq.c:519 kernel/softirq.c:=
767)
sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1062 (discriminato=
r 35) arch/x86/kernel/apic/apic.c:1062 (discriminator 35))
</IRQ>
asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm/idtentry.h:674)
default_idle (./arch/x86/include/asm/paravirt.h:62 arch/x86/kernel/process.=
c:768)
default_idle_call (kernel/sched/idle.c:122)
do_idle (kernel/sched/idle.c:199 kernel/sched/idle.c:355)
cpu_startup_entry (kernel/sched/idle.c:454 (discriminator 1))
start_secondary (arch/x86/kernel/smpboot.c:312)
common_startup_64 (arch/x86/kernel/head_64.S:418)
Allocated by task 45:
The buggy address belongs to the object at ffff88800df00000
which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 36 bytes inside of
1024-byte region [ffff88800df00000, ffff88800df00400)
The buggy address belongs to the physical page:
Memory state around the buggy address:
ffff88800defff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff88800defff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88800df00000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
^
ffff88800df00080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
ffff88800df00100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Kernel panic - not syncing: Fatal exception in interrupt


---
The report format is based on syzbot bug report.

This report is generated by a bot. It may contain errors.
See https://github.com/n132/cedalion for more information.

For any issue with this report, reach out to cedalion@bugs.sh

If the report is already addressed, let us know by replying with:
#co fix: <commit hash>

If the report is a duplicate of another one, reply with:
#co dup: <lore link>

If you want to undo deduplication, reply with:
#co undup


