Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56447 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LKD3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 22:29:21 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so8659986pde.20
        for <linux-wireless@vger.kernel.org>; Tue, 10 Dec 2013 19:29:20 -0800 (PST)
Message-ID: <52A7DC0C.8090902@lwfinger.net> (sfid-20131211_042925_806578_9B5D6CAF)
Date: Tue, 10 Dec 2013 21:29:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kam <kampowchicken@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: rtl8723ae owner.
References: <loom.20131211T021101-974@post.gmane.org>
In-Reply-To: <loom.20131211T021101-974@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2013 07:42 PM, Kam wrote:
> I have the rtl8723ae PCIe wifi card. I've read through the messages on the
> forums and experience similar issues to others who have inquired about the
> card. I experience sluggish connections and disconnects, I for the most
> can't connect to my school wifi at all.
>
> I switched my router to 'AP' today after reading through the posts here and
> initially the connection was faster than I've experienced thus far(since
> switching to linux last year), I ended up shutting down the computer
> eventually and after turning it back on few hours later, It was back to the
> slow sluggish connection.

What does switching the router to 'AP' mean? If it was not an AP before, you 
would never have been able to connect to it.

> I've collected all the output that I could think of and wanted to contribute
> it in hopes that it can assist the devs in testing/debugging the issues with
> the card. The text file is a little but over 800 lines, so I will post it on
> fpaste, if this isn't acceptable please let me know and I will repost the
> text in preferred format. I am about ready to smoke the beacons off this
> thing :P.

One thing missing in what you posted is any messages from dmesg that describe 
the disconnects.

The only thing I noted in your posting is that your channel is about as badly 
chosen as is possible. Wifi is not like TV. The channel spacing is 5 MHz, but 
the width for 802.11g is 20 MHz, and 802.11n is 40 MHz. If you do the math, your 
choice of channel 9 overlaps *every* AP in your neighborhood. At -60 dBm, your 
signal is not strong, and is even weaker than Home2.

I would choose a channel as low as possible. That would be #1 for 802.11g. Your 
AP may not allow lower than #3 for 802.11n.

Next, you might try loading the module with the option "ips=0". That will 
disable power save mode, and it might help.

I have been running a long-term test of rtl8723ae. After 100 hours, I have had a 
total of 11 disconnects. Each of them has reconnected with very little 
interruption in service. The difference is that my channel is chosen to have as 
little interference as possible, and my signal strength is -44 dBm.

Larry


