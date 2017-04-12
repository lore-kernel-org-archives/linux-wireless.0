Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38218 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752862AbdDLPZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:25:34 -0400
Message-ID: <1492010729.2855.16.camel@sipsolutions.net> (sfid-20170412_172544_653918_9DB4D33D)
Subject: Re: [RFC 3/3] mac80211: support bpf monitor filter
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 12 Apr 2017 17:25:29 +0200
In-Reply-To: <20170412.112212.441025205054195351.davem@davemloft.net>
References: <20170412110726.9689-1-johannes@sipsolutions.net>
         <20170412110726.9689-3-johannes@sipsolutions.net>
         <1492007347.2855.12.camel@sipsolutions.net>
         <20170412.112212.441025205054195351.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-12 at 11:22 -0400, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 12 Apr 2017 16:29:07 +0200
> 
> > On Wed, 2017-04-12 at 13:07 +0200, Johannes Berg wrote:
> >> 
> >>  struct ieee80211_if_mntr {
> >>      u32 flags;
> >> 
> > [...]
> > +     bool deliver;
> > 
> > That's ... broken for multi-queue RX. I haven't really found a good
> > other way to do it. The best way will likely be to copy the SKB the
> > first time it's needed, build the radiotap header, and then keep a
> > reference to it to be able to clone it later if it's needed again.
> 
> If you don't recurse into the receive path for different devices
> before you are done with this boolean, simply make a global per-cpu
> boolean and use that.

No, that won't work. We don't recurse, but this is a per-interface
bool, as we can have multiple monitor interfaces (possibly with
different filters).

The problem comes from the fact that I did

for_each_interface()
	iface.deliver = run_bpf_program();

if (nobody_wanted_it)
	return;

skb = build_monitor_skb()

for_each_interface()
	if (iface.monitor)
		deliver(skb);


What I should be doing is something like this:

for_each_interface() {
	if (run_bpf_program()) {
		if (!skb)
			skb = build_monitor_skb();
		deliver(skb);
	}
}

where deliver() does skb_clone() internally or so.

johannes
