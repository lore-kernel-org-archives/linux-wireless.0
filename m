Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54339
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab1IVObT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 10:31:19 -0400
Date: Thu, 22 Sep 2011 10:31:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: Rafa?? Mi??ecki <zajec5@gmail.com>, Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110922143107.GA27153@infradead.org> (sfid-20110922_163130_817365_13141158)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com>
 <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 03:12:02PM -0700, Brett Rudley wrote:
> > > Our original plan was to remain a separate driver from b43. We were
> > aware of it and all the good work that had been done to create it and we
> > had no intention of interfering with it. ??At that point there had not
> > been very much recent movement in b43 and it did not support any of our
> > AXI based chips. ??We figured that ssb vs AXI was a good dividing line and
> > there would be no conflict, and there wasn't initially.
> > 
> > The first obvious problem is that there are SSB and BCMA (aka AXI)
> > cards using N-PHY. That resulted in PHY code duplication between b43
> > and brcmsmac. And since we already supported N-PHY in b43, adding bcma
> > support automatically gave us BCM43224 and BCM43225 support. That of
> > course means duplicated supported for the same hardware.
> 
> Agree, when you created bcma, it did duplicate HW support already in brcmsmac.  Why didn't you address that then?

Because doing inside a driver is wrong.  bcma is a separate bus layer
and really must stay outside the driver.  It can very reasonably argued
that the same is true for the PHY support.

Given the arguments from Johannes and other I think the only reasonable
outcome here is to make sure the broadcom drivers share

 a) the bcma bus support (already done), and
 b) the phy layer

and just make them the driver for the newer MAC revisions.

(and stop those fight already, shh..)

