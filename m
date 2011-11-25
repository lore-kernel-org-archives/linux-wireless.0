Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63254 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1KYBlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 20:41:17 -0500
Received: by iage36 with SMTP id e36so3776307iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 17:41:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 24 Nov 2011 17:40:56 -0800
Message-ID: <CAPjQAd8GU8F2EV1zjZP5NG_QvfYaLr7wPz3OE49mX+-Mrx15XA@mail.gmail.com> (sfid-20111125_024120_958432_D7CA370E)
Subject: Re: [RFC v2 0/8] mesh power saving implementation: indication
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivan,

Good work!  Comments inline.

On Mon, Nov 21, 2011 at 6:40 AM, Ivan Bezyazychnyy
<ivan.bezyazychnyy@gmail.com> wrote:
> We have updated our patches and also we would like to add some words
> what our work is about.
>
> Based on the latest IEEE 802.11s standard the power saving mechanism
> can be divided into the following implementation phases:
> * indication of mesh STAs' power modes in frames;
> * a buffering and identification sending frames in mesh STA;
> * Mesh Awake Window implementation;
> * Peer service periods.

My recommendation would be to implement this bottom up.  That is,
start by implementing the Extensible synchronization framework
(Section 13.12.2, 802.11mb D10.0), as power save will not work without
syncronization.  After that, continue as...

13.13.8.4 Operation in light sleep mode for a mesh peering
13.13.4 TIM transmissions in an MBSS (and buffering)
13.13.6 Mesh awake window
13.13.9 Mesh peer service periods

Only after this is implemented I would advertise this capability in
beacons and make it configurable via userspace (i.e. what you've done
in this patchset).  That approach would also make it easier to test;
only after you get the TSF right you should attempt to implement the
awake windows and so on.

Does that make sense to you?

Cheers,

Javier

---


> Ivan Bezyazychnyy (8):
>  cfg80211 and nl80211: mesh power mode config parameter
>  mac80211: mesh power mode indication in QoS frames
>  mac80211: tracking mesh peer link-specific power mode
>  mac80211: mesh non-peer power mode indication in beacons
>  mac80211: setting link-specific mesh power modes when plink opens
>  cfg80211 and nl80211: Setting local link-specific power mode
>  cfg80211 and nl80211: getting local and peer mesh power modes
>  cfg80211 and nl80211: setting and getting mesh non-peer power mode
>
>  include/linux/ieee80211.h |   14 ++++++++++
>  include/linux/nl80211.h   |   41 ++++++++++++++++++++++++++++++
>  include/net/cfg80211.h    |   14 +++++++++-
>  net/mac80211/cfg.c        |   16 +++++++++++-
>  net/mac80211/mesh.c       |   35 +++++++++++++++++++++++++
>  net/mac80211/mesh.h       |   11 ++++++++
>  net/mac80211/mesh_plink.c |   22 +++++++++++++++-
>  net/mac80211/rx.c         |   61 +++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/sta_info.h   |    4 +++
>  net/mac80211/tx.c         |   46 ++++++++++++++++++++++++++++++++++
>  net/wireless/mesh.c       |    1 +
>  net/wireless/nl80211.c    |   22 ++++++++++++++++
>  12 files changed, 284 insertions(+), 3 deletions(-)
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
