Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46686 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1BFTmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 14:42:23 -0500
Message-ID: <4D4EF99D.5020601@openwrt.org>
Date: Sun, 06 Feb 2011 20:42:21 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com>
In-Reply-To: <4D4EF004.3040109@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-06 8:01 PM, Ben Greear wrote:
> Current code always sets the channel type to NO_HT when scanning.
> 
>  From what I can tell, we should be able to send NO_HT packets on
> any channel type, and for passive scanning, it should not matter
> at all what channel-type we are using.
> 
> I tested relaxing scanning to use the current channel type
> when scanning on the operating channel, and it seems to
> work.
> 
> Does anyone see any problems with this approach?
One thing you should make sure is that once you're done associating to
an NO_HT or HT20 AP (and you have no other interfaces to consider), the
channel mode must not be HT40 - otherwise it could reduce throughput.

- Felix
