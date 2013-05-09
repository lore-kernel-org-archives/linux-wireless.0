Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35885 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab3EIUdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 16:33:04 -0400
Message-ID: <518C07F6.9040003@openwrt.org> (sfid-20130509_223309_367279_12803035)
Date: Thu, 09 May 2013 22:32:54 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/8] mac80211: fix various components for the new 5 and
 10 MHz widths
References: <1368123036-22721-1-git-send-email-a> <1368123036-22721-3-git-send-email-a> <518BEB88.5090600@openwrt.org> <20130509194620.GA24307@pandem0nium>
In-Reply-To: <20130509194620.GA24307@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-09 9:46 PM, Simon Wunderlich wrote:
> Hello Felix,
> 
> On Thu, May 09, 2013 at 08:31:36PM +0200, Felix Fietkau wrote:
>> On 2013-05-09 8:10 PM, a@pandem0nium wrote:
>> > From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>> > 
>> > This is a collection of minor fixes:
>> >  * don't allow HT IEs in IBSS for 5/10 MHz
>> >  * don't allow HT IEs in Mesh for 5/10 MHz
>> >  * consider 5 and 10 MHz channels when downgrading
>> >  * don't try HT rates for 5 and 10 MHz channels when selecting rates
>> Why? HT rates work with 5/10 MHz just fine.
> 
> Hm, to be honest I did not try - IEEE 802.11-2012 only mentions 5 and
> 10 MHz channels in section 18 (OFDM PHY) according with timing and other
> parameters, but nothing like this (as far as I see) is mentioned in
> Section 20 (High Throughput PHY).
> 
> On the other hand, it appears that AR9xxx based chipsets also support
> 2.4 GHz rates (DSSS, ERP-OFDM), so I can imagine also HT rates can
> be supported as well.
> 
> The question is, how would we handle that? Allow HT IEs also for 5 and
> 10 MHz, and behave like it would be a 20 MHz channel?
Yes, I had 5/10 MHz running that way with a debugfs hack just fine.

> Are there any
> other WiFi chipsets which support 5/10 MHz, should we consider them
> (maybe they don't support that)?
No idea.

- Felix
