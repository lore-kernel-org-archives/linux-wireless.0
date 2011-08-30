Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:20605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1H3DeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 23:34:23 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p7U3YM0m003813
	for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 20:34:22 -0700
Received: from iagk10 (iagk10.prod.google.com [10.12.212.10])
	by wpaz37.hot.corp.google.com with ESMTP id p7U3YLdg020629
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 20:34:21 -0700
Received: by iagk10 with SMTP id k10so1565504iag.30
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 20:34:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5C3B47.1050809@freedesktop.org>
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com>
	<CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
	<CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com>
	<4E5C3B47.1050809@freedesktop.org>
Date: Mon, 29 Aug 2011 20:34:20 -0700
Message-ID: <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com> (sfid-20110830_053426_583580_D193B012)
Subject: Re: BQL crap and wireless
From: Tom Herbert <therbert@google.com>
To: Jim Gettys <jg@freedesktop.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Computing the buffering in bytes is better than in packets; but since on
> wireless multicast/broadcast is transmitted at a radically different
> rate than other packets, I expect something based on time is really the
> long term solution; and only the driver has any idea how long a packet
> of a given flavour will likely take to transmit.

The generalization of BQL would be to set the queue limit in terms of
a cost function implemented by the driver.  The cost function would
most likely be an estimate of time to transmit a packet.  So C(P)
could represent cost of a packet, sum(C(P) for P queued) is aggregate
cost of queue packets, and queue limit is the maximum cost sum.  For
wired Ethernet, number of bytes in packet might be a reasonable
function (although framing cost could be included, but I'm not sure
that would make a material difference).  For wireless, maybe the
function could be more complex possibly taking multicast, previous
history of transmission times, or other arbitrary characteristics of
the packet into account...

I can post a new patch with this generalization if this is interesting.

Tom
