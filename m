Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4528 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYBGQLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 11:11:00 -0500
Date: Thu, 7 Feb 2008 10:51:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, deller@gmx.de,
	jt@hpl.hp.com, rjw@sisk.pl, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-ID: <20080207155152.GA3025@tuxdriver.com> (sfid-20080207_161107_975828_521AAEF9)
References: <200801131516.34567.deller@gmx.de> <20080202224515.20a09553.akpm@linux-foundation.org> <200802062150.23930.deller@gmx.de> <20080206130448.564f18bb.akpm@linux-foundation.org> <20080206214747.GG32245@flint.arm.linux.org.uk> <20080206135950.d48ffa36.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080206135950.d48ffa36.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:59:50PM -0800, Andrew Morton wrote:
> On Wed, 6 Feb 2008 21:47:47 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > I assume that it's the second BUILD_BUG_ON() which is triggering?
> 
> yup.
> 
> > Given that:
> > 
> > #define MMW_SIZE        37
> > 
> > is not a multiple of sizeof(unsigned long) this is hardly surprising.
> > 
> > If structures are used to define a layout of something and must not
> > contain compiler padding, it must be packed.  Given these structures
> > contain just unsigned char, there's no concerns about >8bit loads
> > becoming less efficient.

Does a patch like this suffice?  I haven't checked whether such a
patch implies that the BUILD_BUG_ON()'s become unnecessary...

Does anyone actually have this hardware to test?

---

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] wavelan: mark hardware interfacing structures as packed

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wavelan.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wavelan.h b/drivers/net/wireless/wavelan.h
index 27172cd..964db3e 100644
--- a/drivers/net/wireless/wavelan.h
+++ b/drivers/net/wireless/wavelan.h
@@ -100,7 +100,7 @@ struct ha_t
 	unsigned short	ha_piop1;	/* Program I/O Port 1 */
 	unsigned short	ha_pior2;	/* Program I/O Address Register Port 2 */
 	unsigned short	ha_piop2;	/* Program I/O Port 2 */
-};
+} __attribute__ ((packed));
 
 #define HA_SIZE		16
 
@@ -202,7 +202,7 @@ struct psa_t
   unsigned char	psa_conf_status;	/* [0x3C] Conf Status, bit 0=1:config*/
   unsigned char	psa_crc[2];		/* [0x3D] CRC-16 over PSA */
   unsigned char	psa_crc_status;		/* [0x3F] CRC Valid Flag */
-};
+} __attribute__ ((packed));
 
 #define	PSA_SIZE	64
 
@@ -292,7 +292,7 @@ struct mmw_t
 #define	MMW_EXT_ANT_INTERNAL	0x00	/* Internal antenna */
 #define	MMW_EXT_ANT_EXTERNAL	0x03	/* External antenna */
 #define	MMW_EXT_ANT_IQ_TEST	0x1C	/* IQ test pattern (set to 0) */
-};
+} __attribute__ ((packed));;
 
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
