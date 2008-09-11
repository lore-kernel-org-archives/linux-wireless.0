Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39421 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYIKFZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 01:25:11 -0400
Date: Wed, 10 Sep 2008 22:24:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Javier Cardona <javier@cozybit.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: sta_info->fail_avg
Message-ID: <20080911052458.GA24835@tesla> (sfid-20080911_072515_567295_DA3B2097)
References: <1221091198.3804.55.camel@johannes.berg> <445f43ac0809102215w2637dff7sa2c60dd8c31ccf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <445f43ac0809102215w2637dff7sa2c60dd8c31ccf6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 10:15:12PM -0700, Javier Cardona wrote:
> Johannes,
> 
> On Wed, Sep 10, 2008 at 4:59 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Hi Luis,
> >
> > Can you explain what you're using this for in the mesh code?
> 
> It is used to estimate the average retransmissions that will be
> required to send a nominal frame over a given peer link.
> That's one component of the airtime link metric.
> 
> > I do know that neither ath9k's nor Intel's rate
> > control algorithms ever set it so it'll always be zero.
> 
> In that case transmission failures will not be taken into account and
> nodes with that hardware will report a lower (better) link metric than
> what they should.  In other words, those nodes will attract mesh
> traffic, which will provide a strong incentive for the driver
> maintainers to set that value correctly :)

Neither of our drivers support Mesh yet though so this is good to know,
once we do add it (or someone does).

  Luis
