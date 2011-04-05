Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3884 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab1DERvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:51:52 -0400
Message-ID: <4D9B5684.6020304@broadcom.com>
Date: Tue, 5 Apr 2011 10:51:00 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 2/3] linux-firmware: Removed codeversion from brcm
 firmware filenames.
References: <1302015522-20601-1-git-send-email-henryp@broadcom.com>
 <1302015522-20601-3-git-send-email-henryp@broadcom.com>
 <4D9B3679.10509@lwfinger.net>
In-Reply-To: <4D9B3679.10509@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2011 08:34 AM, Larry Finger wrote:
> I also endorse removing the version number from the firmware name; however, I
> see a fundamental flaw in the present submission. Both brcmsmac and its
> predecessor brcm80211 have been included in mainline and compat-wireless, have
> been widely distributed, and have a number of users. This change will break the
> system of every one of them - including mine.

Hmm.  Sounds like you've got the firmware installed with it's original 
name, and are using symlinks.  Is that correct?  A lot of installations 
(including at least one major distro) rename the files, and skip the 
whole symlink approach.

That's we decided to dump the version number appendage.  However, if 
there are a mix of installation approaches, we should take a somewhat 
different approach on the fix.

 > My proposed solution is to do the
> rename as done in this patch, but also include links to the new name from every
> name used in any distributed version.

The brcm80211/brcmsmac driver has always looked for "brcm/bcm43xx-0.fw". 
  It never looked for the version info on the filename.  So I don't 
quite understand what you mean by "from every name used in any 
distributed version", as the only name used in all distributed versions 
of the driver is exactly the name we're trying to give to the firmware 
file.  Could you clarify?

Thanks,
- Henry

