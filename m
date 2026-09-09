Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349EB582B8A
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969884; cv=pass; b=BrBm+9xpC1Zz40H2PxAv787zgptPaGf5xwaaQ6gHwU2QTPsGPJDX5UYGVkBIspR1Vxh15DP8NwdpnCMMSZhgeyiizBdVZoIDoahGK699i8I+1icI1zJ7eSglQn8E4KWgtU4pbG87Mjn2KnB3RwyGd9sk9XcrQqo2gBM3i9cYxFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969884; c=relaxed/simple;
	bh=nGn7Z3t4ZbhWTD8r/y6YkwRq4GQunXuzolHgLynNEiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYWeAQ1kNkYdjmv16F4I99W0QYLtzsp9J2TboIgpSMc7YI8nmovAubyku5uevZ/4B3qo+lIQl5oyYJs88BSnbIvxbJVNDlmKq2Smuc8rRyRLdjg0syRCrKUH78Hbp3ZUdwe5HlYOzfWvE7y5fpSMpcFKiKennhNrPsRnuMLDxlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QulSSDW3; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QulSSDW3"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f4df360cc9so1083a34.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 09:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788969876; cv=none;
        d=google.com; s=arc-20260327;
        b=aomFnycFtmgH6pucJK16F7NmOF6mnOJMcPlDUlhIIhO5Vnuj74XNEKZEaMLsXKOrAf
         jwl1+aqrt3MxPRhzjv8jAZzN3hhNdUo+I/9mUgIGhU5VCVG1Fin+Irasdw+KvFs++OV8
         l1Y0ARqBogtIqKx5TiZuYbgCTPwaziBZA0S4qPrTOMyRwVVOn8FfRk9K7TimtHxg2MEA
         iLWwaiA2fFDWVmA5Sx7pnVnSWkvJNxpHmM4gS+AhA/ZHacxoXBHv9HOpRcus959MmyXG
         CfxmzTXdj/OKVd88nFCisWm43cpRAuIrDcT3Pt5fadDJToVD+b1lh7LyPcTe1g6Furt1
         JNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pn35Zv80suBYT8EilnQ7EI/ZY6LMkIOpiVZoLSb4gFE=;
        fh=67PC05McSFfM96ZnA9Jt5RaLgT6tuoV+xk/XpRIn3Do=;
        b=jfTVrFLsvkElh1OzupTs6zNtURVbu1GXZfVnvCIPl2MeTp8xHvjZ09etSNYL+DxLFB
         yXhxd/FOw6VNpoE3tCBnM/gfM+Bubc5viROIoGX0XuJXy8dERN2FS4fPruMhA71vsXzL
         mfIuKV51BAs2VZe3Ff9OsWxGlAPzDfSRX+GHZbcZD7TDFpsFF0qtBEJw7MHNBnV5HC0b
         Vj0xzGRs4dy+OE/HPkQcDaVZ1idDI0fBR420CCcGg1Ed1axwD4vgQtnAMKH1TDZcJ6d3
         0MXMYI5GYYDGmAZ+71q5a72+CAYwIEhrJ0WFWqZIyWTJk/CdLeMopqQFOqqwDa0dzB8w
         /hCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788969876; x=1789574676; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pn35Zv80suBYT8EilnQ7EI/ZY6LMkIOpiVZoLSb4gFE=;
        b=QulSSDW3owE7U2hDGkSdmGFueobrQ73U3xrlcUOwwtheC/npjl182qWlrTgD8H3c3x
         x50CO21c5iyDL7pmVuQIHsx3gws5cmFXvhsGVo06/7JUfzgG0uYJ4JBGrclXH9aYnSf+
         Va+JFr5k1gEJSai9tUcXwLDNygTAgDRWrWWIxXl+XqzwAKjbeTvINfHkPL1QAMlOktAt
         fOyd8N1eOpWFcGNCyNPOpxFsCRboFl6FUIe1rrMzX+1imnAcoTdxDAgQ5R7QPbRaljWD
         jQ2/n3xEjTfHPbpEzhsUTwos/qrBA7V9sEnsmpWPJ+Fo1D252Lk05TRaED1LKiVZu0Zj
         M6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788969876; x=1789574676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pn35Zv80suBYT8EilnQ7EI/ZY6LMkIOpiVZoLSb4gFE=;
        b=nNRdYkSIVPH0vIDprV2S32cIwy+5EiXgYYTBrQBDprY3TZd7o2zAxFcdPhI9TNU8DI
         /HL+dILJ4gBTBdO/VLPFEZOXrvGiLK4rL144LIyXxbdm2RirKAzHRa+PPRp1vfZpcAdl
         MGYUq1TQ20MYR1LTDYvYPdxWnnS8pV0u6poTu5D9dm9cCGCHOkG4toaWOKUXyby/V+XZ
         IgPyvCs7S3BzmX7Run3gpNndf55GaJPGIo3M1NBqkneNVtys2FcHnH+JlritONVlZc0E
         BilRHqArKB/Q6dS/lgJjGq0y/OQoVwUHredHysxerGDOs12qVd2CBSo+GesfeaYIE5yA
         6F0A==
X-Forwarded-Encrypted: i=1; AKwUvBw2BChX4uwN6JRSaeH4Y2eEcelpLcJIjZQ0ZbOQdHNxaYWY7axevZc7+slt736db/w5+ClFlEjALrqbvLQkuw==@vger.kernel.org
X-Gm-Message-State: AFuF++l7QSN7eHwgybsHW3aGI0jx01iVOTmN7Gdbe1tbxxosLjvriyJ9
	LO+MZq4Icah0MH0OoVf9qh9aNk1cBUb1kt3rkrrszQW1S0OBA/PFM/vuVTgfV0AtRRGyaaEoccO
	7JnqkMfZU85b7slMTo/rvlCki06xMrLXU5lUe2ogn
X-Gm-Gg: AYBFou1n7JFnCP9ZQ7YYC2iqBzHZuB57qKX5vlyLWs8P3fV5llCwJr7/zWIs4py3MXV
	KwbLJjgAfLWqFUbHqzyyztRT70SrxGJlDKOBs6qGL23qdJkEBoX8aVmUYm4ZgwFjBWs280lxIbS
	mSyDk6OdEVcY8NNoLidC3ARwVtWtwKe7OC4Deq2kYlz8D6x/AjEVcwZUOUQSfMRpKk4FVnHfx8E
	6PB0Sy8XimlH1iLMGhtZM/xbW04bbhgneFkUTk5tpj2PLkal7FGEfNd380rbJeqAaTrXj7HIuqf
	frIf4fhQmAn+93Cxas2spbtHmcrVGGiUBl6F8U0f8sEPOqObKdpcy1N92dHeRli78X14tMqU7mM
	kMbdFaDZDbx59q1j6KXbRxFoPdqNXiFGzHFo0zZsAeMF//ZTPWB2txRoTcaPBetI71t3tuTZyxL
	aEC8N8OIxEChwz1n8IbPA=
X-Received: by 2002:a05:6830:1303:b0:7f9:5a3:c243 with SMTP id
 46e09a7af769-7f905a3c495mr12608437a34.26.1788969875996; Wed, 09 Sep 2026
 09:04:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a73bd79.6851e1c7.236b5a.0003.GAE@google.com>
In-Reply-To: <6a73bd79.6851e1c7.236b5a.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 9 Sep 2026 18:04:24 +0200
X-Gm-Features: AcwNN1WEL9mmmb28wbdDNKmhZqM-XxgrA8b0qFly8A6ocEiOqFliEfjU9BYITWo
Message-ID: <CANp29Y5x0qQVcw8TaZ=xCL-=kXoghCuXk9WxqjArVM4goNjWAQ@mail.gmail.com>
Subject: Re: [syzbot] [ath10k?] WARNING in ath10k_pci_probe
To: syzbot <syzbot+5c061dd050f2b84b2e1b@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz invalid

See the discussion at
https://lore.kernel.org/all/6a88012e.dbb3a75c.13dd47.0007.GAE@google.com/T/

On Thu, Aug 6, 2026 at 12:47=E2=80=AFAM syzbot
<syzbot+5c061dd050f2b84b2e1b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.=
k..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D16cd13b958000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dcb17729fb04b1=
e3a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D5c061dd050f2b84=
b2e1b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e25=
5-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15b24bb9580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1061acc658000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/375d27e96ecb/dis=
k-848acc8f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4ba19a656b9d/vmlinu=
x-848acc8f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7c2a17aaee7c/b=
zImage-848acc8f.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+5c061dd050f2b84b2e1b@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> 1
> WARNING: drivers/net/wireless/ath/ath10k/pci.c:3597 at ath10k_pci_probe+0=
x6e2/0x1c60 drivers/net/wireless/ath/ath10k/pci.c:3597, CPU#0: kworker/0:2/=
198
> Modules linked in:
> CPU: 0 UID: 0 PID: 198 Comm: kworker/0:2 Not tainted syzkaller #0 PREEMPT=
_{RT,(full)}
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/24/2026
> Workqueue: sync_wq local_pci_probe_callback
> RIP: 0010:ath10k_pci_probe+0x6e2/0x1c60 drivers/net/wireless/ath/ath10k/p=
ci.c:3597
> Code: 35 fb 45 85 ff 74 50 e8 dc 12 35 fb 48 8b 7c 24 18 48 c7 c6 80 2d 0=
7 8c 31 d2 44 89 f9 e8 26 a7 9c fa eb 7f e8 bf 12 35 fb 90 <0f> 0b 90 41 bf=
 a1 ff ff ff e9 7b 01 00 00 e8 ab 12 35 fb 4c 89 ef
> RSP: 0018:ffffc90003aa7980 EFLAGS: 00010293
> RAX: ffffffff8690c681 RBX: 00000000ffffffff RCX: ffff88802039dd00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003aa7ab0 R08: ffff88802039dd00 R09: 0000000000000009
> R10: 0000000000000100 R11: 00000000000011ac R12: ffffffff8bcd1d44
> R13: ffffc90003aa7a40 R14: 1ffffffff179a3a8 R15: ffff888021ad8000
> FS:  0000000000000000(0000) GS:ffff888125c3e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000000 CR3: 000000003b198000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>  local_pci_probe_callback+0x120/0x1e0 drivers/pci/pci-driver.c:361
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/6a73bd79.6851e1c7.236b5a.0003.GAE%40google.com.
