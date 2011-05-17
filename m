Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33982 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065Ab1EQTYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 15:24:00 -0400
Date: Tue, 17 May 2011 12:19:29 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/32] staging: brcm80211: new Kconfig item to enable IO
 reordering fix
Message-ID: <20110517191929.GA7275@kroah.com> (sfid-20110517_212405_356236_A77F3097)
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
 <1305280792-9475-2-git-send-email-arend@broadcom.com>
 <20110514154636.GA25783@kroah.com>
 <4DCFCCB4.1010303@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DCFCCB4.1010303@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 15, 2011 at 02:53:08PM +0200, Arend van Spriel wrote:
> On 05/14/2011 05:46 PM, Greg KH wrote:
> >On Fri, May 13, 2011 at 11:59:22AM +0200, Arend van Spriel wrote:
> >>From: Roland Vossen<rvossen@broadcom.com>
> >>
> >>bcm4716 (which includes 4717&  4718), plus 4706 on PCIe can reorder
> >>transactions. As a fix, a read after write is performed on certain places
> >>in the code. Older chips and the newer 5357 family don't require this fix.
> >>
> >>Cc: devel@linuxdriverproject.org
> >>Cc: linux-wireless@vger.kernel.org
> >>Reviewed-by: Henry Ptasinski<henryp@broadcom.com>
> >>Reviewed-by: Brett Rudley<brudley@broadcom.com>
> >>Signed-off-by: Arend van Spriel<arend@broadcom.com>
> >>---
> >>  drivers/staging/brcm80211/Kconfig                  |    8 ++++++++
> >>  .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 ++--
> >>  drivers/staging/brcm80211/include/bcmutils.h       |   11 +++++++++++
> >>  3 files changed, 21 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
> >>index f4cf9b2..a11ffc7 100644
> >>--- a/drivers/staging/brcm80211/Kconfig
> >>+++ b/drivers/staging/brcm80211/Kconfig
> >>@@ -36,3 +36,11 @@ config BRCMDBG
> >>  	depends on BRCMSMAC || BRCMFMAC
> >>  	---help---
> >>  	  Selecting this enables additional code for debug purposes.
> >>+
> >>+config BRCM_FIX_IO_ORDER
> >>+	bool "Broadcom I/O order fix"
> >>+	default n
> >>+	depends on BRCMSMAC
> >>+	---help---
> >>+	  Select this for for platforms running on bcm4706, 4716, 4717 or 4718.
> >>+	  It resolves an I/O issue with the PCIe core used in these chips.
> >No, don't make a new kconfig option for something that everyone has to
> >enable as they don't know what they have on their system (think
> >universal kernels built by distros.)
> >
> >Do this check dynamically, depending on the chip the driver is running
> >on, don't rely on a user to know what to do here.
> >
> >So I'm not going to accept this patch, sorry.
> Hi Greg,
> 
> No problem. Thanks for the feedback. There are two other patches in
> this series which depend on this one. Could you also drop the
> following:
> 
> [PATCH 03/32] staging: brcm80211: replaced #ifdef __mips__ sections
> by W_REG_FLUSH
> [PATCH 11/32] staging: brcm80211: Kconfig fix for 'Broadcom I/O order fix'

Ok, now dropped.

thanks,

greg k-h
