Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56667 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3DKQL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 12:11:56 -0400
Message-ID: <5166E0A2.4050506@candelatech.com> (sfid-20130411_181201_528647_C252DFBF)
Date: Thu, 11 Apr 2013 09:11:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX performance.
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>   (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>  <516455CA.6070504@candelatech.com> <1365671968.8272.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365671968.8272.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 02:19 AM, Johannes Berg wrote:
> On Tue, 2013-04-09 at 10:54 -0700, Ben Greear wrote:

> Another question: Have you thought about hashing the virtual interfaces
> instead of the stations, and then hashing the stations inside each
> virtual interface? That would make it a bit of a two-level thing:
>
> A1 (in the frame) -> virtual interface
>      A2 (frame) -> station
>
> But it would address the TX side efficiently without "some_sta" since
> you know the virtual interface there already, and could potentially have
> less impact on the code? On TX it'd actually even be more efficient if
> you have more than 1 station per interface (right now you don't though)

A two-level hash might be helpful, but it might complicate the rx logic
a bit because at least in many cases you have to walk all sta in all
sdata, so would be some sort of double-loop.  Not that bad though,
and performance wise it should be similar.  Doing per-sdata hash should
also fix bad vhash collisions (such as if stations change a high-order
part of their MAC and leave the lowest octet the same).

On tx, if we assume good hash spread, then it should also have good
performance, and there is no case I can think of where having multiple
sta per station VIF would be needed, so very unlikely to have bad hash
performance.

But a question on all of this:  Are you assuming the current sta_hash on
the wiphy stays the same, or would you want it moved into the sdata as well?

I'd be willing to try it if you think it might be worth
pushing the result upstream.  If it's not going upstream anyway, then
I'll probably just stick with my some-sta and vhash patches at least until
they start conflicting bad enough with upstream to be worth re-visiting.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

