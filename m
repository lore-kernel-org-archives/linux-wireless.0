Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455BB3AA19B
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 10:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801635; cv=pass; b=cUrPT9Fd973gh9gA17X2l9oDmcTKHpl00eACXDcXnSOeH+sSGajQXin7tuN6vpGi5VSyxrACQjXR4FgJpGGrEepokoSHfvpywF9TE0q3LLMxTbILulKmDb08a61xHlEg3lia5JeOuIUi/jXm/9TihNiAGOfMALi08BBz5SPFupw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801635; c=relaxed/simple;
	bh=bctBZ7SfeblL1Jee6isWJJFc4nUdCjuxkKrxQEQL7gI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=F9AawzaMnvh/fNInR6XeJTjice+NtBA3+KIcX3PShO26Qf/+BYUfe7oDiejsGGgX9ESeaa9TTKd+gTAah0DBtVIA3WsxkaCVZOnW//En2JHhA/8CcD3UuFYfsgun4kcYVusH/HKpJ/qfOUrC6/olP12duwRd4QqDwJSDxP3V1EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHwQxgYQ; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHwQxgYQ"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e4df2e26fso228316266b.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 03:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791801632; cv=none;
        d=google.com; s=arc-20260327;
        b=dDSDm/8j82m6NmZY0tU0dIAxxhXFwmA3QyzfARZ5z0UO6HaakTdfcB5lsy84PstjKx
         aL8u/uLzcA7QtVC//uBknoJhGQUJj+Fj7V+nk5w7Fz+pGIh8neIDX0BzinZ1yuNP51r/
         jKX1mqKuh1Apsvgag12uh7CRRePG+ZvHp2UDKRe3fKU7CEyBaSrFn/gntGn2ajzP2P/e
         NGUmfRWzIDqIm5Kk2m1R76n5YWoHrLfb06mH8s3hb5iUeyuu+sLCA/lrVws9yutNJuTM
         4SLlp3WMTTE5BBIkDAhHJ5q/9wYQUaLh27Dfo+ugrJ0iWEK5co3VYg6DYcq5UGzs7eYd
         etzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bctBZ7SfeblL1Jee6isWJJFc4nUdCjuxkKrxQEQL7gI=;
        fh=xLQeZ7POm2pGYOCykbYdQzaoACwjDpwMiEQ0MF84ddU=;
        b=NFAVWWVb/8yu66gM4KD+X0WFoRuY/h/9N7ohi5c/GWlYSzjvYQ7Z7XGzPj9h12OQhx
         GxlWHHNAOoeVdhoSCNaIpNEavQ8rHHqjCvR+Yjs5TPyC5FkM/3cejlMs/ZiMGfxCQNcM
         oTgcun/8irA5ExJyP3YZPsOx0lS+dZMXn+MG0Qw8w1I2yGaQW7KuXbFC0rtth5j6gBvz
         cyHfL2tJgMMwlTDETCKQnvtHqKdMkTr3t20FloJDssKx9/73hoSfdYukcMGW4erlB5fD
         lXycf4kegNJj2T9WX1TgLt1eJbZXDrUwbiovdR4JhtKOAQO2Tue+zHR9T2XIUDUKrZzm
         s7Dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791801632; x=1792406432; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bctBZ7SfeblL1Jee6isWJJFc4nUdCjuxkKrxQEQL7gI=;
        b=aHwQxgYQ7byhyMqlaq6VyRt3IXv4rZ6/f89Oonm/mXDg/X2QZW9cDY8B0pCVJvrEzI
         25PZxJx4zrbdKbQa8+r/haTY1MLFlRMCwOO3Jqmy5otZFGclwacEtsUpN8UERhicXBYc
         1iiYrHdsxuD6DeMAd8kG4YUchSA/1YEHT+xGbw9igga/kqOv/HAAgAchId3CDil8eEpG
         pIxkFICjsgM9m1elX4Utcug90GgSTCy8NcRwTzCga9n2iflXkRTuMRYqpWdnljuYzIvE
         Yy9gPiXmr2Ut2tyZOv22mFtKFKMWEZN+2xv6z8P++DTMPDTcF58S9r0pDylYicyy7/mF
         vm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791801632; x=1792406432;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bctBZ7SfeblL1Jee6isWJJFc4nUdCjuxkKrxQEQL7gI=;
        b=svknSDfk16QBCVwHvW30Z9x3Cn/YM+dTklwU419FyXANvEqiqNRwX0zALgp5OhO6IF
         QqVQY6NJ10kyTeHLW2488x+hi17dPpSHEqvgU/SJ/ffft1OgHF8ZzfgbW2JxCKX/pusq
         Jjp2pRcs+BQFafHX1UfUpmhMH5yJiQQurRg6ubnLRUFa7iNeEzMkQRoyI706dIPP0m/V
         FO/ZI2eoRE1C4vsGR/rTlNxdMJqHo3V39RdBMA+4uok4iCZRKwjHl85EK9hG5y/p9KeA
         qJu/5nlD6M21Y/hX4zYpOVzGCpVHYsxCV6qt56m+v8pw1GT+PADgWrr2kQKlg08Angru
         U95g==
X-Gm-Message-State: AFq9FYK+LVtrlw9UbOmxc2QUMZnRYf1ZujYSMTU5HtK+cB3ztC+fmDCC
	2xfGtHDtzncKOvmOl5amcKtY9L547bKUu+oW8EBA9dXhul78QUHFfrh49rcXEUt2MQv0WNp3LCO
	MZe+0qLdAOQMrdLqckFAhB7wseLTiZ3Ts5bYIzw==
X-Gm-Gg: AYBFou1LfBKcwabLiZ09Ee9stXAU7+EdQzs53K+tqnK59IFqxizMoXzMdMVQ3zC1nAI
	BApsz8F+vnUM7QkXaoLroQtn6IUnGhXJE2hODrGjA6E0sB0U9Q1QtAkWRR1Sn18z+cFegoFCyL+
	arXV61bx39xzfCphu9ptlrGU63GiZ9Knv0sfT8ZBCwCNUan5TkQQoIW047qEkbN8v1u1x/4Fvtu
	fkW93kKEt0Fbc8och6vA/J9J1dMUuoeXO45X59QrUSzzBGFbc6PvmfuNvj0W16pSJZyTKjJzq3s
	ZBphiZoR8mZpL3OI7bBgGa/HK8IPoJnoH0VYYQcAZ+B9qRK4Ye0AG1JeQA==
X-Received: by 2002:a17:906:2099:b0:c33:392f:7ca1 with SMTP id
 a640c23a62f3a-c33392f909emr321305766b.17.1791801631828; Mon, 12 Oct 2026
 03:40:31 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 12 Oct 2026 06:40:30 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 12 Oct 2026 06:39:48 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Johan_Fredrik_=C3=98hman?= <johanfo@gmail.com>
Date: Mon, 12 Oct 2026 06:40:30 -0400
X-Gm-Features: AclHuK88Pequu2FVCYhXJAd-j6FIu9RDHe5YZN7vRxLnoGZSeKyaTSsWbFnzJFY
Message-ID: <CADB9d9quPCyTgdhciT2ROr087pArJq_zormpGT7TMCf_ebFTiQ@mail.gmail.com>
Subject: [BUG] mt76/mt7921e: MT7922 kernel panic in mt76_rx_aggr_reorder after
 AP change (7.2.5)
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Hello,

I am reporting a system-wide kernel panic on a MediaTek MT7922 PCIe Wi-Fi
adapter using the in-tree mt7921e/mt76 driver. The panic occurs in
mt76_rx_aggr_reorder+0x7d/0x390 while the napi/phy0-0 thread processes RX.

Observed on 12 October 2026. The panic screen's decoded report shows repeated
disconnects, authentication attempts, and changes between access points.
The last association completes at 17370.455804; the page fault occurs at
17370.858803, about 0.4 seconds later. This suggests an association/roaming
trigger, but the underlying defect has not been established.

Expected: Wi-Fi reconnection or roaming should not crash the kernel.
Actual: a supervisor read faults at 000000005420e008, followed by
"Kernel panic - not syncing: Fatal exception in interrupt".

System:
- Arch Linux / Omarchy, x86_64
- Kernel: 7.2.5-3-omarchy #1 PREEMPT(full)
- Kernel build ID in panic: 240f9ec5a8022b1a7f578b0199033bf067658fbc
- Kernel taint: Not tainted
- Board: MSI MAG B650 TOMAHAWK WIFI (MS-7D75)
- BIOS: 1.R3, 09/07/2026 (as printed by the panic report)
- Wi-Fi: MediaTek MT7922, PCI ID 14c3:0616, PCI address 0000:0f:00.0
- Driver: mt7921e; modules are marked intree: Y
- linux-omarchy package: 7.2.5-3
- linux-firmware-mediatek: 20260810-2
- Firmware HW/SW: 0x8a108a10, build 20260724143257a
- WM firmware: ____000000, build 20260724143402
- NetworkManager: 1.58.1-1
- wpa_supplicant: 2:2.12-1

Context and testing:
The saved journal shows 6 GHz disconnections and authentication timeouts
before the panic. The decoded panic shows further AP changes after the saved
journal ends. The system had resumed from S3 earlier in the same boot; a
connection between suspend/resume and this panic has not been established.
After reboot Wi-Fi was connected on 5 GHz, with Wi-Fi power saving off.
That is only a post-reboot observation, not a verified workaround.

No controlled reproduction, kernel bisect, comparison with an unmodified
Arch/mainline kernel, or test on a newer/LTS kernel has been performed.
The last known working version and recurrence rate are unknown.
The journal and pstore did not retain the panic; this trace was obtained from
the blue panic screen report.

Diagnostic excerpt:
AP MAC addresses are replaced consistently by AP-A / AP-B / AP-C, and the
client MAC by CLIENT. Unrelated firewall packet logs and the repeated
post-oops register dump are omitted. Kernel addresses and register values
below are unchanged.

[17346.153043] wlp15s0: disconnect from AP AP-A for new auth to AP-B
[17346.299567] wlp15s0: authenticate with AP-B (local address=CLIENT)
[17346.468792] wlp15s0: send auth to AP-B (try 1/3)
[17346.475978] wlp15s0: authenticate with AP-B (local address=CLIENT)
[17346.475981] wlp15s0: send auth to AP-B (try 1/3)
[17346.480717] wlp15s0: authenticated
[17346.480896] wlp15s0: associate with AP-B (try 1/3)
[17346.518258] wlp15s0: RX ReassocResp from AP-B (capab=0x1511 status=0 aid=1)
[17346.555936] wlp15s0: associated
[17346.801485] wlp15s0: Limiting TX power to 23 (23 - 0) dBm as
advertised by AP-B
[17363.990483] wlp15s0: disassociated from AP-B (Reason:
8=DISASSOC_STA_HAS_LEFT)
[17369.438353] wlp15s0: authenticate with AP-A (local address=CLIENT)
[17369.451322] wlp15s0: send auth to AP-A (try 1/3)
[17369.454530] wlp15s0: AP-A unexpected authentication state: alg 0
(expected 0) transact 1 (expected 2)
[17369.561922] wlp15s0: send auth to AP-A (try 2/3)
[17369.668048] wlp15s0: send auth to AP-A (try 3/3)
[17369.772048] wlp15s0: authentication with AP-A timed out
[17369.854589] wlp15s0: authenticate with AP-C (local address=CLIENT)
[17370.344060] wlp15s0: send auth to AP-C (try 1/3)
[17370.375701] wlp15s0: authenticate with AP-C (local address=CLIENT)
[17370.375706] wlp15s0: send auth to AP-C (try 1/3)
[17370.404568] wlp15s0: authenticated
[17370.406051] wlp15s0: associate with AP-C (try 1/3)
[17370.420427] wlp15s0: RX AssocResp from AP-C (capab=0x1931 status=0 aid=10)
[17370.455804] wlp15s0: associated
[17370.455826] wlp15s0: Limiting TX power to 30 (30 - 0) dBm as
advertised by AP-C
[17370.858803] BUG: unable to handle page fault for address: 000000005420e008
[17370.858808] #PF: supervisor read access in kernel mode
[17370.858810] #PF: error_code(0x0000) - not-present page
[17370.858812] PGD 0 P4D 0
[17370.858816] Oops: Oops: 0000 [#1] SMP NOPTI
[17370.858819] CPU: 7 UID: 0 PID: 1072 Comm: napi/phy0-0 Not tainted
7.2.5-3-omarchy #1 PREEMPT(full)
240f9ec5a8022b1a7f578b0199033bf067658fbc
[17370.858823] Hardware name: Micro-Star International Co., Ltd.
MS-7D75/MAG B650 TOMAHAWK WIFI (MS-7D75), BIOS 1.R3 09/07/2026
[17370.858825] RIP: 0010:mt76_rx_aggr_reorder+0x7d/0x390 [mt76]
[17370.858836] Code: 0f 84 02 02 00 00 48 83 ec 38 48 89 f9 f6 47 42
04 0f 84 9f 00 00 00 0f b6 47 43 83 e0 60 3c 20 0f 84 9f 00 00 00 41
83 e0 0f <4e> 8b 04 c2 4d 85 c0 0f 84 8e 00 00 00 48 89 5c 24 28 49 8d
58 18
[17370.858838] RSP: 0018:ffffd4f8cde43c50 EFLAGS: 00210202
[17370.858840] RAX: 0000000000000000 RBX: ffff8ee52b9d8c00 RCX: ffff8ee52b9d8c00
[17370.858842] RDX: 000000005420e000 RSI: ffffd4f8cde43cb0 RDI: ffff8ee52b9d8c00
[17370.858844] RBP: ffffd4f8cde43cf8 R08: 0000000000000001 R09: 0000000000000081
[17370.858845] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8ee3c9022160
[17370.858847] R13: ffff8ee2ce9a104a R14: ffff8ee3c9025420 R15: ffff8ee3c9022160
[17370.858848] FS: 0000000000000000(0000) GS:ffff8eeb3e8f1000(0000)
knlGS:0000000000000000
[17370.858850] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17370.858852] CR2: 000000005420e008 CR3: 0000000830422000 CR4: 0000000000f50ef0
[17370.858854] PKRU: 55555554
[17370.858855] Call Trace:
[17370.858857] <TASK>
[17370.858859] ? srso_alias_return_thunk+0x5/0xfbef5
[17370.858864] ? srso_alias_return_thunk+0x5/0xfbef5
[17370.858866] ? mt76_dma_rx_fill_buf+0x1c0/0x540 [mt76
c44365206951c17d7d62acaed7f5e6dcc1343983]
[17370.858873] ? btusb_probe+0x1b0/0xf0c [btusb
cddbd3baf024205584c96015ae7120429c8e9cfb]
[17370.858878] mt76_rx_poll_complete+0x449/0x600 [mt76
c44365206951c17d7d62acaed7f5e6dcc1343983]
[17370.858888] mt76_dma_rx_poll+0x342/0x700 [mt76
c44365206951c17d7d62acaed7f5e6dcc1343983]
[17370.858898] mt792x_poll_rx+0x53/0xf0 [mt792x_lib
e43751b1bec9ce6f75efb8425f032583f3fc9ee7]
[17370.858904] __napi_poll+0x12c/0x220
[17370.858909] napi_threaded_poll_loop+0x24e/0x2a0
[17370.858912] ? srso_alias_return_thunk+0x5/0xfbef5
[17370.858917] ? __pfx_napi_threaded_poll+0x10/0x10
[17370.858919] napi_threaded_poll+0xe9/0x130
[17370.858923] kthread+0xe4/0x120
[17370.858927] ? __pfx_kthread+0x10/0x10
[17370.858930] ret_from_fork+0x2bd/0x350
[17370.858933] ? __pfx_kthread+0x10/0x10
[17370.858936] ret_from_fork_asm+0x1a/0x30
[17370.858943] </TASK>
[17370.859059] CR2: 000000005420e008
[17370.859062] ---[ end trace 0000000000000000 ]---
[17370.859090] Kernel panic - not syncing: Fatal exception in interrupt
[17370.859300] Kernel Offset: 0x17a00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Please advise whether this matches a known bug and which upstream kernel
version or diagnostic test would be useful next.

Report prepared with GPT-6 via Codex, using the user's panic report and
read-only diagnostics from the affected machine.
