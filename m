Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53173 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2KYVxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 16:53:01 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so2909443wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2012 13:53:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B29159.20209@googlemail.com>
References: <20121125190019.GQ8292@ibawizard.net>
	<50B29159.20209@googlemail.com>
Date: Sun, 25 Nov 2012 22:53:00 +0100
Message-ID: <CAGXE3d_Wgk5Eo5Y2k-9jr3ULuOeZydmWA_pJVd8ARnKHwSGtgQ@mail.gmail.com> (sfid-20121125_225306_643401_DA18D806)
Subject: Re: Multi-bss operation issue with rt2x00 and hostapd on rt305x platform
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 25, 2012 at 10:44 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On 11/25/2012 08:00 PM, Petr Štetiar wrote:
>
> Hi,
>
> first of all, I apologize for cross posting. Please kindly keep me in the Cc
> loop as I'm not subscribed to the mailing lists.
>
> For the past week I'm trying to get multi-bss working on ramips platform,
> it's
> a Carambola(from 8Devices) board with rt3050 SOC, which use rt2x00 driver
> for
> wireless. I use OpenWRT, which currently have 3.3.8 kernel and
> compat-wireless
> from 2012-09-07. On top of this I've applied following patches (otherwise
> it's
> not even possible to create the wlan0-1 and wlan0-2 interfaces):
>
> 3e4c4151e56ff367fb1487ea79134eea7410407	[PATCH] rt2x00: Deprecate
> max_sta_intf field of struct rt2x00_ops
> 55d2e9da744ba11eae900b4bfc2da72eace3c1e1 [PATCH] rt2x00: Replace open coded
> interface checking with interface combinations
>
> It's kind of working now, but not completly. I've setup with 3 VAPs:
>
> wlan0:   SSID "wlan0-bad"
> wlan0-1: SSID "wlan01-ok"
> wlan0-2: SSID "wlan02-ok"
>
> just basic configuration and no encryption, attached is complete hostapd's
> config file. As you can guess from the SSID names, the first one always
> doesn't work, client assoc ends with the following error:
>
>
> Mind to use different MAC addresses? The rt2800 hw can only be programmed
> with a MAC address mask
> that spans the last 3 bits. In your config this would be

Ooops, seems I messed up my mailclient :)

You're using the following MAC addresses for the virtual APs:

bssid=c4:93:00:11:01:88
bssid=c6:93:00:11:01:89
bssid=c6:93:00:11:01:8a

rt2800 hw can only be configured to mask the last three bits of the
programmed MAC addresses. In your case the first MAC differs from the
other in the first byte. Please try if it works when using the same
first byte.

HTH,
Helmut
