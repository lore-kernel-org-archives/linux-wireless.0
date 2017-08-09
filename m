Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:36900 "EHLO
        resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdHIAhH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 20:37:07 -0400
Reply-To: james@nurealm.net
Subject: Re: wireless drivers fail to report link speed?
To: Ben Greear <greearb@candelatech.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
 <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
From: James Feeney <james@nurealm.net>
Message-ID: <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net> (sfid-20170809_023712_467713_38241710)
Date: Tue, 8 Aug 2017 18:36:20 -0600
MIME-Version: 1.0
In-Reply-To: <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey

On 08/08/2017 04:49 PM, Ben Greear wrote:
> 
> Some time back, I added some support to ath10k to report some ethtool info.
> At least most of this is upstream.  I do report rx and rx link rate, and yes,
> it changes, but it does contain some useful info, at least when modest amounts
> of packets are being transmitted and received (so that rate-ctrl logic
> is working).  I think the stuff not prepended with d_ will show up for any
> mac80211 driver.  Someone could improve ethtool to report these through more
> normal API than just getting the stats if they wanted...

Hmm - would you then lean in the direction of saying that this failure to report
a link speed is a fault in the kernel ethtool?

And, if so, would an update be required in just the kernel ethtool, or in both
the kernel ethtool and in every wireless driver?

Should the kernel ethtool get_settings() be made to report a proper link speed
and duplex when used with the wireless drivers?

On 08/08/2017 05:43 PM, Dan Williams wrote:
>
> It's very relevant to the question.  Because if the speed is actually
> not useful for the requested purpose, there is no real point in having
> it reported it via ethtool.  Same for duplex.  Wifi is only "half
> duplex", and so the property is actually meaningless for WiFi.

That seems a little over-broad, at least certainly with respect to "half
duplex".  If the link is known to be half duplex, then the kernel ethtool can
simply report that the link is "half duplex".  I am not hearing a good
justification, or a necessity, for the kernel ethtool to return an error, instead.

> At
> worst, your bonding link will flip-flop between slaves every second or
> two.  At best, bonding won't do anything differently than if the speed
> was just faked to some fake lowest common denominator number so that
> your wired link was always faster.

Well ok, flip-flopping every second would seem a pointless and bad effect.  But
then, for instance, my rtl8192ce driver shows a stable, actual link speed:

$ iwconfig wlp2s0
...
Bit Rate=72.2 Mb/s
...

$ ethtool -S wlp2s0
...
     txrate: 72200000
     rxrate: 1000000
...

Then, I don't know if this effect is as bad as you suggest.  Is there an actual
"stable" link speed here?  Or is this an "illusion", of bit of "fluff" being
promoted by the user-space iwconfig and ethtool?

> Sure, somebody could do a patch (like Ben has) that plumbs all this
> stuff through.  But that's not solving the *actual* problem, which is
> that this bonding change makes assumptions of slave devices that simply
> don't match how those devices work.

I take it that your position would be that the bonding module people, and Mahesh
in particular, are being unreasonable in expecting the kernel ethtool to provide
anything but an error in response to get_settings()?  What do you think of
Florian's suggestion, to check for dev->ieee80211_ptr being set, and letting
these interfaces proceed with being enslaved in a bond master network device if
that's the case?

Would you go so far as to say that modifying the kernel ethtool to report
wireless link speed and duplex would be entirely pointless?

Thanks
James
