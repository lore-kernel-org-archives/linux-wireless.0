Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3JALur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:50:47 -0400
Message-ID: <1380628244.14430.37.camel@jlt4.sipsolutions.net> (sfid-20131001_135050_549705_F49861C9)
Subject: Re: [PATCH 2/2] mac80211: implement support for configuring antenna
 gain
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 13:50:44 +0200
In-Reply-To: <524AAE97.5020708@openwrt.org>
References: <1378472763-36062-1-git-send-email-nbd@openwrt.org>
	  <1378472763-36062-2-git-send-email-nbd@openwrt.org>
	 <1380625512.14430.19.camel@jlt4.sipsolutions.net>
	 <524AAE97.5020708@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-01 at 13:14 +0200, Felix Fietkau wrote:
> On 2013-10-01 1:05 PM, Johannes Berg wrote:
> > On Fri, 2013-09-06 at 15:06 +0200, Felix Fietkau wrote:
> >> Report the maximum allowable extra antenna gain to the driver to allow
> >> it to reduce the tx power even further based on internal data
> > 
> > I don't quite understand the maximum thing here - what's a user to do
> > who has an antenna that goes over? Is that then intended to not be
> > supported? That seems odd. A very high gain antenna might just result in
> > signal distortions, but what's the reason for limiting it this way?
> Very high gain antennas are useful for long distance links.
> The signal is not distorted, but focused directionally, which can easily
> make it exceed regulatory EIRP limits, unless tx power is reduced
> appropriately.

Sure.

> If the user explicitly configures the gain of the directional antenna
> using this patch, mac80211 will reduce the maximum allowed tx power
> setting to stay within the legal limit.

I understand. I don't understand the pieces about "max_antenna_gain".

johannes

