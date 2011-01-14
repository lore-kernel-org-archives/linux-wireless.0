Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43542 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab1ANTFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 14:05:12 -0500
Received: by gxk9 with SMTP id 9so1242818gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 11:05:11 -0800 (PST)
Subject: Re: [RFC 1/2] ath9k:  Fix up hardware mode and beacons with
 multiple vifs.
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 13:58:02 -0500
Message-ID: <1295031482.3703.16.camel@mythtv.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-14 at 09:27 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When using a mixture of AP and Station interfaces,
> the hardware mode was using the type of the
> last VIF registered.  Instead, we should keep track
> of the number of different types of vifs and set the
> mode accordingly.
> 
> In addtion, use the vif type instead of hardware opmode
> when dealing with beacons.
> 
> Attempt to move some of the common setup code into smaller
> methods so we can re-use it when changing vif mode as
> well as adding/deleting vifs.
> 
> This needs review.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 3108699... a2da259... M	drivers/net/wireless/ath/ath9k/ath9k.h
> :100644 100644 385ba03... 8de591e... M	drivers/net/wireless/ath/ath9k/beacon.c
> :100644 100644 0452580... 1a65e53... M	drivers/net/wireless/ath/ath9k/main.c
> :100644 100644 ea2f67c... 9a2b4a8... M	drivers/net/wireless/ath/ath9k/recv.c
>  drivers/net/wireless/ath/ath9k/ath9k.h  |   10 +-
>  drivers/net/wireless/ath/ath9k/beacon.c |   14 +-
>  drivers/net/wireless/ath/ath9k/main.c   |  263 ++++++++++++++++++++++---------
>  drivers/net/wireless/ath/ath9k/recv.c   |   17 ++-
>  4 files changed, 214 insertions(+), 90 deletions(-)
> 

It would be really useful to have both an AP and MESH vif. With the mesh
and ap vif's bridged, a station connected to the ap could ping outside
the mesh. Currently, if you add the mesh vif and then the ap vif, it
sort of works. The other way around, the mesh interval value causes
beacons to be sent only for the vif associated with slot 0.

Is it possible to consider this case as you overhaul ath9k beaconing?

Steve


