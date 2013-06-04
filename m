Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15422 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FDSal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 14:30:41 -0400
Date: Tue, 4 Jun 2013 21:30:23 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Message-ID: <20130604183023.GB6172@jouni.qca.qualcomm.com> (sfid-20130604_203047_808166_3B3BA06C)
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
 <2442077.aHiBPHBLmq@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2442077.aHiBPHBLmq@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 04, 2013 at 07:47:20PM +0300, Vladimir Kondratiev wrote:
> I am a bit confused. I supposed that if devices A and B (not in a group yet)
> try to discover each other, it works like the following
> 
> A ---- probe-req  ---> B (now B knows A)
> A <--- probe-resp ---- B (now A knows B)

This depends on what exactly you mean with "discover". Sure, it is known
that there is a P2P peer in the environment if a Probe Request frame
with P2P IE is received from it. However, that does not necessarily mean
we know enough of that peer to initiate new P2P operations.

> But if device is discovered by probe-resp only, it mean this should be
> 
> A ---- probe-req  ---> B
> A <--- probe-resp ---- B (now A knows B)
> A <--- probe-req  ---- B
> A ---- probe-resp ---> B (now B knows A)

Probe Response frames include more information about the peer and that
allows wpa_supplicant to complete the peer entry. This is the point when
the peer is fully known and indicated to upper layers. The Probe Request
frame RX case is just used internally within wpa_supplicant. (For
completeness, number of other frames, i.e., P2P Action frames, can also
complete the P2P peer entry, so this does not need to be Probe
Response).

-- 
Jouni Malinen                                            PGP id EFC895FA
