Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36293 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab3BHOEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:04:21 -0500
Message-ID: <511505E1.9080009@openwrt.org> (sfid-20130208_150424_313449_F5604662)
Date: Fri, 08 Feb 2013 15:04:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20756.65038.7020.514691@gargle.gargle.HOWL>
In-Reply-To: <20756.65038.7020.514691@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-08 2:30 PM, Sujith Manoharan wrote:
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
>> 
>> The only advantage that ath9k_rate_control previously had over minstrel_ht
>> was the support for using CCK rates as fall back in case MCS rates got
>> too bad, but this has now also been taken care of.
> 
> Various rates are marked as invalid in the ath9k rate control module. I don't
> know all the reasons, but the recommendation to disable certain rates came from
> the internal algorithms team. How will this be handled ?
I'm pretty sure it's because the algorithm isn't designed to handle more
rates. It's a step-up/step-down type algorithm, and those typically only
work with a sorted rateset, preferably duplicate free.

Minstrel_ht selects rates in a different way that doesn't have the same
limitations, so it can use the full rateset.

- Felix

