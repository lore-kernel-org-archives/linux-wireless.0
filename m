Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1563 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1J1JHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 05:07:42 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 28 Oct 2011 02:07:21 -0700
Subject: RE: [RFC v2 13/12] cfg80211/mac80211: allow management TX to
 not wait for ACK
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0E375417@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20111028_110747_026657_E7300F11)
References: <20111021142322.229128720@sipsolutions.net>
 <1319743973.32221.4.camel@jlt3.sipsolutions.net>
 <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
 <CAGXE3d_9h-VMo3KaVThNXsXNVEAD4rVcKosMrjYVyKcfUD2=JQ@mail.gmail.com>
In-Reply-To: <CAGXE3d_9h-VMo3KaVThNXsXNVEAD4rVcKosMrjYVyKcfUD2=JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Helmut Schaa [mailto:helmut.schaa@googlemail.com]
> Sent: vrijdag 28 oktober 2011 9:52
> 
> On Fri, Oct 28, 2011 at 9:48 AM, Arend Van Spriel <arend@broadcom.com>
> wrote:
> > I would expect this to affect the duration field in the
> > 802.11 header to indicate the shorter use of the medium.
> > Going through your patch I am not sure this is done.
> 
> I don't think so since the frame will still be acked by the peer as it
> is
> a unicast management frame. But this will advise the hardware that it
> does not need to wait for the ack to happen since we're not interested
> in retrying it.
> 
> Helmut

Hi Helmut,

I understand. However, the commit message of this patch suggests we are
saving airtime, which does not seem the case if the duration field is
not taken into account. If the ACK is still transmitted we should not
touch the duration field so I guess my comment is only on the commit
message itself.

The whole duration field usage is another topic.

Gr. AvS

