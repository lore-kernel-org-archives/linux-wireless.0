Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f52.google.com ([209.85.216.52]:38128 "EHLO
	mail-vn0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbbFZTBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 15:01:05 -0400
Received: by vnbf129 with SMTP id f129so2254809vnb.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 12:01:04 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
	<4bd697c41f2bb66593c849246bde7b00@mail.gmail.com> <CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
In-Reply-To: <CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 26 Jun 2015 12:01:03 -0700
Message-ID: <b193de6c0b11af0193414a217f0ea56b@mail.gmail.com> (sfid-20150626_210110_745148_BE878E5B)
Subject: RE: [PATCH] mac80211: mesh - always do every discovery retry
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you have more 10 nodes, all the nodes will have to re-broadcast this
> PREQ
> mgmt frame (broadcast/multicast) 4 times more than previous
> implementation.

Sure, you're paying a constant cost every time paths refresh to give you
better odds of selecting a good path. But this is a small relatively
infrequent cost (and could be made more infrequent: unless the environment
is very dynamic it doesn't seem necessary to always periodically refresh).
And it's not like selecting a bad path is without costs: users may not be
able to push their data through the path and if it's less reliable TCP
performance may turn to crap and retries may chew up the air.

We have already have ARP flooding discussion on o11s
> mailing list that day (http://lists.open80211s.org/pipermail/devel/2015-
> June/003685.html).
> Bob has even mentioned about multicast-to-unicast conversion for ARP
> packet. Don't think that this is good idea doing the same with PREQ.

The ARP flooding issue sounded more like an actual storm which should never
happen with PREQs.

> > No it will not cause additional latency. Imagine a classic challenging
> > topology for mesh routing: four or more nodes arranged into a U where
> > we want to route from one end of the U to the other end. But the short
> > direct hop is very bad and the links along the U are all excellent.
> >
> > Before what would happen is that we would first hear a PREP from the
> > direct hop (because the packets don't have to travel as far). We'd
> > then select that route because it has newer information than what we
> > had previously. If we got a PREP from the long path we'd then switch
> > to that because it is just as new and a better metric. But the longer
> > that path the greater the chance that we'll lose either a PREQ or a
> > PREP. And because the PHY doesn't retransmit management packets this
> happens rather often in practice.
>
> Maybe take a look on the driver site of the WiFi chipset that you used?

How is looking at the PHY going to help?. Originally you said the patch
would cause additional latency and I don't think that's true. We still
select paths exactly as before so when we construct the first path data will
be able to flow. Only difference is that we may select a different path
later (which also happened before just not as often as it would with the
patch).

> > And if
> > we periodically refresh paths as currently happens we have even more
> > opportunities to select the wrong path.
>
> Periodically refresh the paths, you mean in 5s interval guarded by
> dot11MeshHWMPactivePathTimeout, right? You can reduce this using iw
> utility if you want. If you reduce this, solve your problem?

No I mean the expiry time. Every 30s or so paths are refreshed. Lowering
dot11MeshHWMPactivePathTimeout won't do much other than give you more path
refreshes, each of which will have the same chance to select badly.

> > Not entirely sure what you mean about being more aggressive. If you
> > mean sending out the PREQs more rapidly that is something I have gone
> > back and forth on.  My current thinking is to do a few attempts
> > quickly to try and get a good path immediately and then lengthen the
> > delay to try to compensate for noise bursts.
>
> Not a good idea of PREQ flooding if the path already been established.

Whether the path is already established or not is immaterial. In either case
there is the potential for selecting a bad path when the first PREQ is sent
out. In either case you have to balance the cost of sending additional path
messages out with the cost of selecting the wrong path.

> > It's just as important to do multiple discoveries for an established
> > path as for a brand new path. In either case if we send one PREQ out
> > we'll often fail to choose the right path.
> >
>
> As mentioned in section 13.10.8.5 Repeated attempts at path discovery,
> dot11MeshHWMPmaxPREQretries is used to limit number of "repeated" or
> "retried" attempts on path discovery. So if the path has successfully
> established, you move to path maintenance and don't repeat the attempt.

The code flow for discovery at the originator is the same when paths are
constructed and when they are refreshed. For a new path mesh_nexthop_resolve
will create a new mpath with flags set to zero and then queue up a PREQ with
PREQ_Q_F_START set. For refresh mesh_nexthop_lookup will check exp_time and
if it has expired queue up a PREQ with PREQ_Q_F_START. In both cases
mesh_path_start_discovery will start up a brand new discovery doing up to
dot11MeshHWMPmaxPREQretries attempts. The code flow is a bit different
downstream but that doesn't affect this discussion.

Nothing has changed with the patch other than that we'd always do each
attempt. Which I believe is legal per the section you referenced:  "Repeated
attempts by a mesh STA at path discovery towards a single target shall be
limited to dot11MeshHWMPmaxPREQretries.".

> This patch may work well for your case, but not for others since the
> network
> behavior may change with more broadcast/multicast mgmts frame in the
> MBSS.

Of course it's always possible to imagine scenarios where a particular
feature may not be useful. For example a network with no bad links. But that
doesn't seem too fruitful.

Your big worry seems to be that flooding 4x as many PREQs is too expensive.
I don't think that's the case. The PREQs are broadcast so they'll go one
hop. And when they are received they will only be re-broadcast if they
arrived on a better path. This is not any worse than something like site
local multicast and we would only be flooding an additional *three* packets.

My big worry is that we will select bad paths. And this *will* happen. I've
seen it many times. And if it does happen the effects are not theoretical;
they are by definition bad. We *have* selected a bad path after all. And
when we select a bad path it will be very apparent to end users. Bandwidth
will be lower than it should be and loss may go up as well.

  -- Jesse
