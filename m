Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45769 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934472Ab1JEPHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 11:07:00 -0400
Message-ID: <4E8C7289.50706@hauke-m.de> (sfid-20111005_170704_839551_BD69ABF4)
Date: Wed, 05 Oct 2011 17:06:49 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: [PATCH v3] move brcm80211 drivers to mainline
References: <4E8C64EF.3070203@broadcom.com>
In-Reply-To: <4E8C64EF.3070203@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 04:08 PM, Arend van Spriel wrote:
> With number of cleanup patch series merged in by Greg KH, I'd like to
> once again propose moving brcm80211 out of staging and into mainline.
> 
> I've put together a patch to add a copy of the current sources from
> staging-next into drivers/net/wireless/brcm80211 of the wireless-next
> repository.
> 
> The patch is somewhat large, so I've posted the patch at:
> 
> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-net-wireless-add-brcm80211-drivers-v3.patch
> 
> 
> Changes from the previous version:
> 
> V3:
> - remove -D line from Makefiles
> - use endian annotated structures
> - enable sparse endian checking
> - remove use of (static) global variables
> - remove own buffer printing implementation
> - remove static function prototypes
> - replace macros by inline functions
> - reduce sparse warnings
> - remove using string-based iovars
> - remove driver internal use of ioctls
> - remove (un)likely
> - remove uncoditional curly braces for variable scoping
> - remove error messages upon alloc failures
> - reduced code indentation levels
> - cleanup in brcmutil module
> - remove changing lock state which is acquired by other layer
> (wpa_supplicant)
> - brcmfmac:
>     - use ffs() instead of brcmf_find_msb()
>     - replace threads with work queues
>     - cleanup module parameters
> - brcmsmac:
>     - not modifying ssn value upon AMPDU start
>     - use hweight8() instead of brcmu_bitcount()
>     - remove unnecessary mac80211 callbacks
>     - remove brcms_c_set_par and get_par functions
>     - remove bmac wrapper functions
>     - remove lock related macros
>     - add debugfs based event tracing (not functional in staging)
> 
> The brcmsmac driver has been verified to work on x86 (both 32- and
> 64-bit), PPC
> (64-bit), SPARC, MIPS BE, and ARM.  The brcmfmac driver has been
> verified to
> work on x86 32-bit and ARM (additional testing is in progress, but
> getting a
> working sdio controller on some of the other platforms remains
> challenging).
> 
> The drivers compile cleanly for x86 (32- and 64-bit), PPC (32- and 64-bit),
> SPARC, MIPS BE, MIPS LE, and ARM.
> 
> Thanks,
> Arend van Spriel
> 
Hi Arend,

Most of the things defined in
drivers/net/wireless/brcm80211/include/soc.h are also defined in
drivers/net/wireless/brcm80211/brcmsmac/aiutils.h.

Hauke
