Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:19801 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbYBUXFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 18:05:41 -0500
Received: by nf-out-0910.google.com with SMTP id g13so135080nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 15:05:40 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Thu, 21 Feb 2008 23:04:28 +0000
Cc: Chris Vine <chris@cvine.freeserve.co.uk>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <1203628049.3277.6.camel@boulder.homenet> <200802212251.26897.IvDoorn@gmail.com>
In-Reply-To: <200802212251.26897.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802212304.28731.chris2553@googlemail.com> (sfid-20080221_230604_673711_32AAC469)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 February 2008, Ivo van Doorn wrote:
> On Thursday 21 February 2008, Chris Vine wrote:
> > On Wed, 2008-02-20 at 21:16 +0000, Chris Vine wrote: 
> > > On Wed, 2008-02-20 at 21:50 +0100, Ivo van Doorn wrote:
> > > [snip]
> > > > On Wednesday 20 February 2008, Chris Vine wrote:
> > > > > I did that yesterday and it just reported a kernel panic on the terminal
> > > > > with the message:
> > > > > 
> > > > >   Kernel panic - not syncing: Aiee, killing interrupt handler!
> > > > 
> > > > I have an idea, could you try below patch?
> > > > Note that while applying it will mention something about a line offset, but that can be ignored.
> > > > 
> > > > This could perhaps also fix the TX/RX issue mentioned earlier in the thread, but I am not
> > > > quite sure about that.
> > > 
> > > The patch applied OK (with some offsets as you say) but it doesn't help.
> > > The kernel panic still occurs when association is attempted.
> > 
> > Here's some further information.
> > 
> > I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
> > wireless-2.6/compat-wireless-2.6 of mid January which works fine on
> > kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
> > 2.6.25-rc2, there are no material differences.  (There was a slight
> > change in the declaration a variable in rt2x00usb.c but it is
> > immaterial.)
> > 
> > I compiled up the working mid-January version of rt2x00 and mac80211
> > under kernel 2.6.25-rc2 and I get exactly the same result as I reported
> > earlier, namely I get a kernel panic as soon as I try to associate.  It
> > looks therefore as if something has changed within the remainder of the
> > kernel which has caused rt2x00 (and possibly mac80211?) to break.
> > 
> > This probably explains the problem another user reported with rt61.
> 
> Perhaps something similar like:
> http://bugzilla.kernel.org/show_bug.cgi?id=10058
> in there a reference is made to the following patch:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> 
> Does applying that help?

I'm afraid not, Ivo. The test I ran last night was against 2.6.25.-rc2-git4 and
that already has this patch applied. Furthermore, I have another card that uses
the rtl8180 driver and that works reliably. I, therefore, suspect that my problem
lies within the rt61pci driver or the rt2x00 infrastructure.

Chris
> 
> Ivo
> 



-- 
Beauty is in the eye of the beerholder.
