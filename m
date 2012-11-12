Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38935 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2KLRWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 12:22:42 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, <j@w1.fi>
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210)
Date: Mon, 12 Nov 2012 19:22:38 +0200
Message-ID: <1493513.loVaM5Pxv0@lx-vladimir> (sfid-20121112_182244_978434_CB2C1249)
In-Reply-To: <1352715356.9525.12.camel@jlt4.sipsolutions.net>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <9805542.8YLh3g7mqN@lx-vladimir> <1352715356.9525.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 12, 2012 11:15:56 AM Johannes Berg wrote:
> Ok, can you elaborate on the differences between PCP and AP, and their
> clients? I haven't had time to dig through the draft again

What comes to my mind: 

PBSS is new type of BSS introduced by 60g spec. Partially, it sorts out mess 
associated with IBSS; partially it helps to address 60g specifics.

PBSS is such a hybrid between ESS (infrastructure BSS) and IBSS.

PBSS can be established only with DMG (60G) stations.

PBSS features:

===Similar to IBSS===

- PBSS is ad-hoc network. Data frames use FromDS/ToDS combination 0/0
- stations communicate directly with each other.
- security: every STA implement both authenticator and supplicant roles
- STA use GAS to gather info about other STA's in the same PBSS

===Similar to ESS (infrastructure BSS)===

- there is dedicated coordination point, named PCP.
- PCP manages joining to the PBSS (association flow)
- only PCP transmits beacons. (in IBSS - every one)
- up to 254 STA may be associated with PCP (in IBSS - unlimited)
- PCP enforce uniform security policy (in IBSS each STA can enforce its own)

===Other===

- BSS type defined in beacon/probe resp etc.
- there is a protocol, called "PCP negotiation" that allows 2 STA to decide 
who will accept role of PCP, based on specific scan procedure. They compare 
"PCP factors" - something similar to P2P intents, but composed of various 
capability bits. Most importand bit is "AC powered" - if 1 STA is AC powered 
while 2-nd is battery powered, AC powered will be elected as PCP. And so on - 
idea is to elect more capable STA as PCP.
- there is no multicast in DMG network, since all data transmissions are 
directed. Due to this, if STA need to send mcast/bcast frame, it duplicates it 
for every STA within PBSS.
- there is protocol for PCP hand-off
- in 60g, P2P_GO is PCP by definition


To summarize client's POV:
- you know whether it is AP or PCP from scan results
- you associate with AP and PCP in the same way
- you set FromDS/ToDS bits differently for PCP and AP
- for PCP, you yse GAS to discover other STA's (query PCP)
- for PCP, you transmit to every STA in your PBSS directly
- for PCP, you duplicate Tx multicast frame for each STA.
