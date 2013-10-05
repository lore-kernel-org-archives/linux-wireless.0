Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42665 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3JELS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 07:18:57 -0400
Message-ID: <524FF599.5040706@openwrt.org> (sfid-20131005_131915_663385_ECB61BD5)
Date: Sat, 05 Oct 2013 13:18:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: implement support for configuring antenna
 gain
References: <1378472763-36062-1-git-send-email-nbd@openwrt.org>   <1378472763-36062-2-git-send-email-nbd@openwrt.org>  <1380625512.14430.19.camel@jlt4.sipsolutions.net>  <524AAE97.5020708@openwrt.org> <1380628244.14430.37.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380628244.14430.37.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-01 1:50 PM, Johannes Berg wrote:
> On Tue, 2013-10-01 at 13:14 +0200, Felix Fietkau wrote:
>> On 2013-10-01 1:05 PM, Johannes Berg wrote:
>> > On Fri, 2013-09-06 at 15:06 +0200, Felix Fietkau wrote:
>> >> Report the maximum allowable extra antenna gain to the driver to allow
>> >> it to reduce the tx power even further based on internal data
>> > 
>> > I don't quite understand the maximum thing here - what's a user to do
>> > who has an antenna that goes over? Is that then intended to not be
>> > supported? That seems odd. A very high gain antenna might just result in
>> > signal distortions, but what's the reason for limiting it this way?
>> Very high gain antennas are useful for long distance links.
>> The signal is not distorted, but focused directionally, which can easily
>> make it exceed regulatory EIRP limits, unless tx power is reduced
>> appropriately.
> 
> Sure.
> 
>> If the user explicitly configures the gain of the directional antenna
>> using this patch, mac80211 will reduce the maximum allowed tx power
>> setting to stay within the legal limit.
> 
> I understand. I don't understand the pieces about "max_antenna_gain".
Right now ath9k has an antenna gain value in the EEPROM, and it compares
it against the channel max_antenna_gain value.

Let's assume we have configured the tx power to the maximum value, the
regdb allows 3 dB antenna gain, and the ath9k EEPROM contains an antenna
gain of 3 dB as well.
If we now add another 3 dB of user-configured antenna gain, it first
starts tapping into the regulatory-allowed antenna gain before reducing
tx power in mac80211. The driver needs to know about this, so I put the
calculated maximum antenna gain into the hw conf as well.

- Felix
