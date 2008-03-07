Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbYCGMPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 07:15:19 -0500
Subject: Re: Patch for linux wireless extension
From: Dan Williams <dcbw@redhat.com>
To: hce <webmail.hce@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <95455e980803061900g5890a860n5c000a974cdf30b0@mail.gmail.com>
References: <95455e980803031901x67360bffsca3794f1dfde586b@mail.gmail.com>
	 <1204626369.3917.96.camel@johannes.berg>
	 <1204639101.7183.17.camel@localhost.localdomain>
	 <95455e980803060237p40790e84w32004da91f5341e6@mail.gmail.com>
	 <1204812001.29057.21.camel@localhost.localdomain>
	 <95455e980803061900g5890a860n5c000a974cdf30b0@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 07:11:41 -0500
Message-Id: <1204891901.20146.7.camel@localhost.localdomain> (sfid-20080307_121525_494345_10CACFA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-03-07 at 14:00 +1100, hce wrote:
> On Fri, Mar 7, 2008 at 1:00 AM, Dan Williams <dcbw@redhat.com> wrote:
> >
> > On Thu, 2008-03-06 at 21:37 +1100, hce wrote:
> >  > On 3/5/08, Dan Williams <dcbw@redhat.com> wrote:
> >  > > On Tue, 2008-03-04 at 11:26 +0100, Johannes Berg wrote:
> >  > >  > Jim,
> >  > >  >
> >  > >  > > I am running a wifi device on kernel 2.6.11 and wireless extension
> >  > >  > > version 17 for an ARM processor, it works fine with an open AP and
> >  > >  > > wpa_supplicant 0.5.8.
> >  > >  >
> >  > >  > That's ancient.
> >  > >  >
> >  > >  > > Now I would like to support WEP and WPA. I know
> >  > >  > > the best is to upgrade to latest kernel, but I am not in the position
> >  > >  > > to do it as various reasons.
> >  > >  >
> >  > >  > Upgrade anyway.
> >  > >  >
> >  > >  > > An alternative as people suggested is to
> >  > >  > > do a wireless extension patch which supports WEP and WPA on kernel
> >  > >  > > 2.6.11. Any advice if it is feasible and where can I find the wireless
> >  > >  > > extension patch for WEP and WPA on kernel 2.6.11 please?
> >  > >  >
> >  > >  > Hahaha. We'll you'll have to *make* that patch and invest a
> >  > >  > *significant* amount of time into that.
> >  > >
> >  > >
> >  > > Yeah; it's not just the defines and whatnot in wireless.h; you probably
> >  > >  also want to update wireless-tools too, then you have to update your
> >  > >  driver as well.  It's not hugely complex, but it's going to be a lot of
> >  > >  boring work :)
> >  > >
> >  > >
> >  > >  Dan
> >  >
> >  > I've just upgrade wireless extension version 18 which supports WPA (Is
> >  > it for WEP as well?), with replaced two files of version 18 wireless.h
> >  > and wireless.c in the kernel 2.6.11. Please correct me if I missed
> >  > other source files in the kernel.
> >  >
> >  > The wireless-tools we are using come from different sources, the
> >  > iwconfig was from busybox 1.3 and wpa_supplicant 0.5.8 was compiled to
> >  > our firmware. The initial test for WEP set up was not good, but I was
> >  > told, the wireless extension vresion 18 only supports WPA not WEP,
> >  > please advice.
> >
> >  Incorrect.  WE-18 _added_ support for WPA ioctls but did not remove
> >  support for WEP.  You'll just have to debug stuff and find out what's
> >  going wrong.
> 
> Thanks Dan.
> 
> There was an error of "ioctl[SIOCSIWENCODEEXT]: Input/output error". I
> looked at wireless.h and wireless.c of WE18, that the
> "SIOCSIWENCODEEXT" is defined and it also defines following in the
> static const struct iw_ioctl_description standard_ioctl[]
> 
> [SIOCSIWENCODEEXT - SIOCIWFIRST] = {
>         .header_type    = IW_HEADER_TYPE_POINT,
>         .token_size = 1,
>         .min_tokens = sizeof(struct iw_encode_ext),
>         .max_tokens = sizeof(struct iw_encode_ext) +
>                 IW_ENCODING_TOKEN_MAX,
>     },
> 
> What could I be missing for that ioctl[SIOCSIWENCODEEXT] in the kernel?

Well, if you want to support WPA you _also_ have to update your driver
with the ENCODEEXT and AUTH calls, and have your driver deliver WPA and
RSN IEs in the scan results with the GENIE tag.

There might also be something wrong with the backport, the IO error
reported looks odd.  I'm not an expert on the implementation of WEXT in
wireless.c though and I'm unsure what the exact path is that the ioctl
takes before it gets to the driver :(

Dan


