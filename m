Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36076 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754151AbdCGDIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 22:08:21 -0500
Received: by mail-qk0-f180.google.com with SMTP id 1so187465103qkl.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 19:07:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <faafc817ee74ba39171199985756b87b@mail.gmail.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com> <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
 <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com> <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
 <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com> <faafc817ee74ba39171199985756b87b@mail.gmail.com>
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Tue, 7 Mar 2017 10:06:31 +0800
Message-ID: <CAEFj984B=6C_AvzHqKnLLS5-h3cKMDmasXANQF1UZT64JSfW8g@mail.gmail.com> (sfid-20170307_040923_027768_9F7300BC)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Jesse Jones <jjones@uniumwifi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> They are only reliable when compared to individual rate controlled frames.
> But, in general, they are most certainly not reliable. Even in a shielded
> and conductive (i.e. with physical wires connecting antennas) environment
> lost PREQ frames are not hard to see.

Did you try to reduce dot11MeshHWMPpreqMinInterval to send out more
PREQ and see whether this works for you?

I think that we have similar lengthy discussion last time.
http://comments.gmane.org/gmane.linux.kernel.wireless.general/139453

I would suggest the following edition to the commit message:

Instead of stopping path discovery when a path is established, continue the
attempts to find alternative paths until we hit the dot11MeshHWMPmaxPREQretries
limit. However, this is not a standard behavior and may easily
increase the number of
broadcast PREQ frame in your network. So this feature is turned off by default.

and the remaining are removed due to misleading explanation.

Then, in the mesh_path_timer, I think that only the following is needed:

- if (mpath->flags & MESH_PATH_RESOLVED ||
- (!(mpath->flags & MESH_PATH_RESOLVING))) {
+ if (!multiple_discoveries &&
+    (mpath->flags & MESH_PATH_RESOLVED ||
+     (!(mpath->flags & MESH_PATH_RESOLVING)))) {

Thanks

---
Chun-Yeow
