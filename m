Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f49.google.com ([209.85.216.49]:37602 "EHLO
	mail-vn0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbFYTIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 15:08:55 -0400
Received: by vnbf129 with SMTP id f129so12482040vnb.4
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 12:08:54 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
In-Reply-To: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 25 Jun 2015 12:08:53 -0700
Message-ID: <bf8dddcd2564399d6f0f70db7960e19e@mail.gmail.com> (sfid-20150625_210858_535817_376F072A)
Subject: RE: [PATCH] mac80211: mesh - always do every discovery retry
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Instead of stopping path discovery when a path is found continue
> > attempting to find paths until we hit the
> > dot11MeshHWMPmaxPREQretries limit.
>
> Let think about that if you have more nodes, you will probably flood
> the networks with more mgmt frame than previous implementation. It
> also increases the latency for data to be sent.

Yes, it will cause more management packets to be sent. PREQs will flood out
dot11MeshHWMPmaxPREQretries times and PREPs will be sent back but only along
the best path.

No it will not cause additional latency. Imagine a classic challenging
topology for mesh routing: four or more nodes arranged into a U where we
want to route from one end of the U to the other end. But the short direct
hop is very bad and the links along the U are all excellent.

Before what would happen is that we would first hear a PREP from the direct
hop (because the packets don't have to travel as far). We'd then select that
route because it has newer information than what we had previously. If we
got a PREP from the long path we'd then switch to that because it is just as
new and a better metric. But the longer that path the greater the chance
that we'll lose either a PREQ or a PREP. And because the PHY doesn't
retransmit management packets this happens rather often in practice. And if
we periodically refresh paths as currently happens we have even more
opportunities to select the wrong path.

Of course using multiple hops sucks but it sucks even more to use a 5 Mbps
link when 50 Mbps links are available.

> > This is important because path messages are not reliable and it is
> > relatively common to have a short bad path to the destination along
> > with a longer but better path. With the original code rather often a
> > path message along the long path would be lost so we would stick
> > with the
> bad path.
> > With this change we have a greater chance to get messages over the
> > longer path allowing us to select the long path if it's better.
>
> Try to take a look on the dot11MeshHWMPpreqMinInterval
> (mesh_hwmp_preq_min_interval) and
> (mesh_hwmp_active_path_timeout). I think that you can probably have
> more aggressive path selection interval by modifying these two values.

Not entirely sure what you mean about being more aggressive. If you mean
sending out the PREQs more rapidly that is something I have gone back and
forth on.  My current thinking is to do a few attempts quickly to try and
get a good path immediately and then lengthen the delay to try to compensate
for noise bursts.

> I don't think that flooding PREQ for resolved path not necessary a good
> case>
> for all. Thanks

It's just as important to do multiple discoveries for an established path as
for a brand new path. In either case if we send one PREQ out we'll often
fail to choose the right path.

> Chun-Yeow

  -- Jesse
