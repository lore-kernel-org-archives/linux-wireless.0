Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59102 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762207AbdAKJA2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 04:00:28 -0500
Message-ID: <1484125220.23671.1.camel@sipsolutions.net> (sfid-20170111_100045_193106_FA4176FD)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
Date: Wed, 11 Jan 2017 10:00:20 +0100
In-Reply-To: <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com> (sfid-20170111_095056_507074_72EC4D80)
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         <1484121737.23671.0.camel@sipsolutions.net>
         <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
         (sfid-20170111_095056_507074_72EC4D80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 17:50 +0900, Masashi Honma wrote:
> On 2017年01月11日 17:02, Johannes Berg wrote:
> > I don't think this makes sense - if you only have two peers then
> > you
> > shouldn't even run into forwarding code paths?
> > 
> > johannes
> 
> Though it looks odd, the code has run into forwarding code path even 
> though peer to peer mesh connection.
> 
> 	fwd_skb = skb_copy(skb, GFP_ATOMIC);
> 
> I checked it with printk().
> 
> # I know printk() should not be used in the context, just for
> checking.

Ok, that's strange, but maybe there's a reason.

Can you extract *any* information whatsoever? Like maybe if you switch
to a VT console before running into the crash? I don't have any
hardware to run this on, and hwsim doesn't have any issues.

johannes
