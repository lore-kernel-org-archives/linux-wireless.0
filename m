Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:39233 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYG3T1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:43 -0400
Received: by nf-out-0910.google.com with SMTP id d3so98142nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 12:27:42 -0700 (PDT)
Subject: Re: [ath5k-devel] [PATCH] ath5k: add Mesh Point support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: sbrown@cortland.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	YanBo <dreamfly281@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
In-Reply-To: <488DBF6E.10606@cortland.com>
References: <487fa7a8.14da600a.1aae.48b1@mx.google.com>
	 <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com>
	 <488D9E79.8050408@cortland.com>
	 (sfid-20080728_122546_840137_51FD7C0F) <1217247004.12662.3.camel@johannes.berg>
	 <488DBF6E.10606@cortland.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 30 Jul 2008 21:27:31 +0200
Message-Id: <1217446051.6379.231.camel@localhost> (sfid-20080730_212748_092544_09A53F9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 08:45 -0400, Steve Brown wrote:
> Although mesh path timeout seems to default to 5000ms, in my testing =
it=20
> takes about 50 min. Is this really the timeout that removes a node wh=
en=20
> it's beacon is off for this period?

=EF=BB=BF
When a mesh path timeouts it is marked accordingly and it is no longer
valid for routing. In a continuous traffic scenario this means that
every five seconds, the route are refreshed. Actually we start
refreshing one second before the route expires, so that we have a fresh
path before the current one times out.

Mesh path timeout does not _remove_ the path from the mesh path table,
so you will see it for a while, the table cleanup function which remove=
s
from the table paths that have expired long ago has a separate timing.

--=20
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
