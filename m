Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:40399 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab1IIAxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 20:53:17 -0400
Received: by gwb17 with SMTP id 17so633708gwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 17:53:17 -0700 (PDT)
Message-ID: <4E696378.3060005@lwfinger.net> (sfid-20110909_025321_536739_5F22C434)
Date: Thu, 08 Sep 2011 19:53:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about netperf terminology in the RTL8192SE and 802.11n
 problem thread
References: <4E6955B8.4000900@hp.com>
In-Reply-To: <4E6955B8.4000900@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2011 06:54 PM, Rick Jones wrote:
> Hi -
>
>  From time to time I web search for instances of netperf usage, and came across
> http://www.spinics.net/lists/linux-wireless/msg76387.html which has verbiage like:
>
>> TCP_MAERTS TX Test: 47.33 53.94 55.19 44.24 57.74 55.44 53.74 54.63 47.87 57.82
>> TCP_MAERTS RX Test: 66.02 69.79 67.70 52.15 82.56 80.30 79.43 80.98 76.26 71.34
>> Results: TX: max 57.82, min 44.24. Mean 52.79(4.42)
>> RX: max 82.56, min 52.15. Mean 72.65(8.85)
>>
>> TCP_STREAM TX Test: 71.83 80.44 72.88 26.11 40.85 58.70 58.49 58.96 59.52 59.35
>> TCP_STREAM RX Test: 46.41 52.64 43.85 48.44 52.15 49.66 52.81 50.61 43.18 52.93
>> Results: TX: max 80.44, min 26.11. Mean 58.71(14.93)
>> RX: max 52.93, min 43.18. Mean 49.27(3.51)
>>
>> TCP_SENDFILE TX Test: 57.86 55.94 55.21 56.13 56.70 61.71 56.85 54.68 55.04 51.30
>> TCP_SENDFILE RX Test: 37.82 47.51 41.61 42.88 45.37 35.11 45.09 40.11 46.48 22.86
>> Results: TX: max 61.71, min 51.30. Mean 56.14(2.50)
>> RX: max 47.51, min 22.86. Mean 40.48(6.96)
>
>
> in it. Seeing separate TX and RX lines for netperf TCP tests is unfamiliar to me
> and I was wondering if someone (Stephan?) could explain the split? Netperf
> itself tends to emit only the one figure for a transfer rate (measured up at the
> socket level). (Modulo some of the recentish omni output selectors anyway,
> though for a TCP transfer test they would/should be very very similar...)

Those numbers are from my tests. The TX numbers are the standard netperf output 
and give the rate from my test laptop to a server that is wired to the 
AP/router. Those are the numbers that you are used to.

The RX numbers are obtained by starting a server on my laptop and ssh'ing a 
netperf command to the machine that was the server in the TX tests, i.e. I am 
measuring the TX rate from the former server, or the RX rate for the laptop. My 
script does 10 samples of each and calculates the mean and standard deviation.

Larry

