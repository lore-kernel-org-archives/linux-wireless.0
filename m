Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1889 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1ALTo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 14:44:56 -0500
Date: Wed, 12 Jan 2011 11:44:39 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: fix suspend/resume issue in
 brcmsmac
Message-ID: <20110112194438.GJ2466@broadcom.com>
References: <1294855167-3718-1-git-send-email-arend@broadcom.com>
 <20110112180829.GB10224@suse.de>
MIME-Version: 1.0
In-Reply-To: <20110112180829.GB10224@suse.de>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 10:08:29AM -0800, Greg KH wrote:
> On Wed, Jan 12, 2011 at 06:59:27PM +0100, Arend van Spriel wrote:
> > PCI PM suspend callback took down the interface and resume brought
> > it back up. In the mac80211 context this is done in subsequent calls.
> > Rework implementation so that suspend only stores config, and sets
> > PCI power state. The resume return to full power state (D0), restores
> > the config, and brings hardware back up. Full bringup is done by
> > subsequent mac80211 calls.
> 
> Ah, does this solve the suspend/resume bug that a number of people have
> reported for the driver since the .36 release?  If so, should it go into
> the kernel now and be backported to older releases?


Yes, this should solve the suspend/resume bug that people have reported. 
(It doesn't solve the rfkill issues; Arend is working on a separate fix for
that.)

It should get backported, but it would be nice to get some confirmation from
people that it fixes the issues they're seeing first.

- Henry


