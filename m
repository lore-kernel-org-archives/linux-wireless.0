Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:25435 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYLHSRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 13:17:01 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1021819rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 10:17:00 -0800 (PST)
Message-ID: <445f43ac0812081017q2ac6ae1h84a86099518773cc@mail.gmail.com> (sfid-20081208_191707_820395_994F5D01)
Date: Mon, 8 Dec 2008 10:17:00 -0800
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 user space
Cc: igor_trindade@yahoo.com.br, "Jouni Malinen" <j@w1.fi>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228658260.22164.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <456087.50493.qm@web59308.mail.re1.yahoo.com>
	 <1228658260.22164.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Sun, Dec 7, 2008 at 5:57 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> For example, consider this scenario with three mesh points:
>
> MP1 ---- MP2 ---- MP3
>
> where MP1 and MP3 cannot directly communicate because they are too far
> apart, physically. It isn't possible to test such a scenario with hwsim
> because hwsim has no concept of distance.
>
> One easy solution to this would be to introduce "air groups", each just
> a number.
>
> [...]
>
> Does that make sense? Do you think it's flexible enough? Should we maybe
> use a u64 so we have more flexibility? It should be fairly easy to do
> this, I think.
>
>
> Of course, this isn't as general as it could be.

To be useful for our mesh tests this "virtual air" would have to allow
us to create 3 groups, each one a superset of the previous.  The
smallest group would be the set of nodes that can a node communicate
with ("A can talk to B").  The next larger group would be nodes on
which a node that can interfere ("A can screw up C's reception").
Finally, the largest would be nodes that can detect each other ("A can
detect when D is transmitting").

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
