Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589AD403146;
	Tue, 30 Jun 2026 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817209; cv=none; b=jDx0VF5K9UCLzLWs5JXccrl1KGcwySGd5JO8sd+dHZ0HNjpaXCygxf6MCMELXhqV79q0NFPYuVwt04N+DKKUYKtijdBmu09xwErQlTLcb/AECOroBTKjCxOTPx+GUHTukpWTKCJIpdResniC1dRxOkjXSRY13hwmdKpY3LjHjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817209; c=relaxed/simple;
	bh=53C0hSBqn3/zw2gZnbvrSpHA3r3Vy8iowj7NMITMB+I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OVz+zq08BRWxJC1tU5qqkrSSIxqO7m66NUvNZolXCBlpHPNYViGozt0BdD5IhiIX5ArH8CJjKk7VnMBmsfQTw4ZGvKVrbyj7Jt6GP4x5UN9rG6n3JUhUauK7G5ItQlwvxDwOBOKwH7aeO/R/GbGmNaegGTXd5rcLvWiFn+AbF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHxEq6Ex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHxEq6Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736051F00A3D;
	Tue, 30 Jun 2026 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817208;
	bh=nCZadshr+DzQYVkCBh6cy/RM40zwNi0ZS4nnwSr8GpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BHxEq6ExepayPqMVcba1gAOZBamGomKzGI5/5rbn4FkcDA6n30f9+6e3ho9P8OwWU
	 6+ENTujmQC9oE2fr15f3DfD685ltql5+ulTzniflHu/5xHjg8Eppf3qb9Hh+2qgUDA
	 ME464175cHxtguWUsZhBztIo+dKhzs8PG5IC/96hm29yd4Z0iwNPkTO33p6idcdDp/
	 FjithW/WlildOFWxaLjCMKyGZXhKmpBpkXf96s/l1exvCtkqBxQaNyn0n5UfWOeBNn
	 SVmcV8YVyeBAmrNTxPQHtglqbphZVG5c+ST+4B2ZpMQqg9IQ18aRQQ7t+8J2hG1Npu
	 aIQxG92cvPCBw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:27 +0300
Subject: [PATCH net-next 8/8] wlcore: allocate aggregation and firmware log
 buffers with kzalloc()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-8-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Edward Cree <ecree.xilinx@gmail.com>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Manish Chopra <manishc@marvell.com>, Mike Rapoport <rppt@kernel.org>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org, 
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.15.2

wlcore_alloc_hw() uses __get_free_pages() to  allocate TX aggregation
and firmware log buffers used for software data staging.

These buffer can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kzalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index be583ae331c0..5595f7a1fc0c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6354,7 +6354,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int i, j, ret;
-	unsigned int order;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -6434,8 +6433,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	mutex_init(&wl->flush_mutex);
 	init_completion(&wl->nvs_loading_complete);
 
-	order = get_order(aggr_buf_size);
-	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
+	wl->aggr_buf = kmalloc(round_up(aggr_buf_size, PAGE_SIZE), GFP_KERNEL);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
 		goto err_wq;
@@ -6449,7 +6447,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	}
 
 	/* Allocate one page for the FW log */
-	wl->fwlog = (u8 *)get_zeroed_page(GFP_KERNEL);
+	wl->fwlog = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wl->fwlog) {
 		ret = -ENOMEM;
 		goto err_dummy_packet;
@@ -6474,13 +6472,13 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	kfree(wl->mbox);
 
 err_fwlog:
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
 err_aggr:
-	free_pages((unsigned long)wl->aggr_buf, order);
+	kfree(wl->aggr_buf);
 
 err_wq:
 	destroy_workqueue(wl->freezable_wq);
@@ -6509,9 +6507,9 @@ int wlcore_free_hw(struct wl1271 *wl)
 
 	kfree(wl->buffer_32);
 	kfree(wl->mbox);
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
+	kfree(wl->aggr_buf);
 
 	wl1271_debugfs_exit(wl);
 

-- 
2.53.0

