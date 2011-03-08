Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60302 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1CHS4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 13:56:35 -0500
Received: by vxi39 with SMTP id 39so4978115vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 10:56:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299597000.4676.19.camel@jlt3.sipsolutions.net>
References: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
 <1299550284-3167-2-git-send-email-javier@cozybit.com> <1299597000.4676.19.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 8 Mar 2011 10:56:14 -0800
Message-ID: <AANLkTinSirogOWqx2X-LTHdL01vyNdJkApJ7gQwM6zj=@mail.gmail.com>
Subject: Re: [RFC] mac80211: New notification to discover mesh peer candidates.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 8, 2011 at 7:10 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-03-07 at 18:11 -0800, Javier Cardona wrote:
>> Notify userspace when a beacon/presp is received from a suitable mesh
>> peer candidate for whom no sta information exists.  Userspace can then
>> decide to create a sta info for the candidate.  If userspace is not
>> ready to authenticate the peer right away, it can create the sta info
>> with the authenticated flag unset and set it later.
>
> I'm a little worried about this creating lots of bogus stations if
> somebody is attacking the mesh. Will that be relevant? Would it be
> better to just pass up any beacon that matches the mesh ID, trading CPU
> resources for memory?

With this approach, when security is enabled, the decision to create
the station is still made by the userspace daemon.  A normal sequence
would be:

beacon is received
mesh_matches_local is true
no peer exists
send NEW_PEER_CANDIDATE notification
userspace creates unauthenticated station (optionally, to stop notifications)
userspace authenticates station
userspace sets authenticated flag

But alternatively userspace can create no station at all.  In that
case a NEW_PEER_CANDIDATE notification is sent for every beacon
received.

If somebody decides to attack the mesh by sending bogus mesh beacons,
userspace may decide not to create stations and ignore the
notifications.  You see a problem in this?

> Also, this goes back to the "authenticate station" rather than full
> station management in userspace, right?

Partially.  The station must still be created by userspace.  We add
the possibility to set the autenticated flag sometime after creation.
I would also like to support the creation of a mesh candidate station
with the ASSOC flag unset, which is not possible at this time.

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
