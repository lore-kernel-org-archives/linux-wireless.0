Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55039 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1IAOPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 10:15:30 -0400
Date: Thu, 1 Sep 2011 10:13:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jim Gettys <jg@freedesktop.org>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Tom Herbert <therbert@google.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Subject: Re: BQL crap and wireless
Message-ID: <20110901141304.GA2580@tuxdriver.com> (sfid-20110901_161539_372830_ABF430C6)
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com>
 <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com>
 <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com>
 <4E5C3B47.1050809@freedesktop.org>
 <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com>
 <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com>
 <4E5CEC79.3090802@freedesktop.org>
 <9BB251C1-A211-486D-A717-59149AC3A709@gmail.com>
 <4E5E36EE.8080501@freedesktop.org>
 <CAB=NE6Wj4BxSjZmTOg9EFMcJ+H0RBZE4q8+6DB3x8qP=r42yNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6Wj4BxSjZmTOg9EFMcJ+H0RBZE4q8+6DB3x8qP=r42yNQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 01:50:48PM -0700, Luis R. Rodriguez wrote:
> On Wed, Aug 31, 2011 at 6:28 AM, Jim Gettys <jg@freedesktop.org> wrote:

> > such as wireless, or even possibly modern broadband with
> > PowerBoost, classic RED or similar algorithms that do not take the
> > buffer drain rate cannot possibly hack it properly.
> 
> Understood, just curious if anyone has tried a Minstrel approach.

FWIW, eBDP and the related algorithms from Tianji Li's paper are
philosophically similar to minstrel.  They depend on measuring recent
conditions and modifying the current queue length accordingly.

	http://www.hamilton.ie/tianji_li/buffersizing.pdf

The hack I added in debloat-testing is based on my understanding
of eBDP.  It timestamps the SKBs when they are handed to the driver
for Tx and then checks the timestamp when the SKB is orphaned.  It is
a bit crude and is an abuse of the skb_orphan API.  Also while it
accounts for the 802.11e queues separately, it doesn't account for
802.11n aggregation.  Still, it seems to improve latency w/o hugely
impacting throughput in at least some environments -- YMMV!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
