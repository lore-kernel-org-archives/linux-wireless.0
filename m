Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60978 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab1INIoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:44:25 -0400
Date: Wed, 14 Sep 2011 10:42:34 +0200
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <gregkh@suse.de>,
	Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
Message-ID: <20110914084234.GA5550@kroah.com> (sfid-20110914_104429_011261_96AE6289)
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
 <20110913174444.GG11772@tuxdriver.com>
 <CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 10:23:47PM +0200, Rafał Miłecki wrote:
> W dniu 13 września 2011 19:44 użytkownik John W. Linville
> <linville@tuxdriver.com> napisał:
> > On Mon, Sep 12, 2011 at 11:27:20PM +0200, Rafał Miłecki wrote:
> >
> >> The problem is that brcmsmac duplicates code present in the bcma
> >> driver. It doesn't use bcma bus architecture.
> >>
> >> The real solution is to add bcma driver support in brcmsmac and ssb
> >> driver support in brcmfmac. Then you can always use bcma and:
> >> 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
> >> 2) brcmsmac will be loaded to let it support the core
> >
> > We are going to have to find a way to get brcmsmac into the
> > wireless-next tree to make it feasible for the Broadcom guys to get
> > bcma support into that driver.  Do you agree?
> >
> > We could move it under the drivers/net/wireless tree.  Or, maybe I
> > could negotiate with Greg to keep it under the drivers/staging tree
> > but to let me manage it under wireless-next.  Or...?  Do you have
> > any thoughts on this?
> 
> I'll be posting some bcma patches that will allow brcmsmac being
> converted to bcma support. Currently we don't export few trivial ops
> in bcma, that are needed by b43/brcmsmac.
> 
> Could we ask Greg after that, to merge wireless-next into staging?

No.

> That would provide Broadcom guys all the symbols they need.

Yes, or they can wait for the next merge window as that will make things
easier for everyone involved, right?

> AFAIK git is clever enough to allow Linux easily merge both: Greg's
> tree and wireless-next tree. Without conflicts coming from
> "duplicated" patches.

It is, but I really don't want to be dragging around the wireless-next
tree in staging-next, just like I doubt John would want to drag
staging-next into wireless-next.

thanks,

greg k-h
