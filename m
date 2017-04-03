Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbdDCMOA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 08:14:00 -0400
Date: Mon, 3 Apr 2017 14:13:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kalle Valo <kvalo@codeaurora.org>, Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
Message-ID: <20170403121345.GA23946@kroah.com> (sfid-20170403_141507_216458_70ACF24B)
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
 <20170331075851.GB1435@katana>
 <20170331102113.GA2930@eros>
 <87fuhq6par.fsf@purkki.adurom.net>
 <20170403090359.GK3755@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170403090359.GK3755@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 03, 2017 at 07:03:59PM +1000, Tobin C. Harding wrote:
> On Mon, Apr 03, 2017 at 08:19:40AM +0300, Kalle Valo wrote:
> > + linux-wireless
> > 
> > "Tobin C. Harding" <me@tobin.cc> writes:
> > 
> > > On Fri, Mar 31, 2017 at 09:58:51AM +0200, Wolfram Sang wrote:
> > >> 
> > >> > The code is untested, I have hardware in the mail.
> > >> 
> > >> Cool!
> > >
> > > The card I have is a Spectec FCC ID: S2Y-WLAN-11B-G which I believe is
> > > a SDW-823 and should use the ks7010 driver. I am going to attempt to
> > > get it running on a Raspberry Pi B+. I ordered the wrong size break
> > > out board originally so waiting on the new one now.
> > >
> > >> 
> > >> > If any one is interested and has any comments I would really like to
> > >> > hear them. I am open to all suggestions (even down to trivial coding
> > >> > style issues).
> > >> 
> > >> I'll just repeat that the key move to get this driver out of staging is
> > >> to get away from the WEXT interface to CFG80211. Otherwise no chance
> > >> that wireless maintainers will even look at it. This is a huge change
> > >> but once it is done, features like Michael MIC come with it for free
> > >> (from what I recall, I am not a wireless expert myself).
> > >
> > > That would explain why I could not find more than the Orinoco driver
> > > using the Michael MIC module directly.
> > 
> > I think cfg80211 and mac80211 got mixed up. mac80211 (the full IEEE
> > 802.11 stack for "softmac" devices) provides Michael MIC implementation,
> > but cfg80211 (for "hardmac" devices) does not.
> 
> Cool, thanks for clarifying. Hilariously I was just sitting down
> trying to figure out what was up after a day spent trying to merge
> ideas from ath6kl (fullmac) and ks7010. I finally spent some time
> reading the cw1200 driver (softmac) for further inspiration.

As an example of a driver that has been moved from an internal wireless
stack to using the kernel stack is the vt6655 driver.  I think it's the
only driver that has done this type of transition, so look at the patch
history of it for an example of what to do.

good luck!

greg k-h
