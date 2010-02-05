Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:59989 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab0BETMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:12:38 -0500
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
Date: Fri, 5 Feb 2010 20:04:06 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com> <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com> <20100205175556.GC1496@holoscopio.com>
In-Reply-To: <20100205175556.GC1496@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002052004.06220.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 5. Februar 2010 18:55:56 schrieb Thadeu Lima de Souza Cascardo:

> I did not get automatic plinks for a peer.

The last time that happened I was using different checkouts of wireless-testing 
on both nodes and somebody had changed the code to match a new draft version 
in between.

And the one time before that there was a bug in the ath5k code, effectively 
preventing the device from beaconing.


> I want automatic plinks to work. But since I've started to play with it,
> why not make the command just work. It's there. If adding plinks
> manually to mesh nodes is not permitted, I may just send another patch,
> disallowing it entirely and making it explicit in code, comment and git
> log.

If I'm not mistaken the draft standard says that every node has to actively or 
passively scan for neighbors and automatically select candidate peers. A 
candidate peer has to announce a profile (Mesh Information Element) in its 
beacons that matches the local profile.

If manual addition of plinks is allowed you could theoretically force your 
node to peer with a neighbor running a different profile, e.g. using a different 
path selection or authentication algorithm, or an implementation based on a 
different draft version.

I can't really think of an use for it.

Just my 0.01$.

regards
Simon Raffeiner
