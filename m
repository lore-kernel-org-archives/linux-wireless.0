Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:47082 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYFIRdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:33:55 -0400
Received: by py-out-1112.google.com with SMTP id p76so1068380pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 10:33:54 -0700 (PDT)
Subject: Re: [PATCH 3/7] mac80211: add utility function to get header length
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213032261.22220.6.camel@johannes.berg>
References: <1212774672.6340.77.camel@brick>
	 <1213002964.698.67.camel@johannes.berg>
	 <1ba2fa240806090301h2a1a3350x606cfe1d83be066a@mail.gmail.com>
	 <1213028660.5974.9.camel@brick>
	 (sfid-20080609_182426_913011_F2C185A1)  <1213032261.22220.6.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 10:33:43 -0700
Message-Id: <1213032823.5974.26.camel@brick> (sfid-20080609_193358_558017_9339A05F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 19:24 +0200, Johannes Berg wrote:
> > > So I guess will we converting idioms
> > > u16 fc = le16_to_cpu(hdr->frame_control);
> > > int hdr_len = ieee80211_get_hdrlen(fc);
> > > to
> > > int hdr_len = ieee80211_hdrlen(hdr->frame_control)
> > > 
> > > This is how it used in driver code so it make sense to export this
> > > function and remove ieee80211_get_hdrlen(fc)
> > 
> > Yes, that was my thinking, I just did it this way to avoid the flag day
> > change, I'll trickle the changes in and then remove _get_hdrlen.
> 
> Sounds good to me.
> 

OK, will keep going on this then.

> > > Since all fc operations are bitwise 'and' and 'or'
> > > u16 rx->fc can be dropped in future as well
> > 
> > I was going to convert it to a __le16, but if it is just a copy of the
> > ->frame_control in the header, I'll look at removing it instead.
> 
> Yeah, I think rx->fc was meant to be a cpu-byteorder copy of
> hdr->frame_control to avoid repeated byteswapping. If we do all
> operations on the constants instead as you're doing with this series, we
> ought to be able to remove it. Bonus point: that gets rid of the
> possible "rx->fc is out of sync" issue we had to fix once already.

That and be arches eliminate a bunch of byteswaps.

Cheers,

Harvey

