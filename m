Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761301AbYBGUFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 15:05:17 -0500
Date: Thu, 7 Feb 2008 12:02:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux@arm.linux.org.uk, deller@gmx.de, jt@hpl.hp.com, rjw@sisk.pl,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-Id: <20080207120238.d169a0d2.akpm@linux-foundation.org> (sfid-20080207_200548_968897_E71FDF15)
In-Reply-To: <20080207190842.GC3025@tuxdriver.com>
References: <200801131516.34567.deller@gmx.de>
	<20080202224515.20a09553.akpm@linux-foundation.org>
	<200802062150.23930.deller@gmx.de>
	<20080206130448.564f18bb.akpm@linux-foundation.org>
	<20080206214747.GG32245@flint.arm.linux.org.uk>
	<20080206135950.d48ffa36.akpm@linux-foundation.org>
	<20080207155152.GA3025@tuxdriver.com>
	<20080207104912.c719deed.akpm@linux-foundation.org>
	<20080207190842.GC3025@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Feb 2008 14:08:42 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> > With your patch applied and arm allmodconfig, this
> > 
> >         BUILD_BUG_ON(sizeof(ha_t) != HA_SIZE);
> > 
> > triggers
> > 
> > Without your patch applied, these two
> > 
> >         BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
> >         BUILD_BUG_ON(sizeof(ha_t) != HA_SIZE);
> > 
> > are triggering.
> 
> The ha_t one triggers either way?  Hmmm...
> 
> Russell suggested that the ha_t and psa_t packed attributes were
> unnecessary, so I'll include the reduced version just in case the
> above is a typo.
> 
> ---
> 
> From: John W. Linville <linville@tuxdriver.com>
> Subject: [PATCH] wavelan: mark hardware interfacing structures as packed
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

ha_t is still triggering with this patch.

This incremental patch:

--- a/drivers/net/wireless/wavelan.h~a
+++ a/drivers/net/wireless/wavelan.h
@@ -85,7 +85,7 @@ union hacs_u
 #define		HASR_MMC_INTR		0x0002	/* Interrupt request from MMC */
 #define		HASR_MMC_BUSY		0x0004	/* MMC busy indication */
 #define		HASR_PSA_BUSY		0x0008	/* LAN parameter storage area busy */
-};
+} __attribute__((packed));
 
 typedef struct ha_t	ha_t;
 struct ha_t
_

fixes things up.  If forces `union hacs_u' to be two bytes, not four.
