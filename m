Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34150 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755967AbdC2KeB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 06:34:01 -0400
Received: by mail-qt0-f194.google.com with SMTP id x35so1370793qtc.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 03:33:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490775841.7948.5.camel@sipsolutions.net>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com> <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
 <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com> <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
 <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com>
 <faafc817ee74ba39171199985756b87b@mail.gmail.com> <CAEFj984B=6C_AvzHqKnLLS5-h3cKMDmasXANQF1UZT64JSfW8g@mail.gmail.com>
 <1490775841.7948.5.camel@sipsolutions.net>
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Wed, 29 Mar 2017 18:33:54 +0800
Message-ID: <CAEFj986RfzE_AjuO0woU9JLcaUPetRYfx1HTNa+MXfEyRWqTbA@mail.gmail.com> (sfid-20170329_123417_203730_4B59F64C)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jesse Jones <jjones@uniumwifi.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would suggest the following modification of commit messages and
code. Let me know whether this is fine.

---------
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

---
Chun-Yeow

On Wed, Mar 29, 2017 at 4:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> What's the outcome of this? I'm tempted to apply the patch since it's
> optional anyway ...
>
> johannes
