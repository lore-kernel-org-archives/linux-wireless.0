Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35113 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbcGTGpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 02:45:18 -0400
Received: by mail-qt0-f169.google.com with SMTP id x25so21562733qtx.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 23:45:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD110139206BD6@DFRE01.ent.ti.com>
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost> <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
 <20160719134355.GA1833@localhost> <CAEFj987V0r3aVn+JhQOX-40bheKyEJdrppF75OCaLXhU=skmNw@mail.gmail.com>
 <AE1C82FB3D0EC64DB1F752C81CBD110139206BD6@DFRE01.ent.ti.com>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Wed, 20 Jul 2016 14:45:16 +0800
Message-ID: <CAEFj986LZ8zjBtyJrRL4GX3S-yTGxL-MJs3S18ze-NNw544OPQ@mail.gmail.com> (sfid-20160720_084523_249374_E26C49E1)
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 20, 2016 at 4:01 AM, Machani, Yaniv <yanivma@ti.com> wrote:
> On Tue, Jul 19, 2016 at 19:01:54, Yeoh Chun-Yeow wrote:
>> Johannes Berg
>> Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving
>> time
>>
>> On Tue, Jul 19, 2016 at 9:43 PM, Bob Copeland <me@bobcopeland.com>
>> wrote:
>> > On Tue, Jul 19, 2016 at 01:02:13PM +0000, Machani, Yaniv wrote:
>> >> On Tue, Jul 19, 2016 at 15:44:56, Bob Copeland wrote:
>> >
>> > This wording seems to indicate that it is not per path.  Perhaps
>> > this should be clarified in the standard.  (If the intent turns out
>> > to be per path, then I guess we should fix it by storing last_preq
>> > per path
>> > instead.)
>> >
>> >
>> > Ignoring the standard for a second, let's explore this: can you give
>> > some idea on how many stations are in your target network, how
>> > frequently a given pair of nodes unpeer, what sort of improvements
>> > you see with the patch?  It should then be pretty easy to run some
>> > simulations to see the scenarios where this helps and where it hurts.
>> >
>>
>
> Bob, Chun-Yeow,
> Thanks for your inputs.
>
> Let take a simple scenario, where you have a,b,c,d nodes connected to each other as shown below.
>
> A~ ~ ~~~~C- - - D
>    \          /
>       \     /
>          B
>
> A would like to pass data to D.
> A-C matric is worse than A-B-C, so path is constructed via B.
> We are in idle state, and PREQ are sent every dot11MeshHWMPpreqMinInterval.
> Now, node B have been disconnected (ran out of battery/shut down/suddenly went out of range)
> As A has a path to D via B, he cleans up his path table.
> Now he needs to build a new path, in the WCS, he have just sent a PREQ.
> And now he needs to wait dot11MeshHWMPpreqMinInterval seconds, until he can rebuild the path.

Did you reduce the dot11MeshHWMPactivePathTimeout to see whether it
produces positive impact to your network? Once the path to A - C - D
has established, it needs to wait till the active path timer to expire
before establishing a new path. This active path time is default to
5000 TUs (or 5s).

> As we wouldn't like to flood the network with PREQ, we can assume that the dot11MeshHWMPpreqMinInterval is few seconds, for us, it seemed un-acceptable.
>

But your patch is indeed generating "more" PREQ frame.

> In cases where you need to have a reliable data link, passing audio/video you usually can't afford few seconds w/o traffic.
>
>> In addition to Bob's comment, you probably can try to reduce the
>> dot11MeshHWMPpreqMinInterval to 1 TU (1ms) instead of sticking to
>> default value 10 TUs. Besides, you can also reduce the
>> mesh_path_refresh_time which is currently default to 1000 ms and check
>> whether you can improve on your network scenarios.
>>
>
> We did tried to play with these values, but again, we don't want to flood the network.
> We just want to recover ASAP.
>
>> When you mentioned "next hop peer disconnect", it could also be the
>> time taken to re-established the mesh peering before your mesh STA can
>> transmit the data to your peer mesh STA.
>>
>
> Link establishment takes no more than few 100s of ms usually,
> And in the example above, there is no new link establishment, just path generation.
>

Suggest that you simulate your scenario and validate the improvement first.

---
Chun-Yeow
