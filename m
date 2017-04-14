Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36577 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdDNSvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 14:51:49 -0400
Date: Fri, 14 Apr 2017 11:51:45 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org
Subject: Re: [RFC 1/3] bpf/wireless: add wifimon program type
Message-ID: <20170414185144.GB41922@ast-mbp.thefacebook.com> (sfid-20170414_205154_106668_9252B9CE)
References: <20170412110726.9689-1-johannes@sipsolutions.net>
 <1492007254.2855.10.camel@sipsolutions.net>
 <20170412.111913.497795978751789475.davem@davemloft.net>
 <1492011040.2855.18.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1492011040.2855.18.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 12, 2017 at 05:30:40PM +0200, Johannes Berg wrote:
> On Wed, 2017-04-12 at 11:19 -0400, David Miller wrote:
> > 
> > > Instead it may make more sense to just have a "wifi_info(skb,
> > info)"
> > > function you can call, e.g. with a structure that has various
> > fields
> > > and flags to see which you care about.
> > 
> > I would advise against this, let the parsing part use __sk_buff and
> > therefore have maximum flexibility.  You really cannot predict the
> > future, so in my opinion it might be unwise to constrain at this
> > point.
> 
> So my point with the wifi_info() function to call from the BPF program
> was just that putting something that's not already in struct sk_buff
> into __sk_buff doesn't really make a lot of sense - we still have to
> actually build it somewhere/somehow without knowing if it's going to be
> needed by the program. We already have things like prog->cb_access and
> prog->dst_needed now, but I'm not sure we want to blow that up much.
> 
> At the same time, technically I *do* have the information in skb->cb,
> but the format thereof is something I really wouldn't want to let
> trickle into the ABI. Therefore, I think if somebody needs something
> like the bitrate, we should have a wifi_info() function that can return
> the bitrate (among other things) without having to pre-build the data.
> We can still cache it in mac80211 if multiple programs are there, dunno
> if that makes sense.
> 
> Nevertheless, I think if I don't use __sk_buff as the program argument
> then things get really messy, so I'll stick to that, and avoid adding
> anything to it as much as possible.

so today only 'len' field is needed, but the plan to add wifi specific
stuff to bpf context?
If so, adding these very wifi specific fields to __sk_buff will confuse
other program types, so new program type (like you did) and new
'struct bpf_wifi_md' are probably cleaner.
Physically the R1 register to bpf program will still be 'struct sk_buff',
but from bpf program side it will be:
struct bpf_wifi_md {
  __u32 len;
  __u32 wifi_things;
};

At the same time if most of the __sk_buff fields can be useful to wifimon,
then just use it as-is (without restricting to 'len' only) and add wifi
specific fields to it with a comment.
