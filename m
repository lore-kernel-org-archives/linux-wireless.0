Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42022 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab3BHOQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:16:09 -0500
Message-ID: <511508A6.8020104@openwrt.org> (sfid-20130208_151613_869655_8CE1F6E4)
Date: Fri, 08 Feb 2013 15:16:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL>
In-Reply-To: <20757.1753.863278.858198@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-08 3:08 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> In many tests throughput with ath9k_rate_control has been shown to be
>> worse than with minstrel_ht (the mac8021 default RC).
>> 
>> This module also has some other problems, like starting to use the
>> highest possible rate early in the connection, causing problems with
>> reliability of connection/authentication attempts.
>> 
>> It also has a much more limited search space, ignoring many potentially
>> useful rates, caused by the design decision to operate on a sorted rate
>> set with the assumption that higher rates are always more unreliable
>> than lower rates. In some scenarios this assumption is not true, and
>> this can cause it to fall back to a really bad rate.
>> 
>> minstrel_ht has been tested extensively in AP and client mode by lots of
>> users (mostly in the OpenWrt project, where it has been the default for
>> years).
> 
> I don't think managed mode would have received much testing in OpenWRT.
I know quite a few people that use directional links with 4-addr
AP/Station. I also know a few people that put up some devices that roam
between multiple APs. Obviously it doesn't receive as much testing as AP
mode, but there are some active users stress testing it.

- Felix

