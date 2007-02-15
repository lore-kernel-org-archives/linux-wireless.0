Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:35008 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161079AbXBOTsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:48:24 -0500
Received: by wr-out-0506.google.com with SMTP id i21so783395wra
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 11:48:23 -0800 (PST)
Message-ID: <43e72e890702151148t59552354h8c2ddaf06576b863@mail.gmail.com>
Date: Thu, 15 Feb 2007 14:48:23 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: nl80211 userspace
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890702151146i7fb5915di4aa37f20e6cc3823@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1171479846.3709.3.camel@johannes.berg>
	 <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
	 <20070215141944.GA3310@tuxdriver.com>
	 <1171551930.5220.2.camel@johannes.berg>
	 <43e72e890702151146i7fb5915di4aa37f20e6cc3823@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/15/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On 2/15/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2007-02-15 at 09:19 -0500, John W. Linville wrote:
> >
> > > P.S.  Michael is, of course, right that the tool for users probably
> > > should not rely on python (or perl, et al).  FWIW, I got the
> > > impression that Johannes's tool was meant to use in the short-run
> > > for developers...?
> >
> > Yes. The advantage is that you don't even need to recompile it for new
> > commands. And hey, maybe we can hack it up to generate the C code for
> > the real tool :P
>
> I think the tool we should rely on next should be based on
> wpa_supplicant/wpa_cli codebase. wpa_supplicant already handles wext,
> directly through ioclt(), but nevertheless it does call the right
> ioctls. As such, it doesn't depend on iwlib so distributions who
> decide to ditch iwconfig won't need a the old library and still get
> backward compatibility . Extending it to support nl80211 would benefit
> the wpa_supplicant codebase and we can take advantage and fork our own
> new utility out of it. How about calling it "iw" as ifconfig's
> replacement is called "ip" ?

Oh and also -- what we can do for the userspace tool is rely on the
old wext ioctls for each call until the respective nl80211 interface
to cfg80211 is added. We can move forward replacing the ioctls as we
go with each release of this new tool.

  Luis
