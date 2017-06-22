Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60284 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753179AbdFVNAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 09:00:05 -0400
Message-ID: <1498136389.2246.7.camel@sipsolutions.net> (sfid-20170622_150030_925075_1FFB4DAF)
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 22 Jun 2017 14:59:49 +0200
In-Reply-To: <20170621174829.GA92340@google.com> (sfid-20170621_194834_481297_88C06BB6)
References: <20170525001119.64791-1-briannorris@chromium.org>
         <20170525001119.64791-5-briannorris@chromium.org>
         <87fufk2hmm.fsf@purkki.adurom.net> <20170601173954.GA138807@google.com>
         <87inka77md.fsf@codeaurora.org> <20170621174829.GA92340@google.com>
         (sfid-20170621_194834_481297_88C06BB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 10:48 -0700, Brian Norris wrote:
> 
> Yes, that all sounds nice. But for my sake, can you describe better
> what's actually going on there (e.g., can you point me at which code
> does this)? 

It's much easier with mac80211, it has all the state. Basically the
reconfig is in ieee80211_reconfig() :)

> I'm really not familiar with mac80211 (though I was aware of
> the above general behavior). But to my knowledge, mac80211 drivers
> keep a lot more state managed in the kernel, so it's a little easier
> and more natural to get the driver/FW back to "the same state" than
> it is with a full-MAC driver.

Indeed.

johannes
