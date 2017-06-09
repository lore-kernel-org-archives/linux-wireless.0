Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59386 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbdFIT4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 15:56:42 -0400
Message-ID: <1497038197.12088.4.camel@sipsolutions.net> (sfid-20170609_215646_312757_17A21794)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Cc: j@w1.fi
Date: Fri, 09 Jun 2017 21:56:37 +0200
In-Reply-To: <08fb9e64-a01e-54ea-7627-a0664d350710@gmail.com> (sfid-20170609_151006_560796_31FD483E)
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
         <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
         <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
         <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
         <1496993334.2424.1.camel@sipsolutions.net>
         <08fb9e64-a01e-54ea-7627-a0664d350710@gmail.com>
         (sfid-20170609_151006_560796_31FD483E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

Btw, now I finally remembered what this also fixes - the whole bridging
mess :-) When we have this, we no longer need hostapd/wpas to be aware
of bridging and capturing frames beneath the bridge - something that's
actually a regression in Linux at some point.

> Do you have any thoughts on what the operations should look like or
> do you want me to take a stab in the dark at this?

Haven't really thought about it that much. I guess it should be similar
to mgmt_tx, quite possibly even just using that same operation?
Similarly, nl80211_register_mgmt() would have to be extended.

We already have NL80211_ATTR_CONTROL_PORT_ETHERTYPE, so perhaps this
should be used for some sort of filtering, i.e. perhaps
nl80211_register_mgmt() could be used with NL80211_ATTR_CONTROL_PORT or
something... Not really sure what the best plan is. Perhaps Jouni has
some other ideas.

It does seem like this shouldn't allow any other data frames to be
intercepted, since the control_port_protocol already requires special
handling in mac80211, but we don't really want to add even more than
that, i.e. I really don't want to see arbitrary ethertype interception
at this level.

> > That's actually not possible, since ordering set_key operations vs.
> > transmitted packets isn't something that's easily done by drivers.
> 
> Fair enough, but at least the kernel can do its best to make sure
> that such races do not manifest themselves out into userspace.  E.g.
> making sure that PAE events arrive after the connect events, etc.

Yes, having the events across a common path would actually solve that
particular race - not much more though, afaict.

> Makes sense.  Should PAE packets always be sent unencrypted?  Or
> should userspace be notified whether PAE was received unencrypted and
> send a response with the same flag?

No, they shouldn't always be sent unencrypted. They're specified to be
encrypted, e.g. for GTK rekeying that's required (though some non-IEEE
protocols require unencrypted, NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.)

Since we don't use the value of this attribute for anything but the TX
path, we can go two ways here:

 1) with the new EAPOL-over-nl80211, require userspace to set the
    unencrypted flag for every frame where it's needed, i.e. even for
    rekeying frames on such non-IEEE protocols

 2) if "do not encrypt" isn't specified, use control_port_no_encrypt as
    the default value

I think I'd prefer (1), but only slightly, so perhaps it makes sense to
check what's better in the resulting code.

> Also, while we're on this subject.  Should the kernel auto-manage
> the LINKMODE and OPERSTATE flags?  It would seem that it already has
> the information to do so, and having userspace manage this just
> introduces another source of latency / possibility of race
> conditions, etc.

I'm not convinced that it does have that information in all cases, and
I don't see how that causes race conditions or much latency, since for
client mode userspace would probably just set that together with the
NL80211_STA_FLAG_AUTHORIZED flag?

Anyway - that really should be a separate discussion and project, and
I'd prefer not to take this thread away from the original subject too
much.

johannes
