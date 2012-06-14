Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17430 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2FNG32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 02:29:28 -0400
Message-ID: <4FD984C1.8090903@qca.qualcomm.com> (sfid-20120614_082933_244641_C73CE4B6)
Date: Thu, 14 Jun 2012 09:29:21 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<victorg@ti.com>
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com> <1339566003.4519.1.camel@jlt3.sipsolutions.net> <1339587447.3840.272.camel@cumari.coelho.fi> <4FD87FEA.3070208@qca.qualcomm.com> <20120613205007.GB3043@pista>
In-Reply-To: <20120613205007.GB3043@pista>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 11:50 PM, Pedersen, Thomas wrote:
> On Wed, Jun 13, 2012 at 02:56:26PM +0300, Kalle Valo wrote:
>
>> Funnily enough I don't have any idea how ath6kl has implemented this
>> feature, but in theory this feature is useful also for the current
>> normal scan (when the firmware/hardware supports it) as we can avoid
>> host wakeups. If there are 10 APs, but all are below the RSSI threshold,
>> we will have only 1 host wakeup (scan ready event) opposed to 11 wakeups
>> (10 AP found events plus 1 scan ready event).
> 
> But can the host even sleep on normal scans?

It's "implementation defined", the good ones can and bad ones can't :)

But from our (wireless developer) perspective we don't need to care
about that, our job is to minimise all possible host wakeup events
(timers, interrupts etc) as much as possible. That will allow the host
to sleep more.

Kalle
