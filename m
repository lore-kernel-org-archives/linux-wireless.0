Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64292 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab1CDTqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:46:03 -0500
Received: by vxi39 with SMTP id 39so2321566vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 11:46:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299266307.3742.5.camel@jlt3.sipsolutions.net>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
 <1299208307-9428-7-git-send-email-thomas@cozybit.com> <1299238635.4348.6.camel@jlt3.sipsolutions.net>
 <AANLkTim-cdTV6dsZg9MmMFMejkN8SpNYr=RBY-s8kiF=@mail.gmail.com> <1299266307.3742.5.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 4 Mar 2011 11:45:42 -0800
Message-ID: <AANLkTi=kJ2bsJ32snu62BTDkXgJXz-vgVQJGDcbgi5jO@mail.gmail.com>
Subject: Re: [PATCH 6/7] mac80211: Parse RSN information element to determine
 if a peer needs authentication
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2011 at 11:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-03-04 at 11:06 -0800, Javier Cardona wrote:
>> On Fri, Mar 4, 2011 at 3:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
>> >> From: Javier Cardona <javier@cozybit.com>
>> >
>> > [...]
>> >
>> > If you manage stations in userspace, then this code is unnecessary.
>> > That'd be a big win in my eyes. The only thing the kernel would need to
>> > know is not to create station entries, right?
>>
>> If userspace manages only rsn mesh stations then we do still need
>> this.  That would be my preference:  only require an authentication
>> daemon if you intend to join a secure mesh.  In the same way that you
>> can connect to an open AP without a daemon.
>> Would you object to this approach?
>
> No, I wouldn't, but I don't see why you'd still need this? I'm not sure
> exactly how all this works, but conceptually, is there anything wrong
> with this:
>  * when creating the mesh, you'd say "this is a secure mesh"
>  * when an auth frame is received, you just pass it to userspace, as you
>   already have
>  * userspace is responsible for adding/removing stations
>  * the kernel doesn't need to parse RSN since if it's a secure mesh it
>   will know because userspace said it was

I thought the RSN parsing was required at least for the case where a
station is open and discovers another station.  If the other station
wants security, we (the open mesh) should leave that station alone.
But I guess the same can be achieved by just detecting the presence of
an RSN IE without parsing it (there was logic for that already).

So, in summary, you are suggesting that we pass the kernel something
like dot11MeshSecurityActivated when joining the mesh, in addition to
the RSN IE.  And use the presence of the RSN IE in received beacons to
determine if other nodes have their security activated or not.

> Actually, looking at your patch in more detail, it would seem like it
> allows somebody to hijack the mesh by pretending it is an open network.
> If the RSN IE isn't present, mesh_neighbour_update() gets passed false
> for the rsn_enabled parameter -- even if the mesh should be secure --
> and then the peer would be allowed to join just because it said it
> didn't support RSN. Surely in that case it shouldn't be allowed to join?

You are right.  We would need to check if security is enabled before
creating a peer with no RSN info.

Thanks!

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
