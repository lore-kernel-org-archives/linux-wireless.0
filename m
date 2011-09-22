Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4405 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1IVSiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 14:38:06 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Christoph Hellwig" <hch@infradead.org>,
	"Brett Rudley" <brudley@broadcom.com>
cc: "Rafa?? Mi??ecki" <zajec5@gmail.com>, "Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 22 Sep 2011 11:37:51 -0700
Subject: RE: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0CC8B05A@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20110922_203823_083342_5D48992F)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922143107.GA27153@infradead.org>
In-Reply-To: <20110922143107.GA27153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: donderdag 22 september 2011 16:31
> To: Brett Rudley
> Cc: Rafa?? Mi??ecki; Greg KH; John W. Linville; Franky (Zhenhui) Lin;
> gregkh@suse.de; devel@linuxdriverproject.org; linux-
> wireless@vger.kernel.org
> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
> mainline patch #2
> 
> On Wed, Sep 21, 2011 at 03:12:02PM -0700, Brett Rudley wrote:
> > > > Our original plan was to remain a separate driver from b43. We
> were
> > > aware of it and all the good work that had been done to create it
> and we
> > > had no intention of interfering with it. ??At that point there had
> not
> > > been very much recent movement in b43 and it did not support any of
> our
> > > AXI based chips. ??We figured that ssb vs AXI was a good dividing
> line and
> > > there would be no conflict, and there wasn't initially.
> > >
> > > The first obvious problem is that there are SSB and BCMA (aka AXI)
> > > cards using N-PHY. That resulted in PHY code duplication between
> b43
> > > and brcmsmac. And since we already supported N-PHY in b43, adding
> bcma
> > > support automatically gave us BCM43224 and BCM43225 support. That
> of
> > > course means duplicated supported for the same hardware.
> >
> > Agree, when you created bcma, it did duplicate HW support already in
> brcmsmac.  Why didn't you address that then?
> 
> Because doing inside a driver is wrong.  bcma is a separate bus layer
> and really must stay outside the driver.  It can very reasonably argued
> that the same is true for the PHY support.

I am not disputing that the bcma bus driver was a good move, but there are
numerous chip devices out there with an internal bus of some sore and not
having a separate bus driver.

Regarding PHY support compared to a system bus on a chip is comparing
apples with pears. However, as said earlier we are not opposed to the
idea.

> Given the arguments from Johannes and other I think the only reasonable
> outcome here is to make sure the broadcom drivers share
> 
>  a) the bcma bus support (already done), and
>  b) the phy layer
> 
> and just make them the driver for the newer MAC revisions.

A BCMA bus driver and PHY layer does not give a wireless driver. Am I
missing something?
 
> (and stop those fight already, shh..)

I thought this was just an open and lively discussion ;-)

Gr. AvS

