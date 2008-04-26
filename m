Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:17379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbYDZRFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 13:05:33 -0400
Received: by wa-out-1112.google.com with SMTP id m16so6732199waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2008 10:05:33 -0700 (PDT)
Message-ID: <1ba2fa240804261005h25d17fd4n72b6b07fee835ae3@mail.gmail.com> (sfid-20080426_190559_261540_9742BF2A)
Date: Sat, 26 Apr 2008 20:05:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH RFT] tkip: fix iv32 calculation in ieee80211_get_tkip_key()
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <1209226228.10943.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209081653.12561.50.camel@dv>
	 <1ba2fa240804260825qcae5777qddd2d1e91a0277dc@mail.gmail.com>
	 <1209226228.10943.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 26, 2008 at 7:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  It's a side product of testing a sparse patch by Linus Torvalds.
>  > >  Compile tested only.
>
>
> > >         iv32 = data[hdr_len + 4] +
>  > >  -               (data[hdr_len + 5] >> 8) +
>  > >  -               (data[hdr_len + 6] >> 16) +
>  > >  -               (data[hdr_len + 7] >> 24);
>  > >  +               (data[hdr_len + 5] << 8) +
>  > >  +               (data[hdr_len + 6] << 16) +
>  > >  +               (data[hdr_len + 7] << 24);
>  > >
>  > >   #ifdef CONFIG_TKIP_DEBUG
>  > >         printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
>  > >
>  > >
>  >
>  > We've tested TKIP code well and I'm not sure we wouldn't pay attention
>  > to such mistake.
>
>  But the code does look a bit fishy. I'm confused.

It  looks bad. Frankly  Pavel's version looks more correct but as
black box TKIP is working.
Maybe we never tested more then 256 wrapparounds.... will need to dig into more

Thanks
Tomas

>  johannes
>
