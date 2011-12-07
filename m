Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:42539 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681Ab1LGKPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 05:15:40 -0500
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Bloat] Time in Queue, bufferbloat, and... our accidentally  interplanetary network
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Date: Wed, 07 Dec 2011 11:15:38 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	bloat <bloat@lists.bufferbloat.net>
In-Reply-To: <1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CAA93jw7kQYONQiAozatRmdRRJeK0GB9eNDWtRZ3AL+OVKn0OpA@mail.gmail.com>
 <1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <9dfc3c5eb811f2774b378fce0158b3e7@localhost> (sfid-20111207_111549_002067_F2234129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 05 Dec 2011 11:59:34 +0100, Eric Dumazet wrote:





> Adding a time limit is possible, all we need is a proper design and

> implementation :)

> 

> Here is my suggestion :

> 

> Design a new tfifo/tred qdisc, with following properties :

> 

> Adaptative RED, (ECN enabled + head drop), but instead of using

> bytes/packet qlen average, use time_in_queue average.



Question one: is anything wrong with sfb or choke as the basis, instead of

RED?



Question two: I submitted pfast_head_drop to drop more outdated data

instead of new data. Back in time I thought TCP _may_ experience benefits

because more up-to-date SACK data packets are saved. Are there any other

TCP advantages with head drop policy?



Hagen
