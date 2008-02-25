Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:59195 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbYBYXmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 18:42:00 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2187635wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 15:41:59 -0800 (PST)
Message-ID: <1ba2fa240802251541r218d5f22j5b3490d20ab508e3@mail.gmail.com> (sfid-20080225_234205_953436_79DA884B)
Date: Tue, 26 Feb 2008 01:41:59 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: sta info locking
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1203981812.13162.187.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 <1203980105.13162.182.camel@johannes.berg>
	 <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com>
	 <1203981812.13162.187.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2008 at 1:23 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  > The problem is that RX a TX BA establishments usually happens
>  > >  > concurrently for single STA, those are independent state machines.  We
>  > >  > have to review this carefully before spinlokcs are removed.
>  > >
>  > >  I wouldn't want to remove them, but it seems overkill two have two
>  > >  spinlocks. What I'd like to do is remove the ampdu tx, ampdu rx and mesh
>  > >  spinlocks and instead use just a single one for all three uses, and then
>  > >  use that one to protect the flags as well.
>  > >
>  > >  It seems to me that even if the RX/TX BA establishment is happening
>  > >  concurrently then it's still serialized by the frames on the air so
>  > >  ultimately can't actually happen on different CPUs so the lock won't be
>  > >  contended.
>  >
>  > I'm not sure about this, this is quite gentle and requires heavy
>  > testing.  I'll try to review this with Ron tomorrow and all other
>  > changes you've suggested.
>
>  Thanks. Yes, I do realize that this is a bit intrusive. On the other
>  hand, I can't see the code holding the spinlock for longer code/periods
>  of time (nor should it). Or do you think the driver is allowed to call
>  into the AMPDU TX setup path while being called from the AMPDU RX setup
>  path? That would be a bit weird.
>

TX and RX BA sessions are triggered from different threads of
execution namely rate scaling and RX path. The protected sections are
quite long IMHO including call outs to underlying driver. It is very
likely that both sides decides for BA session at the same times.

>  > Do you have any setup to check your these changes?
>
>  Unfortunately not quite yet. I have an 11n AP now though, but broke of
>  one of the antennas, I'll need to see how well it works.

That's bad 11n is too sensitive on antennas setup.

>
>  > Currently there is known possible deadlock when unloading driver while
>  > heavy HT traffic. This is happening while trearing down BA session. I
>  > need to solve this as well.
>
>  Interesting, where does it deadlock?

IIRC there is nice loop including queue lock need to dig the
description tomorrow to satisfy your curiosity.


Tomas
