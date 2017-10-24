Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36406 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdJXNzT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 09:55:19 -0400
Message-ID: <1508853316.2639.31.camel@sipsolutions.net> (sfid-20171024_155630_544974_C5CFD81B)
Subject: Re: A good way to get CSI info to user-space?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 24 Oct 2017 15:55:16 +0200
In-Reply-To: <b52bbc61-f0b5-5e9a-cce3-011fd43e6c8d@candelatech.com>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
         <1508790635.2639.24.camel@sipsolutions.net>
         <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
         <1508824462.2639.25.camel@sipsolutions.net>
         <d1746cd6-d889-a253-3638-8011d1ebd4fb@candelatech.com>
         <1508852310.2639.29.camel@sipsolutions.net>
         <b52bbc61-f0b5-5e9a-cce3-011fd43e6c8d@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-24 at 06:50 -0700, Ben Greear wrote:

> > We keep having this discussion. You need to fix this, it should be
> > really simple to fix this - just remove all checks for CONF_MONITOR
> > from ath10k and make it use WANT_MONITOR_VIF instead if it doesn't
> > already.
> 
> I don't recall having this discussion, 

I'm pretty sure I had this discussion about ath10k not liking virtual
monitor, but maybe it was with somebody else.

> but even if you can do a
> non-promiscuous monitor mode, you would have to end up having a bpf
> socket filter and packet socket, right?

True.

> Wouldn't that have a noticeable effect on performance on modest sized
> AP hardware?

Yes. I was planning to add the wifi BPF to fix that:
https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=bpf

You shouldn't think that building netlink messages is free though.
There's a lot more locking etc. going on there.

> > > mac80211_nl_send_opaque_event(mac80211-handle, int data-type, u8* data, int data_len);
> > 
> > I will not accept this upstream.
> 
> Thanks for letting me know up front, at least.
> 
> Anyone know if there is a useful way to stream events from debugfs
> and/or sysfs w/out having to busy-poll on it?

There's relayfs, which is kinda built for that. You could even use
netlink vendor events, but I don't really think netlink is appropriate
here.

johannes
