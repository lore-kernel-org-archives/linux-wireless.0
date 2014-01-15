Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaAOURh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 15:17:37 -0500
Message-ID: <1389817049.4338.27.camel@jlt4.sipsolutions.net> (sfid-20140115_211749_474029_DB43357C)
Subject: Re: [RFC 1/5] cfg80211: regulatory rules, fix bw checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 15 Jan 2014 21:17:29 +0100
In-Reply-To: <CALhHN=rpWARWuq4TUj2ZRnwUfRZzfs5=TLxj+7s9yaC36U7EOQ@mail.gmail.com> (sfid-20140115_170537_817111_C2FFDF5B)
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389720570-2430-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1389792228.4338.7.camel@jlt4.sipsolutions.net>
	 <CALhHN=rpWARWuq4TUj2ZRnwUfRZzfs5=TLxj+7s9yaC36U7EOQ@mail.gmail.com>
	 (sfid-20140115_170537_817111_C2FFDF5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 17:05 +0100, Janusz Dziedzic wrote:

> > We did discuss something like this previously (and see our todo list on
> > the wiki), but this isn't just some arbitrary internal change, it
> > completely changes the interpretation of the regulatory database.
> >
> 
> We need this because of such split DFS REG_RULE for ETSI:

In general, I totally think what you're proposing makes sense, and I
also think we should take it further like here:
http://wireless.kernel.org/en/developers/todo-list/regulatory

However I do think that should be considered carefully in terms of the
userspace impact/change.

> -       (5250 - 5330 @ 80), (N/A, 20), DFS
> -       (5490 - 5710 @ 80), (N/A, 27), DFS
> +       (5250 - 5330 @ 80), (N/A, 20), (60), DFS
> +       (5490 - 5590 @ 80), (N/A, 27), (60), DFS
> +       (5590 - 5650 @ 80), (N/A, 27), (600), DFS   // here different
> CAC time but still 80MHz should be available
> +       (5650 - 5710 @ 80), (N/A, 27), (60), DFS
> 
> In the future could be also usefull for 160MHz:
>         (5170 - 5250 @ 160), (N/A, 20)
>         (5250 - 5330 @ 160), (N/A, 20), DFS

Yes, the whole @xyz thing is a bit superfluous, I believe it should
really be @unlimited (meaning only restriction is that it fits) for most
countries.

> We can implement CAC time as hardcoded (already send such patches some
> time ago) one but seems this is close connected with regulatory
> configuration and seems like good idea put this in regulatory db.

I totally agree, this is a good idea.

johannes

