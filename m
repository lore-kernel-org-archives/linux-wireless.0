Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E4331ECC;
	Thu, 13 Aug 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633072; cv=none; b=ohW5n2FQviUUk/SJJ0WBugpz7qz97NCjKwndJO7g+6i9dA0IfeG+ggMAOJzZGEIl2568lH95WYi87C+96d6yuA54oyDy5WtAiBpdcGS4yClM/ScIIhFcob8+QOvnvYRZqfB2i0P2n12sRGj3sDAvqh2dB8YJ3NXRdNhGgM5BCIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633072; c=relaxed/simple;
	bh=Hi0wEwSm5Rv+zIrod0GyfrzgDdb6x8prLNKStkLb8fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzshOtBZZETh0QYMlHY82IFvHZr0w9thryFoPVUyLaB/39T66WAKbNg3QYqkcdQ2c34H2wyIArdD6HrRG+RILNk57/l+3xqR6X6SIiCqXeyd5lygRGnRqH7DNc1d79sy4aPucqo4OzaCEI486+Q1aWp6mr+FkBsUDvQHvGOdwMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=GgOrDE6k; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="GgOrDE6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1786633065; x=1787237865; i=spasswolf@web.de;
	bh=r/yrGNlCDgNl8g9aGKGMo1rcdSYZ4GZXwom8+x3zBgE=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GgOrDE6k2OEB/oo1/sm5FIUuECNV/BoXVwahO52Jycy1SCWHFwQHZE2eUDn6GhfT
	 5XGWIzEjecfFgQ0YpzceokjSGXG7o/P0lr2QMMCtt1NPAPnjS+PH3cxBnA2lgfv0I
	 PQumpEj9rKVJd/n4r6u5vFjcy0TlbT4P+eHcdtApp5hwpclwXCpbcq6A8kBDkMIMo
	 TqF2i1MDb3KtrlYwACgvBQTCOmFqC4iVZsSGbVJQhFOPM9CW6FRMEU2u794vfolUc
	 Ej4nSBJXNGDUdUQl+lHStBVutLfkJWNIRSnJs2qO74BjXjzg4v1Ev3E4H1IOk8QKb
	 gHrpDezoeymiAWe0bw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MAtsj-1wjHOL3FbF-0028bW; Thu, 13
 Aug 2026 16:57:44 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: Emery Hsin <emery.hsin@mediatek.com>
Cc: Bert Karwatzki <spasswolf@web.de>,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-next@vger.kernel.org,
	jb.tsai@mediatek.com,
	Deren.Wu@mediatek.com,
	Leon.Yen@mediatek.com,
	Quan.Zhou@mediatek.com,
	Ryder.Lee@mediatek.com,
	Sean.Wang@mediatek.com,
	linux-mediatek@lists.infradead.org,
	litien.chang@mediatek.com,
	lorenzo@kernel.org
Subject: [PATCH] wifi: mt76: mt7925: remove wm2_complete_mask from mt7925_irq_map
Date: Thu, 13 Aug 2026 16:57:40 +0200
Message-ID: <20260813145741.8047-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To:  <20260612075042.2577193-3-jb.tsai@mediatek.com> 
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:y9xZWd1xlGhxtnEoOO3b6kGGh7R4lKUFirM4FRmNn3nv4zsMoBJ
 NrTOzqLjSEfAUKzuY9qu7mFS6ncqJZmmXLa8r5eYAxSqdxv47NonJYpOopVKIntf7jq/rqH
 QuejFlpiom/QUW1ULnfgnAUeyS4r6Mhj2lX4Qw6+mSmjFji2qp+B+GzhCr2bKAwrN2xj1bF
 WxPnZIwhZrz2LScDmAw8Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hcjqk0DQ0oo=;g5mZI43kyAhtHjmW81RhWjU+ksY
 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
 dYzWepIxLnXj2MoQ==

Commit
c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks with per-ch=
ip definitions")
introduces a non-NULL wm2_complete_mask element to mt7925_irq_map. This
gives a NULL pointer dereference error when resuming from hibernate:

[ T2001] BUG: kernel NULL pointer dereference, address: 0000000000000a98
[ T2001] #PF: supervisor write access in kernel mode
[ T2001] #PF: error_code(0x0002) - not-present page
[ T2001] PGD 0 P4D 0
[ T2001] Oops: Oops: 0002 [#1] SMP NOPTI
[ T2001] CPU: 5 UID: 0 PID: 2001 Comm: kworker/u128:4 Tainted: G        W =
          7.2.0-rc4-bisect-00876-gc4edf9e3e0e5-dirty #746 PREEMPT_RT
[ T2001] Tainted: [W]=3DWARN
[ T2001] Hardware name: ASUS System Product Name/ROG STRIX B850-F GAMING W=
IFI, BIOS 1627 02/05/2026
[ T2001] Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
[ T2001] RIP: 0010:mutex_lock+0xe/0x30
[ T2001] Code: 75 07 31 c0 c3 cc cc cc cc be 01 00 00 00 e9 79 fe ff ff 66=
 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 65 48 8b 15 94 13 83 00 31 c0 <f0> 48=
 0f b1 57 18 75 05 c3 cc cc cc cc be 02 00 00 00 e9 4b fe ff
[ T2001] RSP: 0018:ffffa53dc250fdc8 EFLAGS: 00010246
[ T2001] RAX: 0000000000000000 RBX: ffff951e8d0e3420 RCX: 0000000000000000
[ T2001] RDX: ffff951f64f145c0 RSI: 0000000000000002 RDI: 0000000000000a80
[ T2001] RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
[ T2001] R10: 0000000000000000 R11: 0000000000000004 R12: ffff951e8d0e3020
[ T2001] R13: ffff951e8d0e2680 R14: ffff951e8d0e0aa0 R15: 0000000000000000
[ T2001] FS:  0000000000000000(0000) GS:ffff952ccc8b3000(0000) knlGS:00000=
00000000000
[ T2001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ T2001] CR2: 0000000000000a98 CR3: 000000050641e000 CR4: 0000000000f50ef0
[ T2001] PKRU: 55555554
[ T2001] Call Trace:
[ T2001]  <TASK>
[ T2001]  ? napi_disable+0x18/0x40
[ T2001]  ? mt7925e_mac_reset+0x2f8/0x390 [mt7925e]
[ T2001]  ? mt7925_mac_reset_work+0x98/0x1c0 [mt7925_common]
[ T2001]  ? drm_sched_run_job_work+0x1c/0x2d0 [gpu_sched]
[ T2001]  ? pwq_dec_nr_in_flight+0x29a/0x3a0
[ T2001]  ? process_one_work+0x199/0x2a0
[ T2001]  ? worker_thread+0x1a0/0x2f0
[ T2001]  ? rescuer_thread+0x550/0x550
[ T2001]  ? kthread+0xd1/0x110
[ T2001]  ? kthread_affine_node+0x100/0x100
[ T2001]  ? ret_from_fork+0x1f9/0x2b0
[ T2001]  ? kthread_affine_node+0x100/0x100
[ T2001]  ? kthread_affine_node+0x100/0x100
[ T2001]  ? ret_from_fork_asm+0x11/0x20
[ T2001]  </TASK>

Remove wm2_complete_mask from mt7925_irq_map to fix the issue.

Fixes: c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks with=
 per-chip definitions")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
=2D--
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net=
/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..d2c0a78ae9f2 100644
=2D-- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -493,7 +493,6 @@ static const struct mt792x_irq_map mt7925_irq_map =3D =
{
 		.all_complete_mask =3D MT7925_INT_RX_DONE_ALL,
 		.data_complete_mask =3D MT7925_INT_RX_DONE_DATA,
 		.wm_complete_mask =3D MT7925_INT_RX_DONE_WM,
-		.wm2_complete_mask =3D MT_INT_RX_DONE_WM2,
 	},
 };
=20
=2D-=20
2.55.0

I noticed that my debian sid system running linux next-20260812 would
resume from hibernation either displaying a frozen GUI or show the
mentioned backtrace in dmesg and freezing seconds after that. I bisected
the issue to commit=20
c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks with per-ch=
ip definitions")
which introduces a non-NULL wm2_complete_mask to mt7925_irq_map.
Removing wm2_complete_mask from mt7925_irq_map fixes the issue in
next-20260812.

Bert Karwatzki
