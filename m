Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LBRqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:46:55 -0500
Received: by fxm20 with SMTP id 20so1375688fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 09:46:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202002234.GA30670@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu>
	<AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
	<20101125014511.GA1683@monopoli.naic.edu>
	<AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com>
	<20101126040742.GA5238@monopoli.naic.edu>
	<AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
	<20101130021911.GA18971@monopoli.naic.edu>
	<AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
	<20101202002234.GA30670@monopoli.naic.edu>
Date: Thu, 2 Dec 2010 17:46:54 +0000
Message-ID: <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@gmail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 12:22 AM, Giacomo Comes <comes@naic.edu> wrote:
> On Wed, Dec 01, 2010 at 09:52:15PM +0000, Dave Kilroy wrote:
>> On Tue, Nov 30, 2010 at 2:19 AM, Giacomo Comes <comes@naic.edu> wrote:
>> wpa_supplicant log indicates it is continuously timing out the scans.
>> I don't know what is going on there.
>>
>> What you can try is to turn off wpa_supplicant roaming, and force
>> wpa_supplicant to connect to the AP with highest priority in your
>> config. Set ap_scan=2 in wpa_supplicant.conf, and set
>>
>> group=TKIP
>> pairwise=TKIP
>>
>> in the network block.
>>
>> This also prevents wpa_supplicant trying to connect to an AP using
>> BSSID, which the agere cards don't support.
>
> Running:
> wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd
>
> wpa_supplicant.conf content:
> ctrl_interface=/var/run/wpa_supplicant
> ctrl_interface_group=0
> ap_scan=2
>
> network={
>        ssid="Comes"
>        psk="<password>"
>        key_mgmt=WPA-PSK
>        priority=5
>        proto=WPA
>
>        group=TKIP
>        pairwise=TKIP
> }

OK, looks like you're using a newer wpa_supplicant that tries to use
IW_AUTH_MFP which orinoco doesn't know about. I can modify the driver
to silently pass these calls through, but it would be nice if
wpa_supplicant didn't fail because a driver didn't support a
particular option.

I'll put together a patch to accept an IW_AUTH_MFP call set to NONE or
DISABLED, and fail on REQUIRED. In the meantime you could try use an
older wpa_supplicant. I think I was using 0.7.2 before, but I can't be
sure.


Dave.
