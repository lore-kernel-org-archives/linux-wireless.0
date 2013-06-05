Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29617 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3FEQ0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 12:26:22 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Wed, 5 Jun 2013 19:26:18 +0300
Message-ID: <7412006.ZKZ4jYJ2uB@lx-vladimir> (sfid-20130605_182625_132016_98C2D599)
In-Reply-To: <51AEF8F4.2020809@broadcom.com>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com> <1370420283.8920.21.camel@jlt4.sipsolutions.net> <51AEF8F4.2020809@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 05, 2013 10:38:12 AM Arend van Spriel wrote:
> >
> > The next step would be P2P-listen offload, which is more interesting for
> > being discoverable, and should also have probe request offload similar
> > to what we're discussing here.
> 
> 
> Ah, I thought that was included. The WFA spec is a bit confusing using 
> terms 'phases' and 'states'. There is a SCAN phase and a FIND phase. 
> During the FIND phase a device can be in SEARCH or LISTEN state. I know 
> it is all terminology, but I was confused. At least the commit message 
> seems to imply both states are offloaded.
> 
Arend,

you are correct. Briefly, P2P flow consists of the following phases:

1) scan - just regular scan, to find infrastructure ESS as well
2) find - in this phase, device toggles between states:
2.1) search - similar to scan on social channels, but not exactly. On 60g, search is _NOT_ scan
2.2) listen - similar to ROC on listen channel, but again, on 60g, listen is _NOT_ ROC

Then, this follows by GO negotiation etc.

Thanks, Vladimir
