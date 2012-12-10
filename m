Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:54217 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2LJMAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 07:00:54 -0500
Message-ID: <50C5CEF4.1070907@cfl.rr.com> (sfid-20121210_130057_632396_1B4F4476)
Date: Mon, 10 Dec 2012 07:00:52 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: markh@compro.net, linux-wireless@vger.kernel.org
Subject: Re: Wireless network problem with Access Point selection using ifup
References: <50C0A743.3000305@compro.net>     (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>    <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>   <1354913688.9124.2.camel@jlt4.sipsolutions.net>   <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com>  <1355135199.9857.11.camel@jlt4.sipsolutions.net>  <50C5C321.1090501@cfl.rr.com> <1355138959.9857.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355138959.9857.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 06:29 AM, Johannes Berg wrote:
> On Mon, 2012-12-10 at 06:10 -0500, Mark Hounschell wrote:
>
>> The driver is use has was identified in the original email. So I guess this
>> is the right place to report this issue?
>
> Yeah, I guess Larry should take a look.
>
>> In each of the wpa log files I See
>> in the beginning, a section like this:
>>
>> nl80211: Received scan results (4 BSSes)
>> wlan0: BSS: Start scan result update 1
>> wlan0: BSS: Add new id 0 BSSID c8:d7:19:7a:ab:1e SSID 'hounschell-1'
>> wlan0: BSS: Add new id 1 BSSID 20:aa:4b:b2:dd:79 SSID 'hounschell-1'
>> wlan0: BSS: Add new id 2 BSSID 00:18:f8:ff:72:d5 SSID 'hounschell-1'
>> wlan0: BSS: Add new id 3 BSSID 00:1a:70:6d:99:50 SSID 'MACDONALD'
>>
>> Every time the first one listed is the one actually selected and each time
>> is different and usually NOT the closest.
>
> That's expected, the order is random by the order in which it was found
> in scanning etc. There's no inherent order here.
>
>> It is a Desktop in a fixed location. The AP is within 15ft of the ASUS USB
>> adapter and in direct line of sight.  There may be more than one problem
>> here. I think one of the problems is right here. Above 20:aa:4b:b2:dd:79 is
>> the closest AP. Why is it not first in the list?
>
> See above.
>
>> Why, when it selects one
>> of the others and it can't figure out it selected the wrong one and
>> reselect the right one seems like a different problem. After all when it
>> does select the correct one, all is good but the actual bandwidth.
>
> Well so I suspect the driver is also not reporting useful signal
> strength so that wpa_s doesn't know which one to select. And then when
> the connection fails, the driver is refusing scanning so it can't even
> reconnect to a better AP ...
>
> IOW, all driver problems, and I'm not familiar enough with that driver
> to tell you what's going on.
>

Should I file and bug report and/or contact the author?

Mark


