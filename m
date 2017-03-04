Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36516 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdCDMF7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 07:05:59 -0500
Received: by mail-qk0-f172.google.com with SMTP id 1so95096154qkl.3
        for <linux-wireless@vger.kernel.org>; Sat, 04 Mar 2017 04:05:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com> <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
 <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com> <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Sat, 4 Mar 2017 20:05:34 +0800
Message-ID: <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com> (sfid-20170304_130624_088803_E6A37F72)
Subject: Re: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Jesse Jones <jjones@uniumwifi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 4, 2017 at 12:01 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>
>>
>> Well A-D is going to have a much smaller RTT than A-B-C-D. And, yes, using
>> multiple hops is going to reduce throughput but I'd much rather use
>> multiple
>> 120 Mbps links than a link that only supports 12 Mbps.
>>
>
> Airtime link metrics should choose the multiple links if it is good compared
> to direct link.
>
>> That's why there are link and path metrics.
>
> I don't think that you don't get this. Every nodes sends out multiple PREQs.
> Other nodes received it with rebroadcast again. Take note on this.
>
>> Improving the link metric isn't going to help with PREQ reliability
>> problems.
>
> PREQ realiabilit? It is broadcast management frame and usually using lowest
> transmission rate. So it is realiabe.
>
>> Sending more PREQs will.
>
> So reduce dot11MeshHWMPpreqMinInterval to send out more PREQ works for you?

Alright, I think that we have similar lengthy discussion last time.
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
