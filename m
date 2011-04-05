Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab1DEUlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 16:41:20 -0400
Date: Tue, 5 Apr 2011 13:42:20 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 2/3] linux-firmware: Removed codeversion from brcm
 firmware filenames.
Message-ID: <20110405204220.GB3577@kroah.com>
References: <1302015522-20601-1-git-send-email-henryp@broadcom.com>
 <1302015522-20601-3-git-send-email-henryp@broadcom.com>
 <4D9B3679.10509@lwfinger.net>
 <4D9B5684.6020304@broadcom.com>
 <4D9B66C2.5000200@lwfinger.net>
 <20110405192951.GA15638@kroah.com>
 <4D9B7C8A.4070702@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D9B7C8A.4070702@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 05, 2011 at 03:33:14PM -0500, Larry Finger wrote:
> On 04/05/2011 02:29 PM, Greg KH wrote:
> >On Tue, Apr 05, 2011 at 02:00:18PM -0500, Larry Finger wrote:
> >>On 04/05/2011 12:51 PM, Henry Ptasinski wrote:
> >>>On 04/05/2011 08:34 AM, Larry Finger wrote:
> >>>>I also endorse removing the version number from the firmware name; however, I
> >>>>see a fundamental flaw in the present submission. Both brcmsmac and its
> >>>>predecessor brcm80211 have been included in mainline and compat-wireless, have
> >>>>been widely distributed, and have a number of users. This change will break the
> >>>>system of every one of them - including mine.
> >>>
> >>>Hmm. Sounds like you've got the firmware installed with it's original name, and
> >>>are using symlinks. Is that correct? A lot of installations (including at least
> >>>one major distro) rename the files, and skip the whole symlink approach.
> >>>
> >>>That's we decided to dump the version number appendage. However, if there are a
> >>>mix of installation approaches, we should take a somewhat different approach on
> >>>the fix.
> >>>
> >>>>My proposed solution is to do the
> >>>>rename as done in this patch, but also include links to the new name from every
> >>>>name used in any distributed version.
> >>>
> >>>The brcm80211/brcmsmac driver has always looked for "brcm/bcm43xx-0.fw". It
> >>>never looked for the version info on the filename. So I don't quite understand
> >>>what you mean by "from every name used in any distributed version", as the only
> >>>name used in all distributed versions of the driver is exactly the name we're
> >>>trying to give to the firmware file. Could you clarify?
> >>
> >>You are right. Sorry for the noise. Having one name for the firmware
> >>in linux-firmware and a different one in the driver got me confused.
> >>The current patches will fix that.
> >>
> >>My distro is openSUSE, which does make a symlink between the name
> >>with version info and what the driver actually loads.
> >
> >I created that symlink for openSUSE, and if there is a better way to
> >solve it, please let me know.
> 
> Actually, the name change for the firmware as proposed in these
> patches will eliminate the need for those symlinks. That is the
> better way. Once that change propagates through the system and gets
> into openSUSE, the firmware files with the old names can be deleted.

Yeah!  When this gets checked in I'll create an updated opensuse
firmware package.

thanks,

greg k-h
