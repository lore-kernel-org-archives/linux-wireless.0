Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:54225 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaAWCA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 21:00:28 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 02:00:25 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_030032_771203_743A498F)
References: <52DF947E.40800@gmail.com>,<CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
In-Reply-To: <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your mail, but very pity, after checking, it doesn't as well. May you test it on your board?


# iw reg get
country US:
	(2402 - 2472 @ 40), (30, 0)
	(5170 - 5250 @ 80), (17, 0)
	(5250 - 5330 @ 80), (23, 0)
	(5735 - 5835 @ 80), (30, 0)
	(57240 - 63720 @ 2160), (40, 0)

country_code=US
hw_mode=a
channel=149

#hostapd -B /etc/hostapd.conf 
Configuration file: /etc/hostapd.conf
channel [19] (149) is disabled for use in AP mode, flags: 0x7
wlan0: IEEE 802.11 Configured channel (149) not found from the channel list of current mode (2) IEEE 802.11a
wlan0: IEEE 802.11 Hardware does not support configured channel
Could not select hw_mode and channel. (-4)
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory




Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Krishna Chaitanya [chaitanya.mgit@gmail.com]
Sent: Thursday, January 23, 2014 5:20 AM
To: zhuyj
Cc: linux-wireless; Liu, Bopeng
Subject: Re: 802.11a is supported in AP mode or not?

On Wed, Jan 22, 2014 at 3:20 PM, zhuyj <zyjzyj2000@gmail.com> wrote:
> Hi, maintainers
>
> I made tests on ubuntu 13.10. I followed these steps.
> From the following logs, we can see 802.11a is not supported in channel
> list.
> I want to know whether 802.11a supports this or not? Or 802.11a is not used
> in this?
> Chip is 6205. lspci -vvv is as below.

Its a AGN card, so it supports 5GHz.

Also From the other Thread:

On Wed, Jan 22, 2014 at 4:27 PM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
>
> AP Mode:
>
> hw_mode can't be supported, have you ever met such problem?
>
>
>  hostapd -B /etc/hostapd.conf
> Configuration file: /etc/hostapd.conf
> channel [9] (104) is disabled for use in AP mode, flags: 0x1
> wlan0: IEEE 802.11 Configured channel (104) not found from the channel list of current mode (2) IEEE 802.11a
> wlan0: IEEE 802.11 Hardware does not support configured channel
> Could not select hw_mode and channel. (-4)
> wlan0: Unable to setup interface.
>
Channel 104 is a DFS channel which is not allowed in country US.
Please use a non-DFS channel like 36/40/149 and then try (or)
change the country_code which has 104 allowed :-).

You can also use "iw reg get" to get list of bands allowed, all the bands
marked with passive-scan are not allowed in AP mode unless we implement
full DFS functionality (CAC) and make the channel usable.

Also use a separate thread, dont post in other threads.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
