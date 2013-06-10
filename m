Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64318 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3FJOyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 10:54:10 -0400
Received: by mail-ob0-f180.google.com with SMTP id eh20so9909221obb.25
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 07:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130610182317.3beb2841@lenovo-laptop>
References: <20130610182317.3beb2841@lenovo-laptop>
Date: Mon, 10 Jun 2013 16:54:09 +0200
Message-ID: <CACna6rwOHS26o3gPMy5nKag8Dm0pYaEOi6B+kuxtoLfVrRZOrA@mail.gmail.com> (sfid-20130610_165413_805177_5B151BC7)
Subject: Re: [DEFECT] iw: No output if passive scanning is requested
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Fran=C3=A7ois_Ravaillac?= <neutrino.nuovo@yahoo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/10 François Ravaillac <neutrino.nuovo@yahoo.com>:
> Using b43 driver with newer kernels (namely, 3.8-1-686-pae from Debian
> and 3.10.0-rc4 from git) it isn't possible to perform passive scanning
> (in 2.4GHz band) using 'iw' tool. The command 'iw dev wlan0 scan
> passive' doesn't print any output. At the same time, a usual scan with
> sending probe requests ('iw wlan0 scan' or 'iwlist wlan0 scan') does
> work as expected.
>
> The radio module I'm using is
> 05:00.0 Network controller [0280]: Broadcom Corporation BCM4312
> 802.11b/g LP-PHY [14e4:4315] (rev 01)
>
> Copy of dmesg, lspci, lsmod, 'iw phy0 info' outputs and kernel config file
> is attached.
>
>
> P.S. I'm not a developer nor programmer, but I'm ready to help to make
> linux better :)

Hm, this is very interesting. Recently I've discovered problem with
finding AP working on channel 13. It turned out to be a regression
caused by
> Scanning regression since "cfg80211: use DS or HT operation IEs to determine BSS channel"
http://lists.infradead.org/pipermail/b43-dev/2013-March/003003.html

I think it can be related. I'll try to take a look at this in free
time, but don't promise anything soon. Thanks for your report anyway.

-- 
Rafał
