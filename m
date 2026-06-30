Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F8140E8D8;
	Tue, 30 Jun 2026 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817179; cv=none; b=iDZDxkSGvbNSX1GANKVtibMLujYAxDL6Zx9o2Lt8/OjionVT/AY9N7qHFGfYpnnHzhDtK8WPDyK9cGgqv/bfWR6yoTSCdhsbAsDX7X2oSVMy12ZowrJyWk5ZG5v+nVO+QsDJvUI/Gao0aR0jDF4eV5kb02noePzRkH4GhbCc29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817179; c=relaxed/simple;
	bh=aand3RgNd4Cf6AAS8azBi8dkpD1wIzGiaaeMK7kxPAo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJVBt38mOHIiECCwH/zcSWBeptv+sLTkm33PgoTyopHVCkX7q2+0lt0vwnj23IcXlqo8KMi6POHVj76uIUia8+1dHEdjw4z5T9jNnLPtuWE5Tsr/er3AqAQMR2fENGpqbTX3Xr8ErjmFz+vcy5LbQX4x+rmVTTcinDQvG8SPPvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXQEF3aH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXQEF3aH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D61F00A3D;
	Tue, 30 Jun 2026 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817177;
	bh=KN3v4O8jkhd6Mt2HpgZaziumJD8qk36FkI+IylasYd4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MXQEF3aHWSiWNFSvYXHU4R7tW6cLU800PWaoSIs368VJxA7phfv+Es8c+cLkEeAW6
	 N+cXvy7GWxnDbC1bFm9jgfCrZuJ7NcmOzPRxV0f8rFe0NonrUKVi/oDpm1r0R9GiMH
	 cFOmtV0Vf+osCftv3+z9BekM2fYxe3pkef2/XzhRaonSJCjH2k1BUQb+abz3ksERB5
	 ID+PK5GmcE2FHvH8VaVrrDkXHHS9PnbWWtmKluZc/es6TuUdTPfONxggTOYT41WBK/
	 yoD9s2qt4xuVYdBtBHU1XDZGLStlv3wqrZawLDg0DkelNXb1Y5TLnaXGaGmtkKIZNf
	 utF9NJfRkg01A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:21 +0300
Subject: [PATCH net-next 2/8] bnx2x: use kzalloc() to allocate mac
 filtering list
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-2-672162a91f37@kernel.org>
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

bnx2x_mcast_enqueue_cmd() allocates memory for mac filtering list using
__get_free_pages().

This memory can be allocated with kzalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 07a908a2c72f..d560524d317d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -26,6 +26,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/crc32c.h>
+#include <linux/slab.h>
 #include "bnx2x.h"
 #include "bnx2x_cmn.h"
 #include "bnx2x_sp.h"
@@ -2664,7 +2665,7 @@ static void bnx2x_free_groups(struct list_head *mcast_group_list)
 				      struct bnx2x_mcast_elem_group,
 				      mcast_group_link);
 		list_del(&current_mcast_group->mcast_group_link);
-		free_page((unsigned long)current_mcast_group);
+		kfree(current_mcast_group);
 	}
 }
 
@@ -2713,8 +2714,7 @@ static int bnx2x_mcast_enqueue_cmd(struct bnx2x *bp,
 				total_elems = BNX2X_MCAST_BINS_NUM;
 		}
 		while (total_elems > 0) {
-			elem_group = (struct bnx2x_mcast_elem_group *)
-				     __get_free_page(GFP_ATOMIC | __GFP_ZERO);
+			elem_group = kzalloc(PAGE_SIZE, GFP_ATOMIC);
 			if (!elem_group) {
 				bnx2x_free_groups(&new_cmd->group_head);
 				kfree(new_cmd);

-- 
2.53.0

