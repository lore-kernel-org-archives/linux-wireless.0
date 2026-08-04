Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B6326D55
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844817; cv=none; b=n9mnl/2byt8eNzlH3Pec9H6iGi+/Fc2QIaqq2ZpjVx0GUXkMZya6WW1yozwpB4ikoegLU6cdsTXm0d/P+FjQIeC2pIRIRc1lTRRHxNBffgBdtz1SJKaUn5yAd3xxUhr1xbwS4SumKpBp9VsVM5P70jwGXsBWaP64nbgKDlubEu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844817; c=relaxed/simple;
	bh=FeySs9Jin21k5s/cqffYgru6EWdPWvaF785+FzNA150=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QuT+hlKG4ClsjXoBRdAK2eoilnbaLkzlc1nFFUCUg4mqombJ2LyPXcBt1JDQ+ahwW9cvq4ZHePGTReTcb54qhGjIt+PRy3ZkQUMya6lOitx5hmobp4dHhZqTYomAPzly2T5atG1+E77U5PzEKz3Wl8nhKCdDoS5Xxp0LNluW+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emm7b1Q/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emm7b1Q/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a8e4c77eso4495707e87.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785844810; x=1786449610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iVO/qwuBSDe5f/5RWdWMNeDvOmjgwposxFzhKBIqG+s=;
        b=emm7b1Q/j55xlzIBALs8oCIdKNgxd8d7rkjZNE3z0ivprO3qeFYZVXBY3lZ4Y6D6rK
         ulsQOtI7ecfzGDtTjM1pqGeJJu1L7bYdx8vlgzJH0ZyXKKjvc9ZnTCHgUIm5FbeAXLK3
         70AcwezTlQEFDCJ9I2WZkV6X1lIN0yvM7O8Jcb9WMM3StGA94x9+q2CKRv8Gz1C8kPug
         MrWkP91eCh4kRCZACsARGS5LsNxsGCa5u1IqG0n0XGHX/9sKcauNIgdKXtt70cFvJ+Sz
         qby2pcGHzaq6O+bj3DC8NX7zgA56HOInHol3sD35paHdiJhOpl6W4uTRk5FPaVIFwfSs
         9vnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785844810; x=1786449610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iVO/qwuBSDe5f/5RWdWMNeDvOmjgwposxFzhKBIqG+s=;
        b=Cl+pvy/SW8t1Cjmy4O2I/fsuWJj/Zl9rPlpUSCQ5wBpgYqlx4JSzUK4O2xNWpyRUUq
         Ol4h/HHypQLoDpJVRT3kBOlW/lhzk0Kg3MDLnBz/4d1a1Dz5kLIFLw7nTUyc7tyItu4y
         NpP4kWePGnr5QI87aaamBzKll5JgvBaBpu671Klx1V0k6Km1JM0UWeuXGHz4wJOLCDwU
         bygYR7IoSy+Yb8BDt5acOfzgt+3qAORxgBCksN/1OetxKnRltjqdd1W1Yp0XkhfhCJ6i
         LMrgOB/2s5l1olat9MWvs1kmGmSVsVGq1pnajAHWmjmUfJEtMHnDOgvwis8PVtPCDu03
         hMcw==
X-Gm-Message-State: AOJu0Yxclq5iV9QPePtCY2wFZcj2O8srEzH/EnNmih1HqR+ddBmGeEvT
	5WG49Vj1iQfGGaiqvb0YMunuh3+U57GKMdKrmkbgnk61U/xAnVrhl07EbIHiWE75HI0bcw==
X-Gm-Gg: AR+sD12Pgm0YdqgfiMudDTMhnW6Cmq5nR7y2gSUJbTvt4G1/pIs405tRy59YQbGxBsm
	RxN2ibp/50nMEEp2OmNSEqRQfpcLto+Bpwi/kIvcZXTp4BNsLn33pjMWJAh7Rc0I1PNe5wB5teF
	UyY0jnBjlvxU6w+/e8VLSbJ1DDH0oZ1A17zUxbXPUEsUUf5NqOzIjbfiX2dZM0cp5pa1xiwFVGH
	lObYK8MZq4MhwEBEoOoAkX0d+8Ug4C7kVbXv2JQedDlPzUcS4e1c+NIcBeZmpAi0ZF2OflObpYj
	MeqbqdiwF0S4uYZi19hDUTqXfSv+sCJsuRs34t+9S3x0QlwpPrl4tVNEJ30cXB4boBWwzgR1fs0
	eKBjbXToqiRKpUQOeHXGq5U6z3PcBhzLBJcwXzFV2NJGB0U+07Jls3RvmoiFvgBF/ixEfycrHDx
	4GKMAPjuzguu4UKXddnb2YWeU7wwxvdnwG92secsbn7Zl6pm6B/gumdVT3VBz5+rk6ACKc0iQ=
X-Received: by 2002:a05:6512:138e:b0:5b0:1dd0:f238 with SMTP id 2adb3069b0e04-5b2e4f1b067mr3121001e87.2.1785844808457;
        Tue, 04 Aug 2026 05:00:08 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e2441e66sm2620717e87.48.2026.08.04.05.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:00:07 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eric Biggers <ebiggers@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing device"
Date: Tue,  4 Aug 2026 17:00:04 +0500
Message-ID: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 13b7e6a96a005c656d38f3da51581deaf9866375.

That commit made mt76_dma_cleanup() disable every RX NAPI instance before
deleting it, to silence WARNs in __netif_napi_del_locked() and
page_pool_disable_direct_recycling() seen when unloading mt7915e with an
MT7916.

On mt7921e and mt7925e the same instances are already disabled earlier,
in mt7921e_unregister_device() and mt7925e_unregister_device(), which
only afterwards call mt792x_dma_cleanup() -> mt76_dma_cleanup().  Each
instance is therefore disabled twice, and napi_disable() is not
idempotent: on return it leaves NAPIF_STATE_SCHED and NAPIF_STATE_NPSVC
set, so the second call spins in usleep_range() forever, waiting for bits
that nobody will clear.

mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path, so
this is hit on every reboot, poweroff and module unload.  It is silent:
the stuck task keeps sleeping and rescheduling, so neither the hung task
detector nor the lockup detectors fire, and the last line on the console
is "systemd-shutdown[1]: Rebooting."

  task:modprobe        state:D stack:25720 pid:7954  tgid:7954
  Call Trace:
   <TASK>
   __schedule+0x11b8/0x26d0
   schedule+0xe7/0x2f0
   schedule_hrtimeout_range_clock+0x218/0x330
   usleep_range_state+0x133/0x1b0
   napi_disable_locked+0x37d/0x5f0
   napi_disable+0x43/0x80
   mt76_dma_cleanup+0x2b4/0x860 [mt76]
   mt7921_pci_remove+0x17f/0x350 [mt7921e]
   pci_device_remove+0xb6/0x1e0
   device_release_driver_internal+0x38d/0x540
   driver_detach+0xd0/0x1b0
   bus_remove_driver+0x127/0x2d0
   pci_unregister_driver+0x2a/0x280
   __do_sys_delete_module+0x36a/0x5b0
   do_syscall_64+0x11c/0x6d0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Dropping the two driver-side loops instead was tried and rejected: with
them gone, the RX poll can reach mt76_token_release() via
PKT_TYPE_TXRX_NOTIFY and mt7921_mac_tx_free() while
mt76_connac2_tx_token_put() is running idr_destroy(&dev->token) outside
token_lock, which is a use-after-free rather than a hang [1].

Revert for now, so that reboot, poweroff and module unload work again.
The WARNs on mt7915e are a less severe problem than an unbootable
machine, and fixing them belongs in the drivers that delete the NAPI
instances, where each one can pick a point that is safe for its own
teardown order, rather than in the shared mt76_dma_cleanup().

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web.de/
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221818
Link: https://lore.kernel.org/all/20260730050428.GA73812@sol/ [1]
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

Sending this because the regression is now in its second week with four
independent reporters, and the two-part alternative (this revert plus
napi_disable() added inside mt7915_unregister_device()) needs MT7916
hardware that I do not have.  I deliberately left the mt7915 side out;
Nicolas is best placed to do it, since MT7916 is what he reported
against.
 
Verified on 7.2.0-rc5 with KASAN and lockdep enabled, MT7922 / mt7921e:
before the revert 'modprobe -r mt7921e' hangs (backtrace above, taken
with sysrq-w) and the machine never gets past "Rebooting."; after it,
module unload and reload, reboot and poweroff all work again.
 
The hang was independently bisected to the same commit by Bert Karwatzki
on MT7925 and reproduced by Devin Wittmayer on MT7927 and MT7922, and
Eric Biggers saw it on mt7925e as well.

 drivers/net/wireless/mediatek/mt76/dma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 322041859217..f8c2fe5f2f58 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1189,10 +1189,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 	mt76_for_each_q_rx(dev, i) {
 		struct mt76_queue *q = &dev->q_rx[i];
 
-		if (!mt76_queue_is_wed_rro(q)) {
-			napi_disable(&dev->napi[i]);
-			netif_napi_del(&dev->napi[i]);
-		}
+		netif_napi_del(&dev->napi[i]);
 		mt76_dma_rx_cleanup(dev, q);
 
 		page_pool_destroy(q->page_pool);
-- 
2.55.0

