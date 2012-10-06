Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34400 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2JFPMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 11:12:38 -0400
Message-ID: <50704A5E.7040002@openwrt.org> (sfid-20121006_171243_394461_711FA973)
Date: Sat, 06 Oct 2012 17:12:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org>  <20121005202220.GA1929@tuxdriver.com> <506F4AFE.2090301@broadcom.com>  <506F69FF.5090701@openwrt.org> <506FE541.3090706@broadcom.com>  <50702371.40508@openwrt.org> <1349534867.10251.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349534867.10251.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-06 4:47 PM, Johannes Berg wrote:
> On Sat, 2012-10-06 at 14:26 +0200, Felix Fietkau wrote:
> 
>> > I was not understanding the usage scenario here. Your patch will ignore 
>> > any driver initialized max antenna gain, which does not sound right to 
>> > me. What if chan->orig_mag is a sensible (non-zero) value, which is 
>> > lower than the value in regulatory power rule? Just seems that the patch 
>> > changes more than the commit message it saying.
>> I did take another close look at the code and it seems you're right. I
>> will change the code so that it initializes chan->orig_mag to INT_MAX in
>> wiphy_register, and I will make the patch description a bit more verbose
>> as well.
>> That way the chan->max_antenna_gain value supplied by the driver gets
>> ignored, which is a good thing, considering that only one driver
>> actually uses max_antenna_gain, and no driver initializes it to
>> something useful.
> 
> I know we need the "limit to driver value" behaviour for TX power for
> sure (otherwise the firmware would assert if it goes over)
Sure. This isn't really necessary for max_antenna_gain though, it's up
to the driver if it even wants to make use of this (mac80211 doesn't).
ath9k uses it to check if tx power needs to be reduced, when an
eeprom-specified antenna gain exceeds the regulatory max antenna gain.

I only noticed this, because I'm going to submit a patch soon to add a
configurable antenna gain to nl80211/mac80211. It is useful for setups
where you have a highly directional antenna with a big antenna gain and
want to make sure that the txpower stays within legal limits.

- Felix
