Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:40562 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3IIP2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 11:28:05 -0400
Message-ID: <522DE8CA.9010008@ilande.co.uk> (sfid-20130909_172814_918383_95FA9ABE)
Date: Mon, 09 Sep 2013 16:27:06 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net>
In-Reply-To: <522DE1BE.6070904@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/13 15:57, Larry Finger wrote:

> I think your user space is exactly the problem. As I am writing this, my
> device, which lsusb reports as "ID 7392:7811 Edimax Technology Co., Ltd
> EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]" has been up for
> a little over 20 hours. During that time, there have been 23
> deauthentications for reason 7, but 0 of the "connection to AP lost"
> variety.

I've just tried building wpa_supplicant 2.0 from source and it sadly 
doesn't make any difference here.

I do still however see the following in dmesg output:

rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now

Briefly looking through the code in rtlwifi/base.c I see that the 
watchdog message above is triggered by the condition 
(rtlpriv->link_info.bcn_rx_inperiod + 
rtlpriv->link_info.num_rx_inperiod) == 0).

The bcn_rx_inperiod value is only incremented by rtl_beacon_statistic() 
in base.c, which is in turn called from _rtl_usb_rx_process_noagg() (but 
not _rtl_usb_rx_process_agg() for some reason?). Shall I try adding some 
debugging printk() statements in there to get a feel for what is going 
on? Or would it be better to attempt a trace with debug=0x5?

> My system is running version 1.1 of wpa_supplicant, 0.9.6.4 of
> NetworkManager, and 0.9.0.7 of the KDE applet.
>
> None of my wireless connections are made automatically. When I select a
> particular AP from the KDE applet, it is roughly 2 seconds until the
> interface has gotten an IP and reports its state as connected.
>
> I will switch my system from NM to manual control to see what happens.

Interesting. Did it make any difference in the end?


ATB,

Mark.
