Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41052 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbdEQN73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:59:29 -0400
Message-ID: <1495029567.2442.18.camel@sipsolutions.net> (sfid-20170517_155933_807420_FB2E8590)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: Jesse Jones <jjones@uniumwifi.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Date: Wed, 17 May 2017 15:59:27 +0200
In-Reply-To: <CAEFj986RfzE_AjuO0woU9JLcaUPetRYfx1HTNa+MXfEyRWqTbA@mail.gmail.com> (sfid-20170329_123356_020574_F9F8F5DD)
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
         <b285e11810b612a6a156693f34e232ac@mail.gmail.com>
         <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
         <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com>
         <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
         <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com>
         <faafc817ee74ba39171199985756b87b@mail.gmail.com>
         <CAEFj984B=6C_AvzHqKnLLS5-h3cKMDmasXANQF1UZT64JSfW8g@mail.gmail.com>
         <1490775841.7948.5.camel@sipsolutions.net>
         <CAEFj986RfzE_AjuO0woU9JLcaUPetRYfx1HTNa+MXfEyRWqTbA@mail.gmail.com>
         (sfid-20170329_123356_020574_F9F8F5DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-29 at 18:33 +0800, Chun-Yeow Yeoh wrote:
> I would suggest the following modification of commit messages and
> code. Let me know whether this is fine.
> 
> ---------
> I would suggest the following edition to the commit message:
> 
> Instead of stopping path discovery when a path is established,
> continue the
> attempts to find alternative paths until we hit the
> dot11MeshHWMPmaxPREQretries
> limit. However, this is not a standard behavior and may easily
> increase the number of
> broadcast PREQ frame in your network. So this feature is turned off
> by default.
> 
> and the remaining are removed due to misleading explanation.
> 
> Then, in the mesh_path_timer, I think that only the following is
> needed:
> 
> - if (mpath->flags & MESH_PATH_RESOLVED ||
> - (!(mpath->flags & MESH_PATH_RESOLVING))) {
> + if (!multiple_discoveries &&
> +    (mpath->flags & MESH_PATH_RESOLVED ||
> +     (!(mpath->flags & MESH_PATH_RESOLVING)))) {

Alexis?

johannes
