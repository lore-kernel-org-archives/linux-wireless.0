Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaAFPzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:55:21 -0500
Message-ID: <1389023718.5891.31.camel@jlt4.sipsolutions.net> (sfid-20140106_165526_044576_13E01FF1)
Subject: Re: [PATCH] mac80211: Fix the buffer length in debugfs for smps
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 06 Jan 2014 16:55:18 +0100
In-Reply-To: <CABPxzY+En=1GxfBWHYgaSYSLv61MMYiFHz=hnJnsGnfBWpBJSQ@mail.gmail.com> (sfid-20140106_163234_617156_9CE8C726)
References: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1389019739.5891.16.camel@jlt4.sipsolutions.net>
	 <CABPxzY+yP1N1xLBHcVvMss_E=+2_3M95bQCEaxbkzvF+wbtnCQ@mail.gmail.com>
	 <1389021322.5891.25.camel@jlt4.sipsolutions.net>
	 <CABPxzY+En=1GxfBWHYgaSYSLv61MMYiFHz=hnJnsGnfBWpBJSQ@mail.gmail.com>
	 (sfid-20140106_163234_617156_9CE8C726)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 21:02 +0530, Krishna Chaitanya wrote:
> On Mon, Jan 6, 2014 at 8:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2014-01-06 at 20:35 +0530, Krishna Chaitanya wrote:
> >> On Mon, Jan 6, 2014 at 8:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> > On Sun, 2014-01-05 at 02:36 +0530, Chaitanya T K wrote:
> >> >> This was blocking sending SMPS action frames
> >> >> through debugfs.
> >> >
> >> > I don't see any issue here, explain.
> >> >
> >> > johannes
> >> >
> >> buflen includes the new line character as well, hence the comparison
> >> strncmp fails for all combiantions.
> >>
> >> echo "static" > ieee80211/phyX/netdev\:wlanX/smps
> >> Then
> >>
> >> buf=static\n
> >> buflen=7
> >>
> >> But the comparison is with "static" which doesn't include "\n"
> >> hence the comparison fails.
> >
> > Err, ok, so you can just do "echo -n static", right?
> >
> > And then your patch breaks the way it currently works, which is about
> > the worst you can do.
> >
> Ok, if one works other fails.
> 
> So instead why cant we use strlen(local_string)
> instead of using buflen(remote). That way we can make sure we only
> compare the characters we need and leave out the extra ones.

It wouldn't fix the problem and would introduce a buffer overflow bug.

johannes


