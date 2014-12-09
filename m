Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:48857 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaLIQRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 11:17:06 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so4803601igd.8
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2014 08:17:05 -0800 (PST)
Date: Tue, 9 Dec 2014 11:14:05 -0500
From: Bob Copeland <me@bobcopeland.com>
To: deepak kumar Pradhan <hydipu@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mesh hwmp mpath service causes ping packet drop
Message-ID: <20141209161405.GJ28394@localhost> (sfid-20141209_171714_323530_F1B691F3)
References: <CAGKQeFifW2FGKUh_i0h4Nkw22biNLYz1T=bKZW2ZgrkFsp9aTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGKQeFifW2FGKUh_i0h4Nkw22biNLYz1T=bKZW2ZgrkFsp9aTQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 08, 2014 at 02:00:52PM +0530, deepak kumar Pradhan wrote:
> Hi,
> 
> I am using mesh network. Kernel ver 3.12.2.
> Scenario: When 2 wired and 1 wireless boards are forming mesh network,
> packets are dropped
> because of 'iw mesh0 mpath dump" changed entry.
> This case no Issue:
> // Own mac X:X:X:14:17:AD  -------> A     wireless
>                   X:X:X:10:3f:ad    -------> B     wired
>                   X:X:X:14:18:01    -------> C    wired
> # iw mesh0 mpath dump
> DEST ADDR         NEXT HOP          IFACE
> X:X:X:10:3f:ad    X:X:X:10:3f:ad   mesh0         //All traffic travels
> through this mesh peer
> X:X:X:14:18:01   X:X:X:14:18:01  mesh0
>  # iw mesh0 mpath dump        //Changed packet is dropped because of mpath entry
> DEST ADDR         NEXT HOP        IFACE
> X:X:X:10:3f:ad    X:X:X:14:18:01     mesh0
> X:X:X:14:18:01   X:X:X:14:18:01     mesh0

Are both B and C wired _and_ wireless, and A is wireless only?  So B and C
are mesh portals, to the same wired network?

If that's the case you need to enable STP on the bridges.

-- 
Bob Copeland %% http://bobcopeland.com/
