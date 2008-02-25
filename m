Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:39418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbYBYWuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:50:15 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2164688wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:50:14 -0800 (PST)
Message-ID: <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com> (sfid-20080225_225021_086595_C6FBAF5F)
Date: Tue, 26 Feb 2008 00:50:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: sta info locking
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1203972413.13162.163.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2008 at 10:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Fri, 2008-02-22 at 10:57 -0500, John W. Linville wrote:
>  > On Fri, Feb 22, 2008 at 04:16:49PM +0100, Johannes Berg wrote:
>  > >
>  > > > > Hence, I think we can actually get away without more locking if we
>  > > > > protect the flags better. Should we use a spinlock or the atomic
>  > > > > set_bit()/clear_bit()/etc. operations?
>  > > >
>  > > > Using the atomic operations seems appropriate to me.
>  > >
>  > > Right, but I figured if we could get rid of the AMPDU spinlocks and just
>  > > use a single one in total (for flags as well) then that'd be of benefit
>  > > too; even with the dynamic allocation strategy (see other mail) we'd not
>  > > need to allocate two more spinlocks for ampdu.
>  >
>  > Yes, I thought that was behind your question.  I'll let Ron comment
>  > on the AMPDU spinlock usage.
>
>  Ok so the mesh code came with a spinlock too, the AMPDU code has two.
>
>  Ron/Tomas, does the ampdu MLME really need two spinlocks?

The problem is that RX a TX BA establishments usually happens
concurrently for single STA, those are independent state machines.  We
have to review this carefully before spinlokcs are removed.

Thanks
Tomas
