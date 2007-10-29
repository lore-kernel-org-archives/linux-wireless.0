Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:31420 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbXJ2Kuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 06:50:54 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1278155nfb
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2007 03:50:53 -0700 (PDT)
Message-ID: <4725BB09.3030803@gmail.com> (sfid-20071029_105058_725700_5D601BF2)
Date: Mon, 29 Oct 2007 11:50:49 +0100
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>	 <4719BA96.3010609@gmail.com> <1193644281.27622.12.camel@dv>
In-Reply-To: <1193644281.27622.12.camel@dv>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Sat, 2007-10-20 at 10:21 +0200, dragoran wrote:
>
>   
>>> I don't know why iwl3945 composes the association request on its own 
>>> and what happens to it later.  Besides, mac80211 10.0.0 is something 
>>> heavily patched by Intel AFAIK.  I wanted to test the git version of 
>>> Intel mac80211, but intellinuxwireless.org appears to be down or 
>>> unreachable at the moment and I didn't have a recent clone.  The 
>>> kernel mac80211 is definitely not the suspect.
>>>
>>> I was aware of "error 18", and when I noticed some activity about 
>>> rates in wireless-2.6/everything, so I decided to see how that problem 
>>> would be affected.
>>>
>>>       
>> does loading the module with disable_hw_scan=1 helps?
>>     
>
> Sorry for delay.  disable_hw_scan=1 makes no difference for association
> requests.  However, it has the opposite effect on the probe requests.
> With disable_hw_scan=1, probe requests have the same problem as the
> association requests, namely they don't have CCK rates in the supported
> rates:
>   
I tryed to reproduce it here using a wrt54gl. I switched it to "B only" 
and was able to acciotate using iwl3945.
iwconfig was reporting 54Mb/s but that seems wrong I did a test with 
iperf and got this:
0.0-10.1 sec  11.2 MBytes  9.31 Mbits/sec (=< 11Mb/s)
(also the scan result only reported 1, 2, 5.5 and 11
than I switched back to mixed mode, scan result showed the G rates too 
and I did a iperf again and got:
0.0-10.1 sec  20.6 MBytes  17.2 Mbits/sec (> 11Mb/s)
(in both cases using WEP + broadcast ssid + ~50cm distance to AP, driver 
version 1.1.17d; 2.6.23.1-10.fc7)

Can you tell me how you captured the assoc request using wireshark? I am 
only able to capture the dhcp traffic but not the assoc request itself.


