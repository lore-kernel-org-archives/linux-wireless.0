Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:45757 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZI3DiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 23:38:04 -0400
Message-ID: <4AC2CC7F.9070903@cmu.edu>
Date: Tue, 29 Sep 2009 23:11:59 -0400
From: Aditya <aybhave@cmu.edu>
MIME-Version: 1.0
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] Ath5k and proprietary extensions
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com> <1251837101.14862.32.camel@mj>
In-Reply-To: <1251837101.14862.32.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I am working on a research project which needs to change the channel 
width to 5,10 and 40MHz. Ive been looking through the mailing lists and 
there seems to be some interest in having an API built for this.
Would it be possible for someone to please outline the steps needed to 
enable 5,10,40 MHz channels? I am not looking for a clean implemented 
API, just whatever hack is required to change the PLL clock, modify 
PHY/RF settings (as mentioned in the thread below) in order to get this 
to work.

Thanks very much for your help
regards,
Aditya Bhave

Pavel Roskin wrote:
> On Sat, 2009-08-29 at 07:51 +0300, Nick Kossifidis wrote:
>
>   
>> a) X.R.: eXtended Range is a set of proprietary rates and some extra
>> techniques (various hw tweaks etc) to enable long distance, low
>> bandwidth links.
>>     
>
> I'm not interested because it's ugly and we don't have a good reference
> implementation.  Besides, there must be a reason why it's not in the
> FreeBSD HAL.  Either it's patented or Atheros was ashamed to expose that
> code.
>
>   
>> b) OFDM-only g settings for AR5211: AR5211 chips have support for
>> draft-g (eg. no dynamic CCK/OFDM modulation, only OFDM). I don't know
>> if we want to support it or not, removing the settings will save us
>> some space and since it's a draft g implementation i don't think there
>> are many compatible APs out there. Is there any possibility to support
>> draft-g on mac80211/cfg80211 ? If not we can just drop it else it's
>> just some extra data, no big deal.
>>     
>
> If there is a simple way to support it, let's do it.  I think having
> "pure G" may be a good idea in some situations, regardless of the
> hardware limitations.  But that's something that should be done in
> mac80211.
>
> I would keep the initialization code for now.
>
> That said, AR5210 and AR5211 are so rare, that we might consider
> splitting them into separate drivers that would not be actively
> maintained.
>
>   
>> c) Half/quarter rate channels (10/5MHz width) and turbo mode (double
>> rate - 40MHz width): Hw can transmit with different channel width
>> allowing us to operate on half, quarter or double rate (also called
>> turbo mode).
>>     
>
> It would be nice to be able to receive on wide and narrow channels, at
> least in the monitor mode.  Generally, "be liberal in what you accept,
> and conservative in what you send".
>
> We'll need some API to set the bandwidth and radiotap flags to
> communicate the bandwidth to the recipient.
>
>   
>> d) Fast frames: Hw can tx/rx jumbo frames of 3kbytes+ so fast frame
>> aggregation is a way to make use of that hw feature by sending 2
>> frames together (for more infos check out super ag white paper).
>>     
>
> Likewise, it would be nice to receive them.
>
>   
>> e) Compression: Hw can do on-chip compression/decompression using
>> standard Lempel Ziv algorithm per tx queue, MadWiFi implements this
>> and uses a vendor IE to let others know that it supports this feature
>> (same IE is used for all capabilities, fast frames, XR etc).
>>     
>
> Same thing here, as long as we can reuse the existing kernel code for
> decompression.
>
>   

