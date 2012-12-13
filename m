Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41339 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab2LMRZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 12:25:41 -0500
Message-ID: <50CA0F8B.3060905@openwrt.org> (sfid-20121213_182546_590286_82AA7576)
Date: Thu, 13 Dec 2012 18:25:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de> <20121213140753.GA26868@pandem0nium>
In-Reply-To: <20121213140753.GA26868@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-13 3:07 PM, Simon Wunderlich wrote:
> Hey there,
> 
> just to bump the issue again - isn't there anyone here who can answer
> some of these questions?
> 
> Adrian gave me some hints, but the FFT format is still completely unclear
> - I would really like to integrate/fix things before bringing this patch(set)
> to the next level.
> 
> I'm begging all the Qualcomm/Atheros-affiliated guys on the list to have
> a look on the questions below and help me out here. :)
> 
> Thanks a lot!
> 	Simon
> 
> On Thu, Dec 06, 2012 at 05:36:07PM +0100, Simon Wunderlich wrote:
>> This patch(set) is the second iteration of the request for comments for
>> upcoming spectral scan feature. It adds spectral scan control and dump
>> features to debugfs. When the open questions regarding interpretation
>> are answered, I would like to build an interface to nl80211/mac80211.
>> Please see the open questions below, every hint is kindly appreciated. :)
>> 
>> This feature has been enabled for AR92xx and AR93xx based chipsets.
>> We've also written a visual evaluation program for these samples (see
>> screenshot [1] and sourcecode [2]).
>> 
>> Many details are not known due to the fact that I don't have access to
>> Atheros specifications and details. Many things are done by guessing
>> and might be wrong. I'm therefore requesting help from Qualcomm/Atheros
>> guys to confirm or correct my findings. Apart from that, after
>> discussion I think we could integrate this patchset to allow other
>> people to work on this as well, even if it is experimental now.
>> 
>> Questions from my end:
>>  1. There are many TODOs/Comments in the patches regarding details,
>>     please answer if you can. :)
> 
> See code comments, e.g. regarding phy error type which are not defined
> in the headers, etc.
Here's how to detect usable PHY error reports: Check for PHY error types
RADAR (5), FALSE_RADAR_EXT (24) or SPECTRAL (38). If it's 38, no further
validation is necessary. In the other cases, check the last byte
(bwinfo). If it has bit 4 set, the data is usable for spectral.

>>  2. The output format is very Atheros-dependent. If my finding that 
>>     byte n-4 is some kind of offset/exponent, I'd integrate this in
>>     the debugfs output as well
Here's my understanding of the data format:

HT20:
56 bytes bin magnitude data (8 bits per bin)
3 bytes bin maximum values (see below)
1 byte exponent:
	[3:0] - number of bits to shift the magnitude data

HT40:
128 bytes bin magnitude data (64 lower bins, 64 upper bins)
3 bytes lower bin maximum values (see below)
3 bytes upper bin maximum values (see below)
1 byte exponent (like HT20)

Bin maximum values:
Byte 1: [1:0] - max_magnitude[1:0]
        [7:2] - bitmap_weight[5:0]
Byte 2: [7:0] - max_magnitude[9:2]
Byte 3: [5:0] - max_index[5:0]
        [7:6] - max_magnitude[11:10]

>>  3. The data length varies pretty much, there might be some false
>>     positives/PHY errors which are not FFT data - what should be
>>     the correct length?
See above.

>>  4. Is there any special handling for HT40? At least the proprietary
>>     driver symbol names suggest so [3]
> 
> -> this one is solved: yes, there is. it has more FFT bins. Although
> I didn't see that yet (I doubt they are the "small" variations I have seen,
> like up to 4 byte, I'd expect like double frame size).
See above.

>> (Possible) further work:
>>  1. Integrate this patchset, confirm/correct findings
>>  2. If anyone would like: Atheros proprietary driver seems to
>>     support some kind of classification [3] (is this microwave? cordless
>>     phone? whatever?)
That should be done in userspace.

>>  3. If other devices also offer spectral scan support: define a
>>     common interface to use it (not debugfs).
Makes sense. The data should be in an extensible binary format that can
also cover vendor specific extra information. One suggestion would be to
prefix the FFT message data with a netlink-style TLV header describing
the message format (using an enum for data types and an enum for fields,
both of which we can extend if we need to add more data).
That way userspace can use the header to figure out the message size and
can ignore any fields that it does not support.

I hope this helps.

- Felix
