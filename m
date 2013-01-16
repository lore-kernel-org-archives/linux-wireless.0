Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:53035 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab3APQAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:17 -0500
Message-ID: <50F6CE89.5060106@neratec.com> (sfid-20130116_180459_723560_B23E6ABE)
Date: Wed, 16 Jan 2013 17:00:09 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Sven Eckelmann <sven@open-mesh.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	tobias.steinicke@net.t-labs.tu-berlin.de,
	mathias.kretschmer@fokus.fraunhofer.de,
	"Chadd, Adrian" <achadd@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Save spectral scan data in network byteorder
References: <1358251363-14385-1-git-send-email-sven@open-mesh.com> <20130116085931.GA13648@pandem0nium> <50F6788B.9050409@neratec.com> <20130116131818.GA14403@pandem0nium>
In-Reply-To: <20130116131818.GA14403@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2013 02:18 PM, Simon Wunderlich wrote:
> [...]
>> Since for the scaling an user space component is mandatory (FP calculations), I
>> miss to see the benefit of splitting post-processing in the kernel (shifting bins)
>> and user space. This step doubles fft data size and introduces endianess issues
>> for no (at least to me) evident reason.
> 
> Well, that's right. The idea was to not send so "obscure" data, but I guess providing
> sample code which shifts the bins etc should be easy enough for people integrating this
> in userspace.
> 
Understood, but providing 'semi-obscure' data is not really worth the overhead ;)
>>
>> Maybe you have a host application in mind where it does not really matter where
>> the processing is done. Whereas, if you operate an AP as continuous spectral
>> scanner, shifting the post-processing to the point where it is evaluated /
>> displayed (usually your fat PC) significantly impacts your AP's load and its
>> capability to provide higher sampling rates.
> 
> I didn't see any performance limits yet. Shifting the data is probably not so expensive
> (what we do right now in the kernel), but doubled sample size and other aspects
> will certainly have an impact for this kind of "streaming" application for (low-end) APs.
> 
Right now, with a 500MHz ARM SoC I am limited to ~12k-samples/s with resources
fully utilized. That's far from the 250kS/s the chip could theoretically provide.
But I'm still with my netlink based interface and need to check if relay-fs is
more efficient.
>>
>> I'd assume Adrian's proposal to just push out the raw spectral data to user-space
>> is also targeting at that, which I fully support. The only thing I would keep in
>> the driver is fixing the fft data corruption caused by known chip bugs.
> 
> As far as I understood, Adrian returns the whole packet with all flags and bugs, but I might
> be wrong. I'd agree to at least fix the length bug in the kernel (newer chips should not
> have this flaw anymore).
> 
Right, that's why the 'bug-fixing' should remain part of the driver.

> In any case, I don't want to change the format multiple times again, so let's discuss and
> fix it once and for all[tm] now. There are some parties already experimenting with and integrating
> this feature now. And if I'm not mistaken we have ~3 weeks left to add changes for
> the next kernel version.
> 
Beside the required modifications being trivial, since the user space
post-processing is mandatory - could a library for data conversion help to
decouple driver from test development?

> My suggestions for the new format:
>  * fix length bugs (as you said)
>  * use a TLV format to hand out samples (as done now) - we can use a new type
>  * each "sample packet" holds one sample, i.e. aggregated sample packets from the chip (we are not processing
>    them in the current version, but in later versions maybe) are split into multiple "sample packets"
What are your plans for aggregation here, given that you need to convert the data
won't (easily) work in the kernel?
>  * the bins are not shifted (8 bit per bin)
>  * auxiliary information which is larger than 8 bit (tsf, frequency, etc) is converted into network byte order
> 
> Anything else?
> 
With the rssi and noise-floor values already included: no, looks complete.

> Cheers,
> 	Simon
> 

