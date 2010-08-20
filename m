Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0HTLNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 07:13:48 -0400
Received: by bwz11 with SMTP id 11so1986356bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Aug 2010 04:13:47 -0700 (PDT)
Message-ID: <4C6E636F.2080606@gmail.com>
Date: Fri, 20 Aug 2010 13:13:51 +0200
From: Witold Sowa <witold.sowa@gmail.com>
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>
CC: Christopher Piggott <cpiggott@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: scanning a specific ssid
References: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com> <1282302303.3662.5.camel@sortiz-mobl>
In-Reply-To: <1282302303.3662.5.camel@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Samuel Ortiz pisze:
> Hi Christopher,
>
> On Thu, 2010-08-19 at 16:25 -0400, Christopher Piggott wrote:
>   
>> Hi,
>>
>> I wrote a small C++ program using libdbus-c++ to scan for access
>> points via wpa_supplicant's dbus interface.  It works very well, and I
>> can retrieve the list just fine.
>>
>> Now I want to cause it to scan for a specific SSID by issuing a probe,
>> but the dbus interface fi.epitest.hostap.WPASupplicant.Interface has
>> only one scan method, and it does not seem to take arguments.
>> (Looking at the source file ctrl_iface_dbus_handlers.c in function
>> wpas_dbus_iface_scan() you can see why - it doesn't handle or even
>> look at the arguments to the message).
>>
>> Is there another way to accomplish this?  
>>     
> I don't know which version of wpa_supplicant you're using, but the new
> D-Bus API (fi.w1.wpa_supplicant1.*) has a much more extended scanning
> API. You can pass SSIDs, channels, IEs and the scanning type to it.
>   
The new DBus API is present only in development (0.7.x) branch of
wpa_supplicant. 0.6.10 and earlier support only the old API which,
indeed, has very limited scanning options capabilities.

Witek.
