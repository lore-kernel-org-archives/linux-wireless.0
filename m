Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38548 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdK0MC0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 07:02:26 -0500
Message-ID: <1511784144.5456.12.camel@sipsolutions.net> (sfid-20171127_130230_808749_D88FB83F)
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Marianna Carrera <mcarrera@quantenna.com>
Date: Mon, 27 Nov 2017 13:02:24 +0100
In-Reply-To: <20171115153547.kkunkrfcivoqcsq2@bars>
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
         <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
         <1510565429.30497.10.camel@sipsolutions.net>
         <20171113115841.3dcrcjqnp543kndi@bars>
         <1510575765.30497.38.camel@sipsolutions.net>
         <20171115153547.kkunkrfcivoqcsq2@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-15 at 18:35 +0300, Sergey Matyukevich wrote:

> In our case, we are experimenting with applications running along with
> hostapd and enabling band steering and client roaming functionality.
> As I mentioned, various approaches are being examined, including
> both pure nl80211-based approach as well as adding direct hooks
> to hostapd.

To be honest, I'm torn on this.

On the one hand, I think it's fairly reasonable functionality, but on
the other hand I'm not sure we should encourage such separate
approaches - it seems to me that will lead to a lot of fragmentation
and much harder debuggability for upstream where these things get used.

It's also a bunch of code we have to maintain, for nothing that seems
of use to the community - since it's the sort of flexibility explicitly
designed for non-public code (otherwise it could just be part of
hostapd; actually it could even if it were non-public, at least in
theory, unless you're planning it as a value-add thing to go with an
open source hostapd ...).

So while I don't want to stop you entirely in your tracks with this,
I'd really prefer you explore other options regarding where to put your
client steering functionality, perhaps even working on hostapd.

johannes
