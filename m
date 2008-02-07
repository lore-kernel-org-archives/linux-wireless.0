Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3416 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935236AbYBGVJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 16:09:38 -0500
Date: Thu, 7 Feb 2008 15:46:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@arm.linux.org.uk, deller@gmx.de, jt@hpl.hp.com, rjw@sisk.pl,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-ID: <20080207204601.GD3025@tuxdriver.com> (sfid-20080207_210947_469856_C2F5FC48)
References: <200801131516.34567.deller@gmx.de> <20080202224515.20a09553.akpm@linux-foundation.org> <200802062150.23930.deller@gmx.de> <20080206130448.564f18bb.akpm@linux-foundation.org> <20080206214747.GG32245@flint.arm.linux.org.uk> <20080206135950.d48ffa36.akpm@linux-foundation.org> <20080207155152.GA3025@tuxdriver.com> <20080207104912.c719deed.akpm@linux-foundation.org> <20080207190842.GC3025@tuxdriver.com> <20080207120238.d169a0d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080207120238.d169a0d2.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 07, 2008 at 12:02:38PM -0800, Andrew Morton wrote:
> On Thu, 7 Feb 2008 14:08:42 -0500
> "John W. Linville" <linville@tuxdriver.com> wrote:

> > Subject: [PATCH] wavelan: mark hardware interfacing structures as packed

> ha_t is still triggering with this patch.
> 
> This incremental patch:

<snip>

> fixes things up.  If forces `union hacs_u' to be two bytes, not four.

OK, so I'll queue this one...'salright?

---

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] wavelan: mark hardware interfacing structures as packed

With assists from Russell King <rmk+kernel@arm.linux.org.uk> and
Andrew Morton <akpm@linux-foundation.org>...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wavelan.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wavelan.h b/drivers/net/wireless/wavelan.h
index 27172cd..9ab3605 100644
--- a/drivers/net/wireless/wavelan.h
+++ b/drivers/net/wireless/wavelan.h
@@ -85,7 +85,7 @@ union hacs_u
 #define		HASR_MMC_INTR		0x0002	/* Interrupt request from MMC */
 #define		HASR_MMC_BUSY		0x0004	/* MMC busy indication */
 #define		HASR_PSA_BUSY		0x0008	/* LAN parameter storage area busy */
-};
+} __attribute__ ((packed));
 
 typedef struct ha_t	ha_t;
 struct ha_t
@@ -292,7 +292,7 @@ struct mmw_t
 #define	MMW_EXT_ANT_INTERNAL	0x00	/* Internal antenna */
 #define	MMW_EXT_ANT_EXTERNAL	0x03	/* External antenna */
 #define	MMW_EXT_ANT_IQ_TEST	0x1C	/* IQ test pattern (set to 0) */
-};
+} __attribute__ ((packed));
 
 #define	MMW_SIZE	37
 
@@ -347,7 +347,7 @@ struct mmr_t
   unsigned char	mmr_unused4[1];		/* unused */
   unsigned char	mmr_fee_data_l;		/* Read data from EEPROM (low) */
   unsigned char	mmr_fee_data_h;		/* Read data from EEPROM (high) */
-};
+} __attribute__ ((packed));
 
 #define	MMR_SIZE	36
 
-- 
1.5.3.3

-- 
John W. Linville
linville@tuxdriver.com
