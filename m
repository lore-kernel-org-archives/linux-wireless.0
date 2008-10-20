Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31851 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYJTKKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 06:10:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 03:10:01 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.22627.103501.578126@gargle.gargle.HOWL> (sfid-20081020_121007_658867_C9AC1584)
Date: Mon, 20 Oct 2008 15:37:31 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224494669.18024.51.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<43e72e890810200214g16f847caqa6cbf724b7b7b625@mail.gmail.com>
	<1224494669.18024.51.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-10-20 at 02:14 -0700, Luis R. Rodriguez wrote:
> 
> > Indeed I agree with this. I think we can do this in three steps:
> > 
> > 1. resolve aggregation for now for ath9k
> 
> That's what Sujith's patch does, basically. It just leaves the Intel
> hooks in place.
> 
> > 2. resolve aggregation for amdpu_queue case. My suggestion here is to
> > use skb_buf_head (after Jouni's suggestion for our driver in fact),
> > and do not make use of a qdisc at all for this
> 
> I agree on both, but this is more of an implementation detail than an
> API description, which we really want to have first.


Would be nice if an interim fix is accepted temporarily,
until the architectural details of proper mac80211 aggregation
support for the 2 classes of HW are defined, and implemented.

Sujith
