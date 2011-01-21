Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3471 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1AUOiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 09:38:05 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 21 Jan 2011 06:37:54 -0800
Subject: RE: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Message-ID: <400C43189542CE41BC0A5B252FC90136952F05955A@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1294855167-3718-1-git-send-email-arend@broadcom.com>,<20110120201753.GA18529@kroah.com>
In-Reply-To: <20110120201753.GA18529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

I did not retest the suspend/resume change functionally (only compiled it). I decided
to do that on v2.6.38-rc1 to be sure and on my system the suspend works. However,
upon resume my system reboots without any feedback. System seem to come to
live (DVD spinning) and then BIOS boot screen pops up. So I tried suspend/resume
without our driver loaded. Results were the same. Also 2.6.37 shows same behaviour.

On 2.6.37-rc5 I did not have any issues and suspend/resume worked for our driver
and the kernel in general. Anyone else observed such behaviour?

Gr. AvS
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Greg KH [greg@kroah.com]
Sent: Thursday, January 20, 2011 9:17 PM
To: Arend Van Spriel
Cc: gregkh@suse.de; devel@linuxdriverproject.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: fix suspend/resume issue in brcmsmac

On Wed, Jan 12, 2011 at 06:59:27PM +0100, Arend van Spriel wrote:
> PCI PM suspend callback took down the interface and resume brought
> it back up. In the mac80211 context this is done in subsequent calls.
> Rework implementation so that suspend only stores config, and sets
> PCI power state. The resume return to full power state (D0), restores
> the config, and brings hardware back up. Full bringup is done by
> subsequent mac80211 calls.
>
> Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   28 ++++++++++++---------
>  drivers/staging/brcm80211/brcmsmac/wl_mac80211.h |    4 +--
>  2 files changed, 17 insertions(+), 15 deletions(-)

This patch doesn't apply to Linus's tree, which is where it needs to go
right now.  Can you please redo it so that I can apply it?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


