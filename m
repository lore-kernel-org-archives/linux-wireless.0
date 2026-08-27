Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC643F1656
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834643; cv=none; b=u30Njd+BPdlv2KSaxVbGjOXu/3w0T0vQDHbvMU+v1HQ+z4VUGAfY7Xzkk2A7k3vrbmPxxKZp7WAN0jsHIXcJtj60E08ITjkT/pgEITxV42TROUvZ7fejxEAs/qIn3WxB7pNW2fkBtG5+BgKJ/gX56G+zTlWkzGumMMMXifGIwcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834643; c=relaxed/simple;
	bh=uKH+BnJ8BwULUBNwrth04oBdJK0t5SnpKxbLc0f+6S0=;
	h=From:Message-ID:Date:Subject:To:MIME-Version:Content-Type; b=GGSWkGsy6jDPA3cRZKN7WkP7g3l4Om+MRFhkWbl5HXfIg6SAk7y7n7KY8/FG7QG4yp0tgebmGSYRncwkd9HzUH/pahDulmT+Gb4r99polzYwcYQv46MnWz1dwgNy0wbGvRNn9I2ZnWsidHegVxzLBDlkxlPqlDTmRhTHdm4w/Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=S7MNqn0Z; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=DUH4FUou; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="S7MNqn0Z";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="DUH4FUou"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834634; x=1788439434; bh=xp2UYImYLvVNRXatr5
	a5DXypt3Cwtz69p7mp3b3OH5I=; b=S7MNqn0Zrjbu2N/jPZw1oYctnM6k/4Ruu1N3H+k4dAX1F
	vaExgGIQgb3oqOnIkgNGnifZ4aj9U+WV34QGDov7b1pBSH5ZH4sWoVio7qJfHLV+tgMuDRM3cJA
	ddHULM+RE4/w3vTwADQMticPRtVbmYe5T0eYo0F4aL3uYYHGFRgBrnrG16bIn0EdDJzu+/2IfMN
	z06BjCEW0xtXl93IN0vjMWwtDP1uWq7OVQkZMYc+0FB7haWrcTS5hk6CFGjXd6GRQwHitOgzacs
	QyHSJX63EydtdFxmLjKIPS0ai2GiiCt21n8PBTL2Lze7EZKpRi6XM1o15ABSyCtgStFyUdGw==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834634; x=1788439434; bh=xp2UYImYLvVNRXatr5
	a5DXypt3Cwtz69p7mp3b3OH5I=; b=DUH4FUouvi6B/OIq2VewwfTspEV5YKU0bOgvH1juxi3Dk
	2cl67BGtXe9S1CU2uut7dx551s5b4cEpUTIAHOYj9Pttv1w5gYot/tDMAWOgWH730m0qBa9WMXR
	b/q40RmbJvroistsHf6QfoFt5VVPbqnGVjaAKtFspVIjtUvyVgcrstntGFhnKK7LnAq1Tj3InNE
	YNv5GyKWd3gwnIRYJZ1qS9zKx+JAvv6pHiJkgFJGZ/PkwVnCaj0cQwkfFR1WTdjUA6MM3NdQqFG
	NgYponU5LQPtJ195meIPomCSKwPWS4X4D2C0aTAm++Ve9G/iACBMeSwa81szucFTf+KqhRHQ==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+cd639b9313e09550@bugs.sh>
Message-ID: <v5hPFETntwh5YjR1fbSXichnMBMrX4irbVAf@bugs.sh>
Date: Thu, 27 Aug 2026 12:43:47 +0000
Subject: [BUG] use-after-free in ar5523_rx_refill_work()
To: linux-wireless@vger.kernel.org, "Petr Mladek" <pmladek@suse.com>, "Geert
 Uytterhoeven" <geert+renesas@glider.be>, "John Ogness" <john.ogness@linutronix.de>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Oleg
 Nesterov" <oleg@redhat.com>, "Biju Das" <biju.das.jz@bp.renesas.com>, "Kees
 Cook" <kees@kernel.org>, "Song Liu" <song@kernel.org>, "Pontus Fuchs" <pontus.fuchs@gmail.com>, "John
 W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    lib
    crash   use-after-free in ar5523_rx_refill_work()
    commit  3cd8b194bf34 ("Merge tag 'v7.1-rc-part1-smbdirect-fixes' of git=
://git.samba.org/ksmbd")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+cd639b9313e09550@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/cd639b9313e09550/patch.diff
        report.md   https://bugs.sh/b/cd639b9313e09550/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  3cd8b194bf34 ("Merge tag 'v7.1-rc-part1-smbdirect-fixes'=
 of git://git.samba.org/ksmbd")
    VM setup       https://bugs.sh/b/cd639b9313e09550/run.sh
    config         https://bugs.sh/b/cd639b9313e09550/config.gz
    poc            https://bugs.sh/b/cd639b9313e09550/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in ar5523_rx_refill_work (./include/linux/u=
sb.h:1739 drivers/net/wireless/ath/ar5523/ar5523.c:743)
Write of size 8 at addr ffff8880173a3940 by task kworker/u8:0/12
Workqueue: ar5523 ar5523_rx_refill_work
Call Trace:
dump_stack_lvl (lib/dump_stack.c:123)
print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:597)
ar5523_rx_refill_work (./include/linux/usb.h:1739 drivers/net/wireless/ath/=
ar5523/ar5523.c:743)
process_one_work (kernel/workqueue.c:3307)
worker_thread (kernel/workqueue.c:3379 (discriminator 2) kernel/workqueue.c=
:3466 (discriminator 2))
kthread (kernel/kthread.c:436)
ret_from_fork (arch/x86/kernel/process.c:164)
ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
which belongs to the cache kmalloc-192 of size 192
freed 192-byte region [ffff8880173a3900, ffff8880173a39c0)
list_del corruption, ffff88801bf220d0->next is LIST_POISON1 (dead0000000001=
00)
kernel BUG at lib/list_debug.c:56!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
Workqueue: ar5523 ar5523_rx_refill_work
RIP: 0010:__list_del_entry_valid_or_report (lib/list_debug.c:56 (discrimina=
tor 1))
Call Trace:
ar5523_rx_refill_work (./include/linux/list.h:223 (discriminator 1) ./inclu=
de/linux/list.h:306 (discriminator 1) drivers/net/wireless/ath/ar5523/ar552=
3.c:748 (discriminator 1))
process_one_work (kernel/workqueue.c:3307)
worker_thread (kernel/workqueue.c:3379 (discriminator 2) kernel/workqueue.c=
:3466 (discriminator 2))
kthread (kernel/kthread.c:436)
ret_from_fork (arch/x86/kernel/process.c:164)
ret_from_fork_asm (arch/x86/entry/entry_64.S:255)


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


