Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64648 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2FNTji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 15:39:38 -0400
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"victorg@ti.com" <victorg@ti.com>
Subject: RE: [PATCH] nl80211: specify RSSI threshold when scanning
Date: Thu, 14 Jun 2012 19:39:37 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB90BECBC62@nasanexd02a.na.qualcomm.com> (sfid-20120614_213941_609928_01481FB4)
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
 <1339587447.3840.272.camel@cumari.coelho.fi>
 <4FD87FEA.3070208@qca.qualcomm.com> <20120613205007.GB3043@pista>
 <4FD984C1.8090903@qca.qualcomm.com>
In-Reply-To: <4FD984C1.8090903@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why then doesn't the host just stay asleep and let the firmware aggregate some scan results, and then fire those up in one message, waking the host up only once?



Adrian

-----Original Message-----
From: Valo, Kalle 
Sent: Wednesday, June 13, 2012 11:29 PM
To: Pedersen, Thomas
Cc: Luciano Coelho; Johannes Berg; ath6kl-devel; linux-wireless@vger.kernel.org; victorg@ti.com
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning

On 06/13/2012 11:50 PM, Pedersen, Thomas wrote:
> On Wed, Jun 13, 2012 at 02:56:26PM +0300, Kalle Valo wrote:
>
>> Funnily enough I don't have any idea how ath6kl has implemented this 
>> feature, but in theory this feature is useful also for the current 
>> normal scan (when the firmware/hardware supports it) as we can avoid 
>> host wakeups. If there are 10 APs, but all are below the RSSI 
>> threshold, we will have only 1 host wakeup (scan ready event) opposed 
>> to 11 wakeups
>> (10 AP found events plus 1 scan ready event).
> 
> But can the host even sleep on normal scans?

It's "implementation defined", the good ones can and bad ones can't :)

But from our (wireless developer) perspective we don't need to care about that, our job is to minimise all possible host wakeup events (timers, interrupts etc) as much as possible. That will allow the host to sleep more.

Kalle
