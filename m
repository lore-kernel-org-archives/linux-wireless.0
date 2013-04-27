Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43275 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3D0PDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 11:03:01 -0400
Received: by mail-ob0-f174.google.com with SMTP id wc20so4365390obb.33
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 08:03:00 -0700 (PDT)
Message-ID: <517BE8A2.3020202@lwfinger.net> (sfid-20130427_170313_618009_5413339A)
Date: Sat, 27 Apr 2013 10:02:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kris Reeves <myndzi@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: RTL8192CU / Kconfig
References: <CABH51ZYepRMcmW4wFUmOf9dcnB4X0X377mmwSXNo9AQGbsNAxA@mail.gmail.com> <CABH51ZbDsx9hg9NtafyOk__62O=yO1sKkW2bf_DHEghSwSd=EQ@mail.gmail.com>
In-Reply-To: <CABH51ZbDsx9hg9NtafyOk__62O=yO1sKkW2bf_DHEghSwSd=EQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2013 07:02 AM, Kris Reeves wrote:
> This file:
> https://github.com/raspberrypi/linux/blob/rpi-3.6.y/drivers/net/wireless/rtl8192cu/Kconfig
>
> Should, I believe, include select statements for WIRELESS_EXT,
> WEXT_PRIV, and (maybe?) WEXT_SPY (I added it preemptively after the
> first two stopped compilation...)

All three of those are selected in net/wireless/Kconfig, thus they never need to 
be selected by any specific wireless driver. Once you have NET defined, and are 
not building for the S390 architecture, they should be automatic.

> The drivers won't compile without those options, but can be enabled in
> situations where they are not set.
>
> I realize this is the raspberry pi github page, but from what I can
> tell, these files didn't originate there and this driver is in staging
> on its way to mainline(?)

That driver has never been in staging - it went directly to mainline in kernel 
2.6.38, i.e. more than two years ago.

> This file:
> https://github.com/torvalds/linux/blob/master/drivers/net/wireless/rtlwifi/Kconfig
>
> appears to be the equivalent and it doesn't look like it contains the
> relevant lines. I'm uncertain if they are necessary here.

As stated earlier, they are not needed in mainline.

> If you would, please inform me of the correct way to determine who I
> should report something like this to and how! I know there are various
> bugtrackers about but I can't seem to work out where I should go with
> it.

I am convinced that this is not a problem for mainline. I have not used any of 
the ARM architectures, and it may be a problem there, but I have no way to test. 
If so, the proper place to submit a patch would be the appropriate ARM tree. 
Make certain that cfg80211 and mac80211 have been selected. If you are still 
having a problem, post the .config that you are using *without* changing any of 
the selection rules for the RTL8192CU.

I have read of alignment problems for the RPi in the lower-level USB routines 
that affect rtl8192cu, but I don't know any of the details.

Larry


