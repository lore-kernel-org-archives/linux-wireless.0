Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:43533 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaESOO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:14:58 -0400
Received: by mail-qg0-f52.google.com with SMTP id a108so8790151qge.39
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 07:14:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140519131832.GA6198@localhost>
References: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com>
 <20140519131832.GA6198@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Mon, 19 May 2014 16:14:36 +0200
Message-ID: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com> (sfid-20140519_161501_707481_64EAE420)
Subject: Re: 802.11s mode without HWMP
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 3:18 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, May 19, 2014 at 11:00:53AM +0200, Henning Rogge wrote:
>> Is there an easy way to stop HWMP in the 802.11s implementation?
>
> If I understand your use case, you want to basically remove the
> resolving part of mesh_nexthop_resolve()?  I don't believe the
> current implementation has a way to turn that off.  In principle,
> you can specify a vendor-specific path selection protocol when
> joining, but glancing at the existing code, we don't really do
> anything with that field except use it for peering fitness checks.

I have an IP router connected via ethernet to a radio with a single
wifi card, using the wifi card as a bridged radio. Its a great way to
build routers with lots of Wifi links because you can mount the
wifi-cards itself on the antenna and keep the router in a central
place.

I don't want to use layer-2 forwarding in the mesh because this
increases the broad-/multicast domain size and spams the available
frequencies even more.

> If all you want to do is force the paths, you can do so with the
> NL80211_CMD_SET_MESH_PATH API; such paths would override any selected
> by HWMP.  But you'd still generate PREQ/PREPs and get multihop
> communication in that case, it just wouldn't be subject to the
> airtime link metric.
>
> Perhaps we should skip resolve in case ifmsh->mesh_pp_id != 1
> and assume paths are somehow set up out of band or something?

I want to force 802.11s only to connect to other stations one layer-2
hop away. So no forwarding by intermediate stations.

Does the "mesh_fwding" parameter maybe help? Or can I set a "TTL" for
the PREQ messages to 1?

Henning Rogge
