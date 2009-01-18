Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60070 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZARPdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 10:33:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 07:33:15 -0800
Date: Sun, 18 Jan 2009 07:32:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: do not TX injected frames when not allowed
Message-ID: <20090118153243.GU29609@tesla> (sfid-20090118_163320_937331_5BE04CC5)
References: <1232131932-25044-1-git-send-email-lrodriguez@atheros.com> <1232268339.3877.5.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232268339.3877.5.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 12:45:39AM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 10:52 -0800, Luis R. Rodriguez wrote:
> > Monitor mode is able to TX by using injected frames. We should
> > not allow injected frames to be sent unless allowed by regulatory rules.
> > Since AP mode uses a monitor interfaces to transmit management frames
> > we have to take care to not break AP mode as well. Since hostapd
> > respects 'no-ibss|radar' flags we can make use of the same policy
> > statically for checking when to disable injected frames. Once AP
> > mode supports radar detection we should somehow distinguish a
> > regular monitor mode from an AP's monitor interface.
> 
> Any proposal for "somehow"? I'm not all that worried about packet
> injection here.

I'll send a patch instead. Keep in mind by not applying this you are
allowing devices to not respect regulatory rules.

  Luis
