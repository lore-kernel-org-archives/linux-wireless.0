Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483BB40312F;
	Tue, 30 Jun 2026 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817199; cv=none; b=WUO4Cy5d29lO7kqA/ftc3aJ+W6i18sYoJbatsGU4Lfuw2M+bJ55CQqvstag+pFbx/HvTsUjJE7f864swKs9JWa/5XrXKWPaisncjJWLUJpG9+eK7rpdAOz/29VJMTtc66hVs04LrE1MQxY6P8thlKtpM24t8TrPigbEFFMPGutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817199; c=relaxed/simple;
	bh=cI1geR1Z3LlHw8kjLeNgMyLlNWarKAIvNJA4UcMfQlQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t8kAv56EgxvDGPahPz3EJXJGGs2i5yMBpPUZ7tYDD4h6MRrJIjRO6g2SjZ+JpkV4vZePqWP71I4KmyjN/QBm+jCMVlDPwD4O1pUB/CrIjFzzB4ofRNh4Rs12QKfapLw+/5tYlblZfr4SgP4Mb4MPXq5BBLMBg0vLc7YWiTx0FK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+l60L7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+l60L7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617C81F00A3F;
	Tue, 30 Jun 2026 10:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817197;
	bh=uoX4qX+FZWfnshgsq0X7cWNdSoKNRRVi845f4JIWs1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z+l60L7wn/PShGQKOVf1uhUaR8+VJHm56bmboZldAjfa5+rWFzL+mzZyxkjjooadV
	 wsf1HlrnDhCLt1VCQhMO057gNkL4/ki0eS/5OYX9/9ZwvhGEhpKb29+Gm8Remz6d1B
	 Rmw9MS+PDoCRERuT8V6DQMMADlSyqJGDnomFNnSdgDlNF3cRw5cFcdPMrzAFDKnEAH
	 0XRtlJyBXyq0BuiKqcIxChmIVmPvNkYVA6aM/GsMSFtH6N7RDP/AuEG4GPSkJoO8uY
	 mpbzYCwoD5Pw010DnINlP+QgJtqiDzrYGbzBGVg3vPImYTt0vDejn1AmTXPB2q2pgb
	 nqljjBe2Hkszg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:25 +0300
Subject: [PATCH net-next 6/8] sfc/siena: use kmalloc() to allocate logging
 buffer
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-6-672162a91f37@kernel.org>
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

efx_siena_mcdi_init() allocates a logging buffer for MCDI firmware
communication diagnostics.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/ethernet/sfc/siena/mcdi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 4d0d6bd5d3d1..048c1e6017c0 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -7,6 +7,7 @@
 #include <linux/delay.h>
 #include <linux/moduleparam.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include "net_driver.h"
 #include "nic.h"
 #include "io.h"
@@ -73,7 +74,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	mcdi->efx = efx;
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
-	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
+	mcdi->logging_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
 	mcdi->logging_enabled = efx_siena_mcdi_logging_default;
@@ -116,7 +117,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	return 0;
 fail2:
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)mcdi->logging_buffer);
+	kfree(mcdi->logging_buffer);
 fail1:
 #endif
 	kfree(efx->mcdi);
@@ -142,7 +143,7 @@ void efx_siena_mcdi_fini(struct efx_nic *efx)
 		return;
 
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
+	kfree(efx->mcdi->iface.logging_buffer);
 #endif
 
 	kfree(efx->mcdi);

-- 
2.53.0

