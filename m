Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:65185 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYEFKMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:12:24 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1605752rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 03:12:24 -0700 (PDT)
Message-ID: <a32f33a40805060312o1ace5e69m681f0a6a0e8c42e8@mail.gmail.com> (sfid-20080506_121147_357260_D7CC431C)
Date: Tue, 6 May 2008 12:12:23 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] rt2500usb current git BUG
Cc: "Luis Correia" <luis.f.correia@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <1210067810.8012.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
	 <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com>
	 <1210066571.8012.73.camel@johannes.berg>
	 <a32f33a40805060249s2e20455fk88825329386b7475@mail.gmail.com>
	 <1210067810.8012.80.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/6/08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > But hadn't you removed the RTNL locking to make the multi-BSS code easier?
>
> Well, yes, but that applies mostly to mac80211's internal BSS/interface
> list handling. We still use the RTNL for list updates so iterating the
> list holding the RTNL is the way to go if you need schedulable access.

Ok excellent. I'll cook up a patch then. :)

> > I think I can code around the problem to make the ERP configuration do
> > a simple check if any interface has short preamble, and if that is the
> > case all interfaces will have short preamble. The same would go for
> > short slot time.
> > Apparently the current code was broken in that respect anyway since it
> > would assume the timing of the last interface in the list.
>
> I think that's not going to currently happen at all since we have no API
> for hostapd to set short slot/preamble at all! :) And this sort of
> complication is why we have no such setting, some hardware like b43 is
> able to set short preamble per frame (!) so there the setting could be
> per BSS, but hostapd would have to know.

Good point, the only time it is set is when the STA interface associates,
and since there is no support for multiple virtual STA interfaces or
mixed AP and STA interface the problem won't surface.. :)

> > As for the beaconing, the only location I cannot get around updating
> > the beacon in the driver from scheduled context is in the
> > suspend/resume path. And I believe resuming a mac80211 network
> > interface is already a source of problems anyway...
> > Well I'll dive a bit deeper into this and see what can be done about this.
>
> Feel free to add an iterator to mac80211 that uses the rtnl if that
> helps, adding more code to workaround the fact that it doesn't exist
> doesn't seem too hot since this was exactly added for that reason (and I
> think you're the only user of that iterator...)

Excellent, Thanks.

Ivo
