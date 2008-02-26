Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:8431 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbYBZAan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 19:30:43 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2208179wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 16:30:42 -0800 (PST)
Message-ID: <1ba2fa240802251630n151a0accn4a1f814e6479e7c@mail.gmail.com> (sfid-20080226_003047_173306_2739039D)
Date: Tue, 26 Feb 2008 02:30:42 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: sta info locking
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1203983284.13162.196.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203677069.26341.52.camel@johannes.berg>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 <1203980105.13162.182.camel@johannes.berg>
	 <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com>
	 <1203981812.13162.187.camel@johannes.berg>
	 <1ba2fa240802251541r218d5f22j5b3490d20ab508e3@mail.gmail.com>
	 <1203983284.13162.196.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2008 at 1:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  Thanks. Yes, I do realize that this is a bit intrusive. On the other
>  > >  hand, I can't see the code holding the spinlock for longer code/periods
>  > >  of time (nor should it). Or do you think the driver is allowed to call
>  > >  into the AMPDU TX setup path while being called from the AMPDU RX setup
>  > >  path? That would be a bit weird.
>  > >
>  >
>  > TX and RX BA sessions are triggered from different threads of
>  > execution namely rate scaling and RX path. The protected sections are
>  > quite long IMHO including call outs to underlying driver. It is very
>  > likely that both sides decides for BA session at the same times.
>
>  Yes, but I still can't see how the driver would be calling both RX and
>  TX aggregation functions /within each other/. That's the only thing that
>  really matters since all the frame TX/RX is synchronized and thus the
>  spinlock can't really be contended. Anyway, I need to look deeper into
>  the code or just try or something.
>
>
>  > >  > Do you have any setup to check your these changes?
>  > >
>  > >  Unfortunately not quite yet. I have an 11n AP now though, but broke of
>  > >  one of the antennas, I'll need to see how well it works.
>  >
>  > That's bad 11n is too sensitive on antennas setup.
>
>  Yeah, I know. I don't know why my router has three antennas though
>  knowing that the Broadcom HW only has two chains.

Number of antennas is not the same as number of chains.  Also 4965 has
3 antennas but only 2 chains.   We have some fixes in that context
coming this week.
Tomas
