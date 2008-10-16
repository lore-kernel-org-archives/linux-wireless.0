Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:43437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753027AbYJPXdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:33:09 -0400
Date: Thu, 16 Oct 2008 16:28:47 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: steven@uplinklabs.net, linux-wireless@vger.kernel.org,
	stable@kernel.org, linville@tuxdriver.com
Subject: Re: [stable] [PATCH] ath9k: fix oops on trying to hold the wrong
	spinlock
Message-ID: <20081016232847.GA29003@kroah.com> (sfid-20081017_013314_684222_1D5C52BB)
References: <20081016111255.GA5899@tesla> <20081016215407.GA17091@kroah.com> <43e72e890810161612p69dc838sc6f25f33f5de8631@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890810161612p69dc838sc6f25f33f5de8631@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 16, 2008 at 04:12:02PM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 16, 2008 at 2:54 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Oct 16, 2008 at 04:12:55AM -0700, Luis R. Rodriguez wrote:
> >> This fixes on oops when you get try to send a BA to an 11n AP.
> >> The oops occurred because we were trying to aquire an incorrect
> >> spinlock.
> >>
> >> We were trying to hold the wrong spinlock due to a typo
> >> on IEEE80211_BAR_CTL_TID_S's definition. We use this to
> >> compute the tid number and then hold this this tid number's
> >> spinlock.
> >>
> >> Tested-by: Steven Noonan <steven@uplinklabs.net>
> >> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> >> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> ---
> >>
> >> I don't see this queue'd yet for 2.6.27.2
> >
> > Is it in Linus's tree?  If so, do you have a git commit id?
> 
> Got it.
> 
> a477e4e6d48d3ac7c7a75bad40585cb391e5c237
> 
> If you can add the Reported-by tag it'd be great, I missed it on Linus' tree.

You mean the "tested-by" flag?  I've added that, I don't see a
reported-by flag above.

thanks,

greg k-h
