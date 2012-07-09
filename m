Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2458 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2GINrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:47:47 -0400
Message-ID: <4FFAE0F7.1000601@broadcom.com> (sfid-20120709_154750_399235_251AF2DF)
Date: Mon, 9 Jul 2012 15:47:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	frankyl@broadcom.com, rvossen@broadcom.com, brudley@broadcom.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1340975210.4472.1.camel@jlt3.sipsolutions.net>
 <4FEDC3F0.1000201@net.t-labs.tu-berlin.de>
 <20120706193733.GC1879@tuxdriver.com> <4FF9E254.7090203@broadcom.com>
 <4FF9E3E5.6080202@net.t-labs.tu-berlin.de>
In-Reply-To: <4FF9E3E5.6080202@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2012 09:47 PM, Thomas Huehn wrote:
> Hi Arend,
> 
> This patch has the following goal. To implement Transmission Power
> Control (TPC) in the mac80211 subsystem, I remove the STA pointer from
> the ieee_tx_info structure to gain free mem for TPC annotation and I put
> the sta  on the stack to pass it to each driver function in the tx-path.
> The broadcom brcmsmac is the only driver where the ieee_tx_info is
> somewhat stored and therefore the sta point is not as straight removable
> as for the other drivers. This patch resolved that issue.
> Please have a look at my recent patch [PATCH] mac80211: Add transmit
> power control support (TPC) where I have included this one again with
> the full story in the code.
> 
> Greetings Thomas
> 

Hi Thomas,

I understand now. I just found the rate_driver_info somewhat obscure. I
looked into mac80211.h for the description and found that those fields
are intended for internal driver use. I will comment on the original patch.

Gr. AvS


