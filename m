Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC23181334
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788712076; cv=none; b=iq79gV/RY0UnHmK+zZu6/tPwH6DnZu9weBs+u23Q6LlUlCnpqKSEAdwBPhprKSLXTlLHXYGjtG0gDpUnn5ii0+H/ZlPk/lC/Y8ZYxUNEe2y+69H+Lq/SjafYe8hOl6YNpaIn0Rg5F6YJ/s35h/KzLEjPXMGH3xN0YwXMjmdls3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788712076; c=relaxed/simple;
	bh=9F594YY0it0MVBX9LgL792X9E5/i+/92gmW+BhDBfAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1TT5ktPY/OnOeN29CeLi2Tt6IukyzfHncajWDeZk3dgfZrEWrAtxgeNXwddis09cVms1r2PGzhBmW5dbAID3k9GSpNthkBDmPjcaiDT6ceVUvMiOcvFOUmej+CxTUUtEhXrXH5evLzIfkXZLknUi+m5FvEmgchYh8X6k+8xExk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqWWYBeo; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqWWYBeo"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66fb8a78ad2so2820259d50.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 09:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788712073; x=1789316873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1P58tmm27oZj97JIqTmkOt9YdHoXj6WKm2RnTpP1E3Y=;
        b=HqWWYBeoN6UIEfmiMoPk4KkPUJGJYz3LwmE36JEC7cBVDqifyV+NbzFoRdDGJHgtuY
         nNtXQ9QQHW2j2Ts+HW7UXecCOZ0+dgA478SiyX+6Hyk2Dye4SpxgwHeKiwXkb9K4qQOu
         DCYB9cn1w+3TbmPKMVLtEffObyfhWr4yuNmXzAyDudJt/zAZHxRhHyX1N8tv09F+RtGj
         IMsdFyLh0l0AsKjASMEQRhLM/AeuAEckV8InHbarFdoANCWbaIDTQxhPkDy36T/l1Cd+
         uEzRqAt+qDmlcx5JgWCgG7lXGXjWWXLaTL9Xyv/3dhzlhtAVYnwJlCmRhBj5/jiZBsEz
         rbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788712073; x=1789316873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1P58tmm27oZj97JIqTmkOt9YdHoXj6WKm2RnTpP1E3Y=;
        b=Rs2hUfV0IK/zskzD/QZKL4drpeLg/TfGJR/1LmGEqqChpViRAnhCFH3dO3w/HpVhYW
         jlIPWILCxI/jXouLj/MF59+g8KaSl28d3NVcPD5KUAtxYX57r2H5yoUO1x98sMXeK6mM
         E3qOrD1ZA5U1q9RbCOr3NEcQ8tr9YykzB42uOn0AoVsENFw1UI2XgzUUi2Iac0pcZcsi
         S6rMXuQ666GF5wIzwnHPearxeUYL16nsMHQ6lCK8fN8P5ui6RX3GTXLPGYm1I8Cuabof
         RDXXtEQkeLdGwNe3YDCOsteLO4Zbzm0g4WXygUEDBAPnuT9gfkwfX6vX/VvbgDPjSFpd
         PGUA==
X-Gm-Message-State: AFuF++lf5ZMFXGX8C/6sIBzmK9dJHj14yPY8I+wUcIDdScWDEsFGYyvS
	daTjcKrGjYbDlO4HygQTnuPsWzXqqJGN/HZpU3pj6264In+WkTprJiGvbShsYRbQ
X-Gm-Gg: AYBFou0wQ72sKoIL178ZI65lM/ad+2Fe6BY6QhLbwQDV4iLUTIIAC41BcI8oK0Cgate
	VCSiY8tZrrlpVEVutpBHqg0lGCBcwdb9cij0aihTHMoxNOOcM6e2AywvXIRRLl0HIQ+Eyk5Bgth
	3yb/CNbHnsn30anw4gtJkVv+uaH6VE8pCNdnVBMJ7k1fuGmPDgzU2vy8YjKXdmzeV5SaiG4mBVI
	wHMEYTUWsU0OZZtYFPE/1qXJewSYRk0T7Xfn6n8U80JGtwUMNFtStNjXMmHbc0bfVqk6IZgAhac
	ImCAiP1XW4tax5yQNv0MsE7kyHeFovALvwQmUSavuOHH9vjPkVA0dRloFB/EK1kUYyoybiZuyA/
	etzsEFJkuAdJAVpvc+bX/fzzK70r3DVpd7DUWXlaeIBf2iW8HELyBX+pCJ04GfYXmyiTjk/XCum
	+8Lced6h1uGhpMmKhvrV6ZJtF89IAb2ePSXDnMK7VB90RaAt+U74sdDMwEMNvd7DoJLkptz+5cE
	QAtGCG4MVBr4+Bfl+7rCf6svOG/XCYCqTHooocrZoX/wxBczonXs76e8+nbD8kns5e8Qg5ZOg==
X-Received: by 2002:a53:9004:0:b0:66f:c1bc:409c with SMTP id 956f58d0204a3-66fc1bc4895mr2398226d50.95.1788712073325;
        Sun, 06 Sep 2026 09:27:53 -0700 (PDT)
Received: from toolbx (c-73-124-82-74.hsd1.fl.comcast.net. [73.124.82.74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb7c7e8d7sm5759874d50.14.2026.09.06.09.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 09:27:51 -0700 (PDT)
From: Vladislav Rysin <vrysin@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Subject: [BUG] mt7925e/MT7927: RX page_pool buffers stamped every 16 bytes, corrupting skb_shared_info->frag_list -> #SS in kfree_skb_list_reason
Date: Sun,  6 Sep 2026 12:27:42 -0400
Message-ID: <20260906162742.15333-1-vrysin@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I am hitting a reproducible kernel panic with an MT7927 (Filogic 380) card on
mt7925e. Four panics over five days, all with byte-identical registers. I have
analysed two vmcores and believe I have the mechanism, though not the culprit.

Hardware / software
-------------------
Dell Precision 5820 Tower, BIOS 2.48.0, 250 GB RAM
MEDIATEK MT7927 802.11be 2x2 [14c3:7927], subsystem 105b:e104
  behind a dedicated root port (b2:00.0 -> b3:00.0), PCIe 8GT/s x1
  (LnkSta matches LnkCap; UESta clean, no AER events)
driver: mt7925e, MT7927 raw CHIPID=0x0000, forcing chip=0x7927
firmware: linux-firmware-20260810
  HW/SW Version 0x8a108a10, Build Time 20260414133750a
  WM Firmware Version ____000000, Build Time 20260414134255
link at time of crashes: VHT80, 5745 MHz, 866.7 Mbit/s, VHT-NSS 2 (not EHT)

Reproduces on:
  7.2.3 vanilla (in-tree mt7925e, kernel Not tainted)   <- crashes 3 and 4
  7.1.12 and 7.1.10 with the mediatek-mt7927-dkms 2.14 backport <- crashes 1, 2

Uptime at panic: 22h34m, 27h55m, 4h53m, 8h50m. Traffic-dependent, not timed.

The panic
---------
Oops: stack segment: 0000 [#1] SMP NOPTI
CPU: 6 UID: 0 PID: 808 Comm: napi/phy0-0 Kdump: loaded Not tainted
     7.2.3-300.vanilla.fc44.x86_64
RIP: 0010:kfree_skb_list_reason+0xce/0x260
RBX: 0080a62400000000 RDI: 0080a62400000000 RBP: 0080a62400000000
Call Trace:
 skb_release_data+0x184/0x220
 napi_consume_skb+0x7a/0x160
 skb_defer_free_flush+0x81/0xc0
 napi_threaded_poll_loop+0x14e/0x290
 napi_threaded_poll+0x42/0xb0

A second panic took the same fault from softirq context instead, during the
driver's own recovery, right after an MCU timeout:

 mt7925e 0000:b3:00.0: Message 00020016 (seq 4) timeout
 Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
 mt7925e_mac_reset+0x20e/0x400 -> __local_bh_enable_ip -> do_softirq
 -> net_rx_action -> skb_defer_free_flush -> kfree_skb_list_reason

So the flushing context is incidental; the skb is already corrupt on the
per-CPU defer list. The corruption happens at RX time.

What the vmcore shows
---------------------
Analysed with drgn 0.2.0 (crash 9.0.1 cannot open a 7.2 dump:
"invalid structure member offset: kmem_cache_s_num").

The RX data page carrying the skb is stamped: every 16 bytes, the dword at
offset +12 is overwritten with 24 a6 80 00 (LE 0x0080a624). 256 of 256
16-byte records in the page, and several other page_pool pages are fully
stamped as well (scattered, not contiguous).

The unstamped bytes are genuine payload -- local MAC, AP MAC and the local
IPv4 address are all plainly visible in the same page:

  +0e80  00 00 66 ac f7 29 1b 46 f8 1a 2b 1a  24 a6 80 00
  +0ea0  c0 a8 56 22 01 bb e3 fc 94 66 fb f5  24 a6 80 00

Why the register value is always identical:

  - skb_shared_info sits at the buffer tail, page offset 0xec0 (fixed
    q->buf_size); identical in both dumps
  - frag_list is at shinfo+8
  - the 16-byte-stride stamp lands on shinfo+12, i.e. the *upper* four bytes
    of the frag_list pointer
  - the lower half stays 0, so frag_list becomes 0x0080a624_00000000
  - non-NULL, so skb_release_data() calls kfree_skb_list_reason() on it, which
    does mov 0x0(%rbp),%rbp on a non-canonical address -> #SS

That is why four panics on two kernel versions, two driver builds and two
different call paths produced byte-identical registers. It is not random
memory corruption; it is one field, stamped by one writer, every time.

Interpretation (this part is inference)
---------------------------------------
A 16-byte stride touching only DW3 matches
struct mt76_desc { __le32 buf0, ctrl, buf1, info; } -- info is DW3 at
offset 12. That would mean descriptor-shaped writes are landing on
page_pool RX data pages. The stride, the offset and the constant are
measured; the field identity is a guess and I would not want it taken as
more than that.

I could not identify what 0x0080a624 decodes to as a descriptor word.

Ruled out
---------
 - Out-of-tree driver: reproduces on in-tree 7.2.3 with the kernel Not tainted
 - Hardware / PCIe link: link trains at full capability, UESta clean, no AER,
   EDAC CE/UE both zero. A marginal link does not reproduce a fixed value at a
   fixed offset four times.
 - Wi-Fi power save: disabled at runtime and persistently; panicked anyway
 - ASPM: already disabled by the driver at probe (LnkCtl: ASPM Disabled)
 - GRO fraglist: rx-gro-list is off, so nothing should be building a frag_list
   at all -- consistent with shinfo being overwritten rather than populated

I have two vmcores (1.4 GB and 1.5 GB, 7.2.3, makedumpfile -l -d 31) and can
run any drgn query against them, or provide dumps if useful. Happy to test
patches -- the box reproduces this within a day of normal use.

Note the dumps were taken with -d 31, which excluded the sk_buff slab page
itself; only the data page survived. I am lowering the filter for future
dumps.

Thanks,
Vladislav Rysin
