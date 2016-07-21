Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:32790 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcGUC34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 22:29:56 -0400
Received: by mail-qt0-f169.google.com with SMTP id w38so36825055qtb.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 19:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101392097ED@DFRE01.ent.ti.com>
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost> <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
 <20160719134355.GA1833@localhost> <CAEFj987V0r3aVn+JhQOX-40bheKyEJdrppF75OCaLXhU=skmNw@mail.gmail.com>
 <AE1C82FB3D0EC64DB1F752C81CBD110139206BD6@DFRE01.ent.ti.com>
 <CAEFj986LZ8zjBtyJrRL4GX3S-yTGxL-MJs3S18ze-NNw544OPQ@mail.gmail.com>
 <AE1C82FB3D0EC64DB1F752C81CBD110139208B47@DFRE01.ent.ti.com>
 <CAEFj986FX=Gyyadj4n5S6VrYx_D61jJFKjc2GajAVHbXbsVD+Q@mail.gmail.com> <AE1C82FB3D0EC64DB1F752C81CBD1101392097ED@DFRE01.ent.ti.com>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 21 Jul 2016 10:29:54 +0800
Message-ID: <CAEFj987yiE-pudMqdE-yskkwGUkMX0LADuo=SwOWff+2JtviVQ@mail.gmail.com> (sfid-20160721_043002_594004_32FF982E)
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I just take another look on your patch:
>>
>> @@ -1110,7 +1117,7 @@ int mesh_nexthop_resolve(struct
>> ieee80211_sub_if_data *sdata, }
>>
>> if (!(mpath->flags & MESH_PATH_RESOLVING))
>> - mesh_queue_preq(mpath, PREQ_Q_F_START);
>> + mesh_queue_preq(mpath, PREQ_Q_F_START, true);
>>
>> if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
>> skb_to_free = skb_dequeue(&mpath->frame_queue);
>>
>> You modification is intended to add this "immediate" PREQ generation
>> whenever the data frame is transmitted. In case the current path is
>> indeed the best one, the PREQ will still generate without waiting for
>> dot11MeshHWMPpreqMinInterval. The network is unnecessary flooded with
>> PREQ.
>
> To my understanding, if you already have a path established, it will not send a new PREQ (as it's not in RESOLVING state)

The mesh path is in resolving state means that the mesh STA has just
triggered the discovery process. It sends out a PREQ and waits for
PREP from your destined mesh STA. After receiving the PREP, the path
is established and in active state. Then, the mesh STA is allowed to
send another PREQ but limited by the dot11MeshHWMPpreqMinInterval.

> So if the current path is the best, no excessive PREQ frames will be sent.

Your patch is indeed allowed the mesh STA with on-going data
transmission to send PREQ immediately no matter whether the path is
already a best path or not.

> In case the path is cleared, due to peer removal as described before.

For your case, it happens to you that the leaving mesh STA is the one
used for constructing the best path. So you want a quick PREQ to
re-construct it back.

>
> The test use case is simple, and from our tests the impact on performance big related to our expectation,
> I assume the question is, what are the performance expectations/requirements from the 802.11s mesh network ?

You specified your test case, nothing wrong. But there is other use
cases that we don't really need the "immediate" PREQ and indeed would
like to limit by dot11MeshHWMPpreqMinInterval.

Moving forward, I would suggest that a patch to turn it on or off with
comments saying that turning this on may consume more airtime due to
the overhead of broadcast PREQ no longer limited by
dot11MeshHWMPpreqMinInterval and this feature is by default off.

---
Chun-Yeow
