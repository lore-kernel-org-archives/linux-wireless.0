Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62982 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1HASAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 14:00:23 -0400
Received: by qyk9 with SMTP id 9so3439594qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 11:00:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL114-W51F297F32C58B7D93C26828A380@phx.gbl>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <201107301317.14486.chunkeey@googlemail.com>
 <CAB=NE6V-=m+S2mkK5ugAfUnBUD_Wvttot6rndC6ToCi8hc2RGw@mail.gmail.com>
 <201107301754.13432.chunkeey@googlemail.com> <CAB=NE6UhZNV0-SLP_pRP5iVbCy6O6C8vfnUSouv7-vP0R6hfUw@mail.gmail.com>
 <COL114-W51F297F32C58B7D93C26828A380@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Aug 2011 11:00:02 -0700
Message-ID: <CAB=NE6UiyfKyeJzOcYhm4t_nOz_kRwLZiEMqg0yppZRL=9gOfw@mail.gmail.com> (sfid-20110801_200030_652155_C0890BD8)
Subject: Re: problem on ACS
To: MingAnn Ng <devil_eddie01@hotmail.com>
Cc: chunkeey@googlemail.com, nbd@openwrt.org,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 31, 2011 at 11:01 PM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> Hi Luis,
>
> I have apply the patch which you've provided. the result is shown as below:
>
> channel=1
> 2412 MHz: 12.600000
> 2417 MHz: 9.900000
> 2422 MHz: 11.300000
> 2427 MHz: 11.200000
> 2432 MHz: 13.600000
> 2437 MHz: 11.800000
> 2442 MHz: 12.300000
> 2447 MHz: 11.600000
> 2452 MHz: 11.300000
> 2457 MHz: 12.100000
> 2462 MHz: 10.100000
> 2467 MHz: 10.800000
> 2472 MHz: 11.100000
> 5180 MHz: 1.600000
> 5200 MHz: 2.400000
> 5220 MHz: 3.000000
> 5240 MHz: 3.200000
> 5260 MHz: 2.900000
> 5280 MHz: 4.100000
> 5300 MHz: 3.700000
> 5320 MHz: 3.000000
> 5500 MHz: 0.100000
> 5520 MHz: -0.100000
> 5540 MHz: -0.300000
> 5560 MHz: -1.100000
> 5580 MHz: -1.200000
> 5600 MHz: -1.200000
> 5620 MHz: -2.400000
> 5640 MHz: -1.000000
> 5660 MHz: -1.300000
> 5680 MHz: -1.200000
> 5700 MHz: -0.300000
> Ideal freq: 5620 MHz
>
> channel=36
> 2412 MHz: 12.300000
> 2417 MHz: 9.900000
> 2422 MHz: 11.700000
> 2427 MHz: 12.200000
> 2432 MHz: 14.300000
> 2437 MHz: 13.000000
> 2442 MHz: 12.900000
> 2447 MHz: 13.300000
> 2452 MHz: 11.500000
> 2457 MHz: 12.100000
> 2462 MHz: 12.200000
> 2467 MHz: 11.600000
> 2472 MHz: 11.100000
> 5180 MHz: 3.800000
> 5200 MHz: 2.000000
> 5220 MHz: 2.100000
> 5240 MHz: 3.200000
> 5260 MHz: 2.200000
> 5280 MHz: 3.000000
> 5300 MHz: 2.500000
> 5320 MHz: 1.900000
> 5500 MHz: -0.800000
> 5520 MHz: -0.700000
> 5540 MHz: -0.800000
> 5560 MHz: -1.600000
> 5580 MHz: -2.000000
> 5600 MHz: -1.700000
> 5620 MHz: -2.700000
> 5640 MHz: -1.800000
> 5660 MHz: -1.800000
> 5680 MHz: -1.900000
> 5700 MHz: -1.000000
> Ideal freq: 5620 MHz
>
> As you can see, the value of the interference factor is smaller than the
> last case.
>
> Is it a problem when the interference factor has a slight increment when it
> scan the assigned channel?

It could be related to the calibration runs that take effect upon
channel changes with the driver. To account for this I increased the
offcannel time on the hostapd patches but did not do this on the
standalone acs.git tree for the acs tool. I've committed a change for
this and pushed it out. Please test it.

  Luis
