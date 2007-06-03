Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:50661 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXFCTeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 15:34:17 -0400
Received: by an-out-0708.google.com with SMTP id d31so290174and
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2007 12:34:17 -0700 (PDT)
Message-ID: <8e6f94720706031234y77761bb8m8abeda67d48f9dd5@mail.gmail.com>
Date: Sun, 3 Jun 2007 15:34:17 -0400
From: "Will Dyson" <will.dyson@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
Cc: linux-wireless@vger.kernel.org,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	"Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <8e6f94720705260851k34c3d1fam16ab96c13375b11d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
	 <200705251805.25696.flamingice@sourmilk.net>
	 <8e6f94720705252110k46be0397v5f446aabdf34fe3f@mail.gmail.com>
	 <200705252224.18457.flamingice@sourmilk.net>
	 <8e6f94720705260851k34c3d1fam16ab96c13375b11d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/26/07, Will Dyson <will.dyson@gmail.com> wrote:
> On 5/26/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Friday 25 May 2007 21:10, Will Dyson wrote:
> > > On 5/25/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > > > On Friday 25 May 2007 16:37, Will Dyson wrote:
> > > > > But I've got ton's of these in my log:
> > > > >
> > > > >  BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
> > > >
> > > > Do you have CONFIG_NET_SCHED on?
> > >
> > > I do not have it set in this kernel. Should I?
> > It may help. mac80211 didn't work correctly without it before and I'm not
> > entirely sure if it works correctly now without that.
>
> Ok. I'll try it.
>
> For what it's worth, I can no-longer reproduce this error (although it
> was reproducible across several reboots yesterday).

Followup:

The warning did eventually show up again in the kernel without
CONFIG_NET_SCHED. Runing a week with CONFIG_NET_SCHED without a
recurrence. So that seems to have solved it.

If mac80211 needs CONFIG_NET_SCHED, shouldn't mac80211 select or depend on it?

-- 
Will Dyson
