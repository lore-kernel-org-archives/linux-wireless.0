Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52909 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab2A1Svm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 13:51:42 -0500
Message-ID: <4F2443BB.3000602@openwrt.org> (sfid-20120128_195204_095223_457C6A73)
Date: Sat, 28 Jan 2012 19:51:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Marek Lindner <lindner_marek@yahoo.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de> <4F23F753.8070405@openwrt.org> <201201290243.47953.lindner_marek@yahoo.de>
In-Reply-To: <201201290243.47953.lindner_marek@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-28 7:43 PM, Marek Lindner wrote:
> On Saturday, January 28, 2012 21:25:39 Felix Fietkau wrote:
>> On 2012-01-28 8:17 AM, Marek Lindner wrote:
>> > Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
>> 
>> NACK, minstrel_ht sets RTS/CTS only from the second rate retry slot on,
>> to increase the success probability during retransmissions. For the
>> first slot, it is unset. The user supplied rts setting is not suitable
>> for configuring RTS/CTS usage this way, so if you want to disable it
>> entirely, you'd need to add a new setting for that.
> 
> If you think it is unsuitable do you mind elaborating what this setting is 
> for? As far as I can tell minstrel_ht is the only rate control algorithm that 
> decides to be smarter than the user configuring the device. Without mentioning 
> this anywhere! IMHO it should be minstrel_ht explaining why this makes sense, 
> not the other way round.
The user configurable RTS/CTS setting sets a threshold which is applied
to all transmission attempts with a packet size above it.
What minstrel_ht does is enable RTS/CTS only for on-chip retransmissions
of the second rate slot and below. That means as long as it doesn't fall
back to lower rates, no RTS/CTS gets used.
It's not about minstrel_ht being smarter than the user. It's about
adaptive control of RTS/CTS being smarter than a static setting.

- Felix
