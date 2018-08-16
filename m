Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40880 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbeHPLK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 07:10:26 -0400
Message-ID: <1534407150.3547.58.camel@sipsolutions.net> (sfid-20180816_101342_272663_9D11F9A3)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: pradeepc@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Aug 2018 10:12:30 +0200
In-Reply-To: <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534323867.3547.30.camel@sipsolutions.net>
         <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-15 at 18:50 -0700, pradeepc@codeaurora.org wrote:

> > All you describe above is really a driver bug - it shouldn't have
> > enabled it to start with?
> 
> Sure.. But isn't it justifiable for drivers/firmware choosing to enable
> ftm responder by default when there is no way for userspace to specify 
> this parameter?

No? FTM needs higher-level configuration/advertisement, so how could the
driver/firmware enable it when it's not supposed to be?

I really do think this is a driver bug.

Nothing stopped you from submitting these patches months/years ago when
the capability was first added to the firmware, after all.

> > This makes sense anyway. Funny you should post this within hours of me
> > doing the same, basically.
> 
> Sorry, I missed your patches before posting mine :)

No worries.

> > 
> > I have no objection to your approach, though I guess it'd be nice if 
> > you
> > could take a look at the statistics I have exposed and see if those
> > makes sense or if additional ones are desirable for you, and then we 
> > can combine the work that way, i.e. have your configuration and our stats?
> 
> I looked at the patch you posted and this makes sense. I will try to 
> align ath10k driver changes with your approach.

I tend to actually like your patch better for configuration - no new
command, though it is, I think, lacking configuration of the necessary
elements (where do you take the LCI/Civic location from?).

johannes
