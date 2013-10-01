Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33062 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3JALOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:14:36 -0400
Message-ID: <524AAE97.5020708@openwrt.org> (sfid-20131001_131448_930474_FBB609FC)
Date: Tue, 01 Oct 2013 13:14:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: implement support for configuring antenna
 gain
References: <1378472763-36062-1-git-send-email-nbd@openwrt.org>  <1378472763-36062-2-git-send-email-nbd@openwrt.org> <1380625512.14430.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380625512.14430.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-01 1:05 PM, Johannes Berg wrote:
> On Fri, 2013-09-06 at 15:06 +0200, Felix Fietkau wrote:
>> Report the maximum allowable extra antenna gain to the driver to allow
>> it to reduce the tx power even further based on internal data
> 
> I don't quite understand the maximum thing here - what's a user to do
> who has an antenna that goes over? Is that then intended to not be
> supported? That seems odd. A very high gain antenna might just result in
> signal distortions, but what's the reason for limiting it this way?
Very high gain antennas are useful for long distance links.
The signal is not distorted, but focused directionally, which can easily
make it exceed regulatory EIRP limits, unless tx power is reduced
appropriately.
If the user explicitly configures the gain of the directional antenna
using this patch, mac80211 will reduce the maximum allowed tx power
setting to stay within the legal limit.

- Felix
