Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48142 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754889AbdBNULu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 15:11:50 -0500
Message-ID: <1487103101.6517.1.camel@sipsolutions.net> (sfid-20170214_211220_376140_C6A740E9)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 14 Feb 2017 21:11:41 +0100
In-Reply-To: <e2ec8547-4e0d-881b-5f4e-1e61d4b8b047@broadcom.com> (sfid-20170214_210910_322687_A1E9999F)
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
         <1485250815.7244.8.camel@sipsolutions.net>
         <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
         <1487076714.4705.11.camel@sipsolutions.net>
         <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com>
         <1487077927.4705.14.camel@sipsolutions.net>
         <e2ec8547-4e0d-881b-5f4e-1e61d4b8b047@broadcom.com>
         (sfid-20170214_210910_322687_A1E9999F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 21:09 +0100, Arend Van Spriel wrote:
> On 14-2-2017 14:12, Johannes Berg wrote:
> > On Tue, 2017-02-14 at 14:07 +0100, Arend Van Spriel wrote:
> > 
> > > > No. But there was a size limit on how much older userspace
> > > > could
> > > > process before we did the splitting.
> > > 
> > > I see. So basically adding stuff to (split_start == 0) is not
> > > wanted.
> > 
> > Correct.
> 
> Uhm. Now I am staring at the code there and wonder about following.
> Up until (split_start == 7) I see:
> 
> 		state->split_start++;
> 		if (state->split)
> 			break;
> 
> For the remaining cases the break is unconditional. Any idea how to
> interpret that?

Yeah, actually, adding stuff to anything where split_start < 7 is
therefore not wanted :-)

The thing is that we if no split is accepted by the userspace tool
(state->split is false) then we have to send everything in one big
message. This is everything until split_start == 7, I guess.

After that, there's only new stuff that such old userspace will be
unable to interpret anyway, so the break is then unconditional - old
userspace without split will never see those new capabilities, and new
userspace can deal with the split.

johannes
