Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:57926 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaIPXrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2014 19:47:49 -0400
Date: Wed, 17 Sep 2014 01:47:43 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
Message-ID: <20140916234647.GA2238@sesse.net> (sfid-20140917_014752_317985_A204746F)
References: <20140903133328.GC18933@sesse.net>
 <E1XPB2h-0008WO-MS@pannekake.samfundet.no>
 <1410166400.7983.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1410166400.7983.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2014 at 10:53:20AM +0200, Johannes Berg wrote:
>> Linux already supports 802.11h, where the access point can tell the
>> client to reduce its transmission power. However, 802.11h is only
>> defined for 5 GHz, where the need for this is much smaller than on
>> 2.4 GHz.
>> 
>> Cisco has their own solution, called DTPC (Dynamic Transmit Power
>> Control). Cisco APs on a controller sometimes but not always send
>> 802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
>> for parsing and honoring the DTPC IE in addition to the 802.11h
>> element (they do not always contain the same limits, so both must
>> be honored); the format is not documented, but very simple.
>> 
>> Tested (on top of wireless.git and on 3.16.1) against a Cisco Aironet
>> 1142 joined to a Cisco 2504 WLC, by setting various transmit power
>> levels for the given access points and observing the results.
>> The Wireshark 802.11 dissector agrees with the interpretation of the
>> element, except for negative numbers, which seem to never happen
>> anyway.
> Applied both.

I found what I believe is an edge case: What happens if the element suddenly
goes away from one beacon to another? Shouldn't there be a reset of the power
level and then a new call to __ieee80211_recalc_txpower()?

(If so, I believe this bug was already present in the code before my first
patch, as I understand the existing logic.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
