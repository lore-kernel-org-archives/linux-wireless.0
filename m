Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38512 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3HOWnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 18:43:39 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so1360717pdj.18
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 15:43:38 -0700 (PDT)
Message-ID: <520D5995.4010107@gna.org> (sfid-20130816_004342_313337_9B5AF941)
Date: Fri, 16 Aug 2013 10:43:33 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Switching band of a dual-band WiFi device
References: <520C631F.6010806@gna.org> <1483073.ZnhDhG6Z68@f17simon>
In-Reply-To: <1483073.ZnhDhG6Z68@f17simon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/08/13 21:03, Simon Farnsworth wrote:
> On Thursday 15 August 2013 17:11:59 Christian Gagneraud wrote:
>> Hi there,
>>
>> I am using a TP-Link TL-WDN3200 on a ubuntu 13.04 (kernel
>> 3.8.0-27-generic), and I have install relevant modules with
>> backports-3.11-rc3-1.
>>
>> I would like to switch my WiFi stick to 5GHz, I tried iwconfig wlan0
>> freq 5G, but I get ENOTSUPP.
>> Is the freq settings suppose to handle this 2.4 vs 5GHz band or is it
>> only for selecting channel frequency within a given band?
>>
>> Does linux-wireless provides a way for selecting 2.4 or 5GHz band?
>
> Linux should automatically select the right frequency band, depending on
> the frequencies in use by the device you're trying to communicate with.
> Connect to an AP in the 5GHz band, and Linux should just use 5GHz
> automatically.
>>
>> "iw phy phy11 info" tells me that in band 2, all the frequencies are
>> disabled except:
>>                           * 5745 MHz [149] (30.0 dBm)
>>                           * 5755 MHz [151] (30.0 dBm)
>>                           * 5765 MHz [153] (30.0 dBm)
>>                           * 5775 MHz [155] (30.0 dBm)
>>                           * 5785 MHz [157] (30.0 dBm)
>>                           * 5795 MHz [159] (30.0 dBm)
>>                           * 5805 MHz [161] (30.0 dBm)
>>                           * 5825 MHz [165] (30.0 dBm)
>>
> That's showing you that, with Linux's understanding of the RF regulations in
> your area, it can only transmit on certain frequencies.

OK, that's the CRDA thing, I understand now! ;)

>
>> As well, my understanding of WiFi might be a bit limited but, does a
>> dual-band WiFi device provides 2.4 and 5GHz services at the same time or
>> do I need to select one or the other myself? Or maybe I can just
>> enable/disable them manually (and separately)?
>>
> A dual-band WiFi device can only transmit and receive on one channel at a
> time. The advantage of dual-band is that it can transmit and receive on either
> the 5GHz band (which is less crowded), or the 2.4GHz band (which is more
> commonly used). There's no need to select the band manually - it will just
> use 5GHz when the other device (e.g. the AP) is using 5GHz.
>

Thanks for your answers Simon, everything is working now.
I had to change the regulatory domain of the USB stick to NZ as it comes 
with CN (country of origin) and NZ/CN don't really overlap in the 5GHz band.

Regards,
Chris
