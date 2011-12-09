Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34733 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1LIJKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 04:10:43 -0500
Received: by vbbfc26 with SMTP id fc26so2142350vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 01:10:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323420593-9638-1-git-send-email-helmut.schaa@googlemail.com>
References: <1323420593-9638-1-git-send-email-helmut.schaa@googlemail.com>
Date: Fri, 9 Dec 2011 20:10:43 +1100
Message-ID: <CAJ-Vmo=7s67p8iQF3rt81vMPapOee=21J5wmT5PW8BiWuuev_Q@mail.gmail.com> (sfid-20111209_101050_127651_E09FD5F6)
Subject: Re: [RFC] mac80211: Send BAR on same queue as the according QoS frames
From: Adrian Chadd <adrian@freebsd.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 December 2011 19:49, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> Sending as RFC for now since I'm not sure if this is really required. At least
> I couldn't come up with a situation where this would be required. However, it
> looks more correct to me to put the BAR into the same queue as the previously
> failed QoS frame to avoid possible (?) side effect of the BAR overtaking frames
> in the hw tx queues ...

I've had to do this in FreeBSD, for more than just the BAR frame - I
do this for the ADDBA and null management frames too, just to be sure
that frames aren't dropped by the other end.

So, +1 from me. :)


Adrian
