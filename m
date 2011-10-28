Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1J1JQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 05:16:02 -0400
Subject: RE: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not
 wait for ACK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0E375417@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20111021142322.229128720@sipsolutions.net>
	 <1319743973.32221.4.camel@jlt3.sipsolutions.net>
	 <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
	 <CAGXE3d_9h-VMo3KaVThNXsXNVEAD4rVcKosMrjYVyKcfUD2=JQ@mail.gmail.com>
	 <400C43189542CE41BC0A5B252FC90136BC0E375417@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 11:15:55 +0200
Message-ID: <1319793355.8931.4.camel@jlt3.sipsolutions.net> (sfid-20111028_111607_341374_1D21C1F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 02:07 -0700, Arend Van Spriel wrote:
> > From: Helmut Schaa [mailto:helmut.schaa@googlemail.com]
> > Sent: vrijdag 28 oktober 2011 9:52
> > 
> > On Fri, Oct 28, 2011 at 9:48 AM, Arend Van Spriel <arend@broadcom.com>
> > wrote:
> > > I would expect this to affect the duration field in the
> > > 802.11 header to indicate the shorter use of the medium.
> > > Going through your patch I am not sure this is done.
> > 
> > I don't think so since the frame will still be acked by the peer as it
> > is
> > a unicast management frame. But this will advise the hardware that it
> > does not need to wait for the ack to happen since we're not interested
> > in retrying it.

> I understand. However, the commit message of this patch suggests we are
> saving airtime, which does not seem the case if the duration field is
> not taken into account. If the ACK is still transmitted we should not
> touch the duration field so I guess my comment is only on the commit
> message itself.

Oh good points ...
The reason we save airtime is that often the frame will be retransmitted
a lot if the station is no longer paying attention.

johannes

