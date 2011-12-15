Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1929 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab1LOSlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 13:41:31 -0500
Message-ID: <4EEA3F53.40305@canonical.com> (sfid-20111215_194134_875227_2362C122)
Date: Thu, 15 Dec 2011 11:41:23 -0700
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Seth Forshee <seth.forshee@canonical.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <4ECA99CC.7020008@lwfinger.net> <20111121185610.GD6736@thinkpad-t410> <4ECB028E.3030809@lwfinger.net> <20111122022008.GA17661@thinkpad-t410> <20111213194231.GA30788@thinkpad-t410> <4EE7B85E.3070802@lwfinger.net> <20111213212606.GB30788@thinkpad-t410> <4EE82CC6.2030307@lwfinger.net> <20111214162333.GB19410@thinkpad-t410> <4EE8D150.8090100@lwfinger.net> <20111214164902.GD19410@thinkpad-t410> <4EE91A87.5090207@canonical.com> <4EE9445B.1010504@lwfinger.net>
In-Reply-To: <4EE9445B.1010504@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2011 05:50 PM, Larry Finger wrote:
> Tim,
>
> I did the live test with the Dec. 14 build of 12.04 (64 bit). It
> connected with my WNDR3300 with no difficulty. I tested all 4 modes
> supported by the AP. All worked.
>
> I assume that an installation would work the same as the live version,
> but that is easy for you to test.
>
> Larry
>

Here are the 3 modes I was able to successfully test on my WNDR3300 as 
an open AP:

* Up to 270Mbps at 2.4Ghz
   11N Channel:	03/2.422Ghz
   in this mode only the 11N SSID is beaconed.
   iperf: 11.2 Mbps average over 120 seconds, high of 26.2 Mbps, low of 6.71

* Up to 270Mbps at 5Ghz & 54Mbps at 2.4Ghz
   11N Channel: 36 / 5.180Ghz
   11G Channel: auto
   in this mode only the G beacon can be seen (which makes sense)
   iperf: 14.3 Mbps average over 120 seconds, high of 28.5 Mbps, low of 8.97

* Up to 130Mbps at 2.4Ghz
   11N Channel:	03/2.422Ghz
   in this mode only the 11N SSID is beaconed.
   iperf: 16.0 Mbps average over 120 seconds, high of 28.9 Mbps, low of 7.44

This mode would not acquire a beacon using the rtl8192ce:

* Up to 130Mbps at 5Ghz & 54Mbps at 2.4Ghz
   11N Channel: 36 / 5.180Ghz
   11G Channel: auto
   in this mode no beacon can be seen.

I verified using a MacBook Air under OS/X that the N SSID was appearing 
on the 5 Ghz channel, but couldn't see the G beacon. Maybe its a bug in 
the WNDR3300.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
