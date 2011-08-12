Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52118 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1HLT1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:27:14 -0400
Received: by gwaa12 with SMTP id a12so2182110gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 12:27:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313175799.4022.23.camel@jlt3.sipsolutions.net>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
 <1312933511-9486-9-git-send-email-thomas@cozybit.com> <1312984078.4325.5.camel@jlt3.sipsolutions.net>
 <CAG6hwVNFUyt7VBEiaNpCoGFmt4eMbvexKA0pUtGi3sj3mwHgZQ@mail.gmail.com>
 <1313141481.4022.1.camel@jlt3.sipsolutions.net> <CAG6hwVMAkkv_OAemfEEGx9Tu3PmTqYq7vvBABw45omOXEx_p4A@mail.gmail.com>
 <1313175799.4022.23.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 12 Aug 2011 12:26:51 -0700
Message-ID: <CAPjQAd-fWbavhPPfvKQjdo=kkd3iegKiCyBrfvDXqeJ1z8HbRA@mail.gmail.com> (sfid-20110812_212718_646058_F286B919)
Subject: Re: [PATCH 8/8] {nl,cfg,mac}80211: let userspace make meshif mesh gate
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-08-12 at 12:00 -0700, Thomas Pedersen wrote:
>
>> iw mesh0 set mesh_param mesh_hwmp_rootmode=1
>> iw mesh0 set mesh_param mesh_gate_announcements=1
>>
>> And the connection between the two would only be apparent to someone
>> familiar with our limited implementation.

The draft defines three different ways to advertise gate over the
mesh, leaving the implementers choice of which one(s) to implement.
We chose the one that was best suited for the most common usage
scenario.  I would not call that a limited implementation but rather
"an efficient implementation of a bloated spec" :)

> Hmm. I wonder if it then makes sense to allow changing this on the fly
> at all?

Yes it does.  Gate announcements should only go out if a node has some
other interface connected to an external network.  If the external
interface goes down, one would want to stop gate announcements
immediately without bringing down the mesh interface.

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
