Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51216 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923AbaGCO2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 10:28:41 -0400
Received: by mail-ie0-f175.google.com with SMTP id tp5so243320ieb.34
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 07:28:40 -0700 (PDT)
Date: Thu, 3 Jul 2014 10:28:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with new
 plid
Message-ID: <20140703142837.GA11380@localhost> (sfid-20140703_162846_961326_9052E058)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
 <20140628205414.GA17825@localhost>
 <CAEFj987rJW6bH7bZQKT1W2RzMVB2BnOyWABRQRHwbrCSuOAUig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj987rJW6bH7bZQKT1W2RzMVB2BnOyWABRQRHwbrCSuOAUig@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[reordered top-posting]

On Thu, Jul 03, 2014 at 08:36:28PM +0800, Chun-Yeow Yeoh wrote:
> >> "If the peerLinkID in the mesh peering instance has not been
> >> set, the Local Link ID field of the Mesh Peering Confirm
> >> request shall be copied into the peerLinkID in the mesh
> >> peering instance."
> >>
> Hi, Bob
> 
> What is the consequence if we don't handle this case? Is the peer
> going to do the re-auth again?
> 
> Regards,
> Chun-Yeow

It shouldn't be a big problem -- looking at 802.11-2012 figure 13-2:

Let's say station A is in OPN_SNT and station B is in OPN_RCVD,
but station A failed to get the Open frame from B.

When A gets a Confirm frame from B, it would ignore it (due to
missing plid), then it would resend Open on dot11MeshRetryTimeout.
Unfortunately, Confirm responses from B to that Open frame would
be ignored too.

However, B should also retry Open on dot11MeshRetryTimeout.
If any are successful, A moves to OPN_RCVD, then both have plids
and everything should be ok from then on.

In the worst case, plink timer on either station fires
dot11MeshMaxRetries times and peering instance closes.  Then peering
can start over after leaving holding state and either station gets a
beacon.

So in sum, it just adds a bit of resiliency and means we don't have
to wait for a dot11MeshRetryTimeout in the case of one lost open
frame.

-- 
Bob Copeland %% www.bobcopeland.com
