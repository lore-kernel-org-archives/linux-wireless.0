Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44694 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750812AbdHRRQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 13:16:31 -0400
Message-ID: <1503076588.15969.320.camel@coelho.fi> (sfid-20170818_191635_285265_E87AFEA4)
From: Luca Coelho <luca@coelho.fi>
To: Dariusz Gadomski <dariusz.gadomski@canonical.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 18 Aug 2017 20:16:28 +0300
In-Reply-To: <20170818124800.q4r6xtflexkbetzq@leonard>
References: <20170818124800.q4r6xtflexkbetzq@leonard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Cisco's Wi-Fi Direct Client Policy and iwlwifi (8260)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dariusz,

On Fri, 2017-08-18 at 14:48 +0200, Dariusz Gadomski wrote:
> Hi,
> 
> There is a “Wi-Fi Direct Client Policy” setting in some Cisco AP hardware [1].
> I am unaware how that works exactly behind the scenes (except for some hints at
> [2]), but I have noticed that with that setting set to “Deny” I am observing
> issues when trying to connect from a machine with an Intel 8260 on a 4.10.0
> kernel - all connection attempts lead to failure.
> 
> I have managed to obtain some captured packets from that attempt as well as
> from a successful attempt (a machine with Broadcom bcm43224). What I have
> noticed is that AP puts the P2P IE in the beacon frames and when 8260 sends a
> probe request it also puts a P2P IE element in it. No response from the AP is
> ever transmitted.
> 
> In case of the Broadcom-based device the probe request does not contain P2P IE
> and it is able to correct normally. My understanding of this issue is that the
> AP makes the decision to temporarily blacklist the client after receiving a P2P
> IE from it.
> 
> I have made an additional test by commenting out the P2P interface types from
> iwlwifi/mvn/mac80211.c - using such kernel allowed the 8260 device to connect
> successfully.
> 
> I’m wondering if there’s a way of changing this behavior to enable the 8260 to
> connect to a network ‘secured’ in this way?  I would also appreciate some
> information about which behavior is correct (bcm43224 vs 8260) and is it
> specified anywhere in the Wi-Fi P2P specs (or anywhere else ftm)?

I have heard about this before.  The issue is that the Cisco AP doesn't
allow the 8260 to connect because it has the P2P IE in it.  But AFAICT
it is not against any specs to include this IE.  The Cisco AP is using
the IE as an indication that we are trying to connect as a P2P device,
which in this case we are not.

I'll try to dig the thread I had about this and take it again with our
system engineers to hear what they have to say about it.

In the meantime, I think it would be helpful if you could contact Cisco
about this issue as well.

--
Cheers,
Luca.
