Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1HXUGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 16:06:12 -0400
Received: by wyg24 with SMTP id 24so1127789wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 13:06:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824193224.GL9770@tuxdriver.com>
References: <1314213161-8871-1-git-send-email-linville@tuxdriver.com>
	<CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
	<20110824193224.GL9770@tuxdriver.com>
Date: Wed, 24 Aug 2011 13:06:11 -0700
Message-ID: <CAG6hwVMWMGXZMfnQSLQD6BCSG0kuP_0C6rKs_XYwmK4v7esRsQ@mail.gmail.com> (sfid-20110824_220626_289476_20FFAD39)
Subject: Re: [PATCH] mac80211: refactor skb copy to failq in mesh_path_move_to_queue
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:32 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Aug 24, 2011 at 12:27:29PM -0700, Thomas Pedersen wrote:
>> On Wed, Aug 24, 2011 at 12:12 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > This seems a bit less awkward, and avoids the following warning:
>> >
>> >  CC [M]  net/mac80211/mesh_pathtbl.o
>> > net/mac80211/mesh_pathtbl.c: In function ‘mesh_path_move_to_queue’:
>> > net/mac80211/mesh_pathtbl.c:291:24: warning: ‘cp_skb’ may be used uninitialized in this function
>>
>> cp_skb was initialized to NULL in v2 of "mac80211:  mesh gate implementation'
>>
>> >
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> > ---
>> > Does it matter if the copy ends-up on the failq before the original goes
>> > to the gateq?
>> >
>> >  net/mac80211/mesh_pathtbl.c |    8 ++++----
>> >  1 files changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
>> > index 75e4b60..b5caf5b 100644
>> > --- a/net/mac80211/mesh_pathtbl.c
>> > +++ b/net/mac80211/mesh_pathtbl.c
>> > @@ -307,14 +307,14 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
>> >
>> >        while (num_skbs--) {
>> >                skb = __skb_dequeue(&failq);
>> > -               if (copy)
>> > +               if (copy) {
>> >                        cp_skb = skb_copy(skb, GFP_ATOMIC);
>> > +                       if (cp_skb)
>> > +                               __skb_queue_tail(&failq, cp_skb);
>> > +               }
>> >
>> >                prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
>> >                __skb_queue_tail(&gateq, skb);
>> > -
>> > -               if (copy && cp_skb)
>> > -                       __skb_queue_tail(&failq, cp_skb);
>> >        }
>>
>> However, this does look nicer. Please be sure to apply the version
>> submitted on 11 August.
>
> You just told me yesterday to apply the 9 August version???
>

OK that is confusing. I meant 9 August version of patch 1/8 only, the
rest should be 11 August.

> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
