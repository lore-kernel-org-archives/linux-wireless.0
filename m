Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:32914 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbdF0TuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 15:50:09 -0400
Received: by mail-pf0-f169.google.com with SMTP id e7so21534973pfk.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 12:50:09 -0700 (PDT)
Date: Tue, 27 Jun 2017 12:50:05 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
Message-ID: <20170627195003.GA93674@google.com> (sfid-20170627_215036_193152_D6246E45)
References: <20170525001119.64791-1-briannorris@chromium.org>
 <20170525001119.64791-5-briannorris@chromium.org>
 <87fufk2hmm.fsf@purkki.adurom.net>
 <20170601173954.GA138807@google.com>
 <87inka77md.fsf@codeaurora.org>
 <20170621174829.GA92340@google.com>
 <1498136389.2246.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498136389.2246.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(A little slow on follow-up here)

On Thu, Jun 22, 2017 at 02:59:49PM +0200, Johannes Berg wrote:
> On Wed, 2017-06-21 at 10:48 -0700, Brian Norris wrote:
> > 
> > Yes, that all sounds nice. But for my sake, can you describe better
> > what's actually going on there (e.g., can you point me at which code
> > does this)? 
> 
> It's much easier with mac80211, it has all the state. Basically the
> reconfig is in ieee80211_reconfig() :)

Wow, that's not exactly simple code; I expect it could be pretty
difficult to get that right today on mwifiex. The current approach
actually should be *easier* (for the kernel side) to avoid bugs, as it
should be basically the same thing as 'rmmod'. Nonetheless, there are
plenty of bugs.

Thanks for the pointer though.

> > I'm really not familiar with mac80211 (though I was aware of
> > the above general behavior). But to my knowledge, mac80211 drivers
> > keep a lot more state managed in the kernel, so it's a little easier
> > and more natural to get the driver/FW back to "the same state" than
> > it is with a full-MAC driver.
> 
> Indeed.

Brian
