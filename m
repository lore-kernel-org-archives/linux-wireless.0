Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288Ab1COSrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:47:52 -0400
Received: by iwn34 with SMTP id 34so857586iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 11:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300214486.4139.6.camel@jlt3.sipsolutions.net>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
 <1299831238.5082.185.camel@wwguy-huron> <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
 <1300063647.24333.7.camel@wwguy-ubuntu> <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
 <1300189917.5596.10.camel@jlt3.sipsolutions.net> <1300193550.5596.16.camel@jlt3.sipsolutions.net>
 <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com> <1300214486.4139.6.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 15 Mar 2011 11:47:32 -0700
Message-ID: <AANLkTikieuk6CoRPzQGSMMggMc=wPEXHY5B5H2N_CB5a@mail.gmail.com>
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 11:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-03-15 at 11:16 -0700, Daniel Halperin wrote:
>
>> There's still something off about the window size: unlike with ath9k,
>> the receiver does continually print out warnings about advancing its
>> window. There's something very fishy here: for any given aggregation
>> session, the part of the sequence number space this happens is always
>> the same! Really weird. Here's a log from 3 agg sessions in a row,
>> just running simple TCP iperf:
>>
>> [341221.679710] New seq exceeds buffering window: 283, 250
>
> Ok thanks for the patch, I'll still reply here though.
>
>
>> [341398.950019] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra =
>> 00:16:ea:c3:b3:8e tid = 0
>> [341401.790964] New seq exceeds buffering window: 2335, 2304
>
> So the delta is always 31, it seems? Is iwlwifi consistently sending
> batches of 32 instead of the advertised 31?

I don't think that's the case, in fact I've never seen the hardware
send a larger batch than frame limit.  I think it's from a missed
frame early in one batch being pushed out by a late frame in the next
batch. I know how to get the logs to find out. I have a bunch of
meetings soon, but I'll dig into this more later.

> Also -- don't get confused, the tx_agg_start is on its own TX agg
> session, but the new seq stuff is on its RX agg session.

You're absolutely true; but both sides pretty much start and stop
aggregation in sync, they both have the same timeouts and I'm only
using tcp traffic which is bidirectional.  They're running the same
software on the same hardware, modulo one being an AP and one a
client.

[Yes, I know that AP mode is broken on the iwl5300 but I disable power
save, etc., and it seems to work well enough ...  Actually, does AP
(not P2P) mode work properly on the P2P-supporting 6300?  I could
switch to using those.]

Dan
