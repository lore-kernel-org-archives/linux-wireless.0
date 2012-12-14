Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36254 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab2LNAbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 19:31:01 -0500
Message-ID: <50CA71A4.1010806@net.t-labs.tu-berlin.de> (sfid-20121214_013117_073375_E9C5B30F)
Date: Fri, 14 Dec 2012 01:24:04 +0100
From: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de> <20121213140753.GA26868@pandem0nium> <50CA0F8B.3060905@openwrt.org> <20121213220651.GA30855@pandem0nium> <50CA5EE9.30606@openwrt.org>
In-Reply-To: <50CA5EE9.30606@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix and Simon,

I play with it since a while, but without proper results. Your patch 
set, Simon helps a lot.

Thanks.

Am 14.12.2012 00:04, schrieb Felix Fietkau:
> On 2012-12-13 11:06 PM, Simon Wunderlich wrote:
>> Hey Felix,
>>
>> thanks, this looks like exactly what I was hoping for!
>>
>>>>>   2. The output format is very Atheros-dependent. If my finding that
>>>>>      byte n-4 is some kind of offset/exponent, I'd integrate this in
>>>>>      the debugfs output as well
>>> Here's my understanding of the data format:
>>>
>>> HT20:
>>> 56 bytes bin magnitude data (8 bits per bin)
>>> 3 bytes bin maximum values (see below)
>>> 1 byte exponent:
>>> 	[3:0] - number of bits to shift the magnitude data
>>>
>>
>> Now that is exactly what I was looking for! So shifting the data makes it some
>> kind of exponent, so I wasn't so wrong. :D
>>
>> BTW, does the 56 byte ever change, or may it happen that there is something in front
>> of the FFT bins? or in the middle? I still see different data lengths, and the
>> format looks pretty fixed to me. In theory:
>>   * 56 bytes FFT bins
>>   * 3 bytes maximum values
>>   * 1 byte exponent
>>   * 3 byte radar trailer (with bwinfo etc)
>>
>> Thoughts? I'll check my data again, too.
> I don't know about the data length, I haven't run any tests myself.
The data length should be between 62 and 65 bytes for HT20 and between 
137 and 140 bytes for HT40. But most of the time I see only 62 for HT20.
>
>>> HT40:
>>> 128 bytes bin magnitude data (64 lower bins, 64 upper bins)
>>> 3 bytes lower bin maximum values (see below)
>>> 3 bytes upper bin maximum values (see below)
>>> 1 byte exponent (like HT20)
>>
>> I have not experimented in HT40 mode yet, but we should add that too. :)
>>>
>>> Bin maximum values:
>>> Byte 1: [1:0] - max_magnitude[1:0]
>>>          [7:2] - bitmap_weight[5:0]
>>> Byte 2: [7:0] - max_magnitude[9:2]
>>> Byte 3: [5:0] - max_index[5:0]
>>>          [7:6] - max_magnitude[11:10]
>>>
>>
>> OK - not sure what "weight" means, max_magnitude might be the highest of the
>> FFT bins? What "index" is max_index?
> No idea.
>
>> BTW, the FFT bins/magnitude values, are these absolute values or logarithmic
>> values? I'd guess it's absolute from the look of it (applying log() makes it
>> "look better" in the visualization), but not sure.
> I also think it's probably absolute.
>
>>>>>   3. If other devices also offer spectral scan support: define a
>>>>>      common interface to use it (not debugfs).
>>> Makes sense. The data should be in an extensible binary format that can
>>> also cover vendor specific extra information. One suggestion would be to
>>> prefix the FFT message data with a netlink-style TLV header describing
>>> the message format (using an enum for data types and an enum for fields,
>>> both of which we can extend if we need to add more data).
>>> That way userspace can use the header to figure out the message size and
>>> can ignore any fields that it does not support.
>>
>> Yeah, sounds good. Although I'm still not sure how we could compose the
>> userspace interface. We might want to configure things like:
>>   * count, interval, endless mode?
>>   * trigger for a scan
>>   * listen for samples (endlessly?) ...
>>
>> The recent patch contains a control file and a listen file - maybe we could
>> have similar commands for iw?
> Let's come up with a proper prototype using the intended data format via
> debugfs in the driver before we add support to nl80211 and iw.
>
>> Also I'm not sure if the performance is very good for the case that we want
>> to stream a lot of samples. About the data format, keeping it somewhat flexible
>> for adding fields in the future is a good idea IMHO.
> I think the TLV header struct description + fixed length messages is
> good for performance. The header only has to be sent once at the
> beginning of the stream, and the conversion to the struct format + the
> relay can be quite fast.
>
>> Also as the exponent seems to be confirmed now, I'd directly apply it to the FFT
>> values when giving it to userspace, like FFT_bin[i] << exponent (if this is the
>> correct form)
> Yes, userspace shouldn't have to deal with that.
>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Tobias

