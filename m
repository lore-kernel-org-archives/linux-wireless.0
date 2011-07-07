Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4576 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1GGV1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 17:27:07 -0400
Date: Thu, 7 Jul 2011 14:21:49 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
Message-ID: <20110707212149.GR23944@broadcom.com> (sfid-20110707_232712_003506_AA8712D7)
References: <20110707002034.GA17885@broadcom.com>
 <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 06, 2011 at 05:40:13PM -0700, Rafał Miłecki wrote:
> 2011/7/7 Henry Ptasinski <henryp@broadcom.com>:
> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> > now propose moving brcm80211 out of staging and into mainline.
> >
> > Since brcm80211 in staging-next has about ~250 patches that areen't in
> > wireless-testing yet, I've put together a patch to add a copy of the
> > current sources from staging-next into
> > wireless-testing:drivers/net/wireless/brcm80211.
> >
> > The patch is somewhat large, so I've posted the patch at:
> >
> >      
> >  http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
> >
> > Only the necessary Kconfig and Makefile adjustments have been made (the
> > sources are unchanged from what's currently in staging-next).
> 
> Short question, without commenting on brcm80211 code yet:
> 
> Why should we want 2 mainline drivers for the same hardware?

Rafał,

The brcm80211 tree provides two device drivers:

The brcmsmac driver supports the BCM4313, BCM43224, and BCM43225 chipsets with
full performance (e.g. rate/range comparable to Windows drivers), does not have
any known system stability issues, is fully supported by Broadcom, and provides
an API for addition of newer chipsets that will help speed up the process of
getting support for those chipsets into the kernel.

The brcmfmac driver supports the BCM4329 chipset with full performance, does
not have any known system stability issues, is fully supported by Broadcom, and
provides the framework for the addition of other Broadcom embedded WLAN
chipsets.

There currently isn't any driver in mainline that provides all this, so I'm
proposing that we use the brcm80211 tree to get all this functionality.

- Henry


