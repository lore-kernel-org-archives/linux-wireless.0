Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:56308 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759196Ab0E0MJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 08:09:24 -0400
Message-ID: <4BFE60EF.7020800@free.fr>
Date: Thu, 27 May 2010 14:09:19 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	juuso.oikarinen@nokia.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: mark 1, 2, 5.5 and 11Mbps as mandatory rates
 for 802.11b
References: <1274883276.3658.15.camel@jlt3.sipsolutions.net>	 <20100527004545.11541.88667.stgit@tt-desk> <1274947716.3669.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1274947716.3669.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 27/05/2010 10:08, Johannes Berg a écrit :
> On Thu, 2010-05-27 at 09:45 +0900, Bruno Randolf wrote:
>> IEEE802.11-2007 clause 18.2.3.3 (p640) states that 1, 2, 5.5&  11 Mbits are
>> mandatory rates for what they call High Rate direct sequence spread spectrum
>> (HR/DSSS) PHY (with long PLCP).
>
> You're confused. Clause 18 is 11g, we knew that those were mandatory
> there, see the code you're modifying.
>
> Clause 15 is 11b, and it shouldn't change.
>
> So NACK.
>
> johannes

I just dig through the various standards and besides there are still 
some grey areas in my mind (like what is HR/DSSS/PBCC mentioned in 
Clause 18 or DSSS-OFDM as specified in Clause 19, hopefully both are 
optional), we have :

802.11a = Clause 17, called OFDM
802.11b = Clause 15 (called DSSS) & Clause 18 (called HR/DSSS).
802.11g = Clause 19, called ERP with lots of variants : ERP-DSSS/CCK, 
ERP-OFDM, ERP-PBCC
802.11n = Clause 20, called HT for High Throughput, which also includes 
DUP-OFDM

Clause 15 defines 1 Mbits and 2 Mbits rates, long PLCP only
Clause 18 defines 5.5 Mbits and 11 Mbits. Optionally, short PLCP is 
available for 2 Mbits, 5.5 Mbits and 11 Mbits. Since it's optional, such 
short PLCP rates are probably not part of the mandatory rates.

Basic rate set must includes mandatory rates set. This is apparently 
what every other AP do today and I indeed see no points in adding more 
rates to the basic rate set other than what is already defined in the 
mandatory rate set (except we cannot rely on this rule when joining an 
existing BSS/IBSS, of course).

Does the patch you posted is intended to create a 802.11b only or 
802.11bg AP/IBSS with a 802.11g hardware for instance?

Regards,
Benoit
