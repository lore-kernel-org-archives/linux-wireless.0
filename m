Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46431 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967760AbXFHNfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 09:35:11 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: IEEE802.11e/WMM TS management and DLS support
Date: Fri, 8 Jun 2007 16:35:04 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E502A6AC1F@hasmsx412.ger.corp.intel.com>
In-Reply-To: <1181295029.6533.45.camel@johannes.berg>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>, "Jouni Malinen" <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>> Switch to DLS intelligently in the user space sounds good
>> but it doesn't relate to the kernel <-> user space API, you can do it
>> all in the user space.
>
> Actually, it does, because you do need all the information to make
that
> decision. I don't think we have per-MAC-address traffic statistics or
> something.

FWIW, need to take into consideration:

1) STA1 and STA2 are close to each other, but far from the AP. DLS will
most probably improve the link between them and the medium utilization.

2) STA1 and STA2 are far away from each other and the AP is between
them. DLS _may_ deteriorate the connection between STAs and the medium
utilization, or even may not be possible at all.

IMO, The decision to initiate a DLS link should _ideally_ be based not
only on the traffic properties but also on statistics of the actual rate
used between each of the participants including packets sent to/from the
peer STA (This is not easy as it requires the initiating STA to get into
promiscuous mode for some time while it is connected to the AP, prior to
establishing the DLS).

Perhaps providing the user a manual way to configure DLS connection
between two STAs is good enough for now and can be useful also later
when an intelligent method is in place.

Guy.
