Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52278 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3IIO5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 10:57:04 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so5945297obc.6
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 07:57:04 -0700 (PDT)
Message-ID: <522DE1BE.6070904@lwfinger.net> (sfid-20130909_165711_267168_7AA49C73)
Date: Mon, 09 Sep 2013 09:57:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk>
In-Reply-To: <522DD856.7050309@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2013 09:16 AM, Mark Cave-Ayland wrote:
> On 09/09/13 00:16, Larry Finger wrote:
>
>> On 09/08/2013 06:53 AM, Timothy Rundle wrote:
>>> My TL-WN821N with a RTL8192CU chipsets fails to stay connected. It
>>> appears to be disconnecting every 5-10 seconds. Since the issue
>>> happens with the mainline kernel, the downstream maintainer ask me to
>>> post here. Here is a section of my kernel log:
>>
>> This problem has been reported before; however, I cannot duplicate it on
>> my openSUSE KDE system that controls the wireless using NetworkManager.
>
> Yes, this sounds like exactly the same problem that I reported a couple of weeks
> ago. Note that I see the issue invoking wpa_supplicant manually rather than
> using NetworkManager, so I don't think that this is part of the problem.
>
> I can also clarify that if I remove *all* entries from wpa_supplicant.conf
> except for the one AP I'm trying to associate with, then I can generally get an
> initial association within about 30-60s. However I still repeatedly see
> drop-outs every 30s or so.

I think your user space is exactly the problem. As I am writing this, my device, 
which lsusb reports as "ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 
802.11n Wireless Adapter [Realtek RTL8188CUS]" has been up for a little over 20 
hours. During that time, there have been 23 deauthentications for reason 7, but 
0 of the "connection to AP lost" variety.

My system is running version 1.1 of wpa_supplicant, 0.9.6.4 of NetworkManager, 
and 0.9.0.7 of the KDE applet.

None of my wireless connections are made automatically. When I select a 
particular AP from the KDE applet, it is roughly 2 seconds until the interface 
has gotten an IP and reports its state as connected.

I will switch my system from NM to manual control to see what happens.

Larry


