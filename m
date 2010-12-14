Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:44309 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120Ab0LNTY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 14:24:29 -0500
Date: Tue, 14 Dec 2010 20:24:21 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	jay.weihung@gmail.com
Subject: Re: [PATCH 14/17] rt2x00: Fix WMM Queue naming
Message-ID: <20101214192421.GA11764@sig21.net>
References: <201012131231.28313.IvDoorn@gmail.com>
 <201012131236.19791.IvDoorn@gmail.com>
 <201012131236.39071.IvDoorn@gmail.com>
 <201012141849.48488.helmut.schaa@googlemail.com>
 <AANLkTimMGtZsY-ZhbR4Nt7Mh4W8KSAfAhbe3yF07ezaO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTimMGtZsY-ZhbR4Nt7Mh4W8KSAfAhbe3yF07ezaO@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Dec 14, 2010 at 07:44:35PM +0100, Ivo Van Doorn wrote:
> >> The Queue names were incorrectly copied from the legacy drivers,
> >> as a result the queue names were inversed to what was expected.
> >>
> >> This renames the queues using this mapping:
> >>       QID_AC_BK -> QID_AC_VO (priority 0)
> >>       QID_AC_BE -> QID_AC_VI (priority 1)
> >>       QID_AC_VI -> QID_AC_BE (priority 2)
> >>       QID_AC_VO -> QID_AC_BK (priority 3)
> >>
> >> Note that this was a naming problem only, which didn't affect
> >> the assignment of frames to their respective queues.
> >>
> >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> >
> > Ivo, due to the latest info from Ralink I'd say we should drop this patch
> > and instead introduce a mac80211_to_rt2x00_qid mapper that maps from
> > ieee80211_ac_numbers to data_queue_qid.
> >
> > This patch doesn't cause any harm, but we would have to revert it partly
> > if we introduce the queue mapping as needed by the rt2x00 devices.
> 
> I don't agree, this patch can safely be applied, since the mapping
> is in the endpoint assignment, rather the register value usage,
> I think the more optimal solution is fixing rt2x00usb_assign_endpoints.
> In there it currently assigns endpoints assuming the first endpoint
> is the highest priority, while we should be able to simply swap that
> to invert the logic.

Inverting is not enough since the first OUT EP (EP1) is AC_BE,
while AC_BK (lowest priority) is EP2.  This corresponds to the
to the AC -> ACI mapping from 802.11 Table 7-36 in section
"7.3.2.29 EDCA Parameter Set element".  Probably the rationale
is that ACI value 0 should be the "default" AC.

Johannes
