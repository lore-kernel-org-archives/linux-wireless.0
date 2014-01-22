Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57840 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaAVVVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 16:21:14 -0500
Received: by mail-wg0-f54.google.com with SMTP id x13so863344wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 13:21:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DF947E.40800@gmail.com>
References: <52DF947E.40800@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 23 Jan 2014 02:50:52 +0530
Message-ID: <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com> (sfid-20140122_222117_333506_BB7514C4)
Subject: Re: 802.11a is supported in AP mode or not?
To: zhuyj <zyjzyj2000@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Liu, Bopeng" <Bopeng.Liu@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
