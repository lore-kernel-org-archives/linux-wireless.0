Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:4931 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYBUWve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 17:51:34 -0500
Received: by fk-out-0910.google.com with SMTP id z23so314245fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 14:51:32 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Thu, 21 Feb 2008 23:51:11 +0100
Cc: Chris Vine <chris@cvine.freeserve.co.uk>,
	Dan Williams <dcbw@redhat.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802212251.26897.IvDoorn@gmail.com> <1203633991.3186.2.camel@boulder.homenet>
In-Reply-To: <1203633991.3186.2.camel@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802212351.12637.IvDoorn@gmail.com> (sfid-20080221_225137_775676_8542AD2E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 February 2008, Chris Vine wrote:
> On Thu, 2008-02-21 at 22:51 +0100, Ivo van Doorn wrote:
> > On Thursday 21 February 2008, Chris Vine wrote:
> [snip] 
> > > Here's some further information.
> > > 
> > > I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
> > > wireless-2.6/compat-wireless-2.6 of mid January which works fine on
> > > kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
> > > 2.6.25-rc2, there are no material differences.  (There was a slight
> > > change in the declaration a variable in rt2x00usb.c but it is
> > > immaterial.)
> > > 
> > > I compiled up the working mid-January version of rt2x00 and mac80211
> > > under kernel 2.6.25-rc2 and I get exactly the same result as I reported
> > > earlier, namely I get a kernel panic as soon as I try to associate.  It
> > > looks therefore as if something has changed within the remainder of the
> > > kernel which has caused rt2x00 (and possibly mac80211?) to break.
> > > 
> > > This probably explains the problem another user reported with rt61.
> > 
> > Perhaps something similar like:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10058
> > in there a reference is made to the following patch:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> > 
> > Does applying that help?
> 
> Yes, well done.
> 
> I have spent 20 minutes testing it and it seems to work fine (at least
> as well as 2.0.14 does under kernel 2.6.24).  The rate control algorithm
> seems to work better as well, but that is probably a mac80211 thing.

Excellent, I am currently updating rt2x00.git from wireless-testing to get
the above mentioned patch into the repository.

Ivo

