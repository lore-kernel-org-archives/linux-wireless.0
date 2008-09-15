Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.226]:32882 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbYIOWFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 18:05:25 -0400
Received: by qb-out-0506.google.com with SMTP id f11so3796232qba.17
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 15:05:22 -0700 (PDT)
Message-ID: <f488382f0809151505g54c0e59qfcf3bbdbf9428ba1@mail.gmail.com> (sfid-20080916_000529_467240_3136D1B0)
Date: Mon, 15 Sep 2008 15:05:21 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: ath9k-devel@lists.ath9k.org,
	wireless <linux-wireless@vger.kernel.org>, jmalinen@atheros.com,
	lrodriguez@atheros.com
Subject: Re: frustrating ath9k issues
In-Reply-To: <f488382f0809151450u2f5501cbt14ef9f4ce19a9eb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809151450u2f5501cbt14ef9f4ce19a9eb3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 2:50 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> More recently, I had another incident where it disassociated and
> refused to reassociate. I got about 100 of these in my dmesg (fixed by
> unloading and reloading ath9k):
>
> [...]
> [ 1279.031033] ath_set_channel: unable to reset channel 149 (5745Mhz)
> flags 0x30142 hal status 4294967277
> [ 1279.031203] ath9k_config: Unable to set channel
> [ 1279.323427] ath_set_channel: unable to reset channel 153 (5765Mhz)
> flags 0x50142 hal status 4294967277
> [ 1279.323577] ath9k_config: Unable to set channel
> [ 1279.624562] ath_set_channel: unable to reset channel 157 (5785Mhz)
> flags 0x30142 hal status 4294967277
> [ 1279.624687] ath9k_config: Unable to set channel
> [ 1279.916441] ath_set_channel: unable to reset channel 161 (5805Mhz)
> flags 0x50142 hal status 4294967277
> [ 1279.916586] ath9k_config: Unable to set channel
> [ 1280.207274] ath_set_channel: unable to reset channel 165 (5825Mhz)
> flags 0x10142 hal status 4294967277
> [ 1280.207387] ath9k_config: Unable to set channel
> [...]
>
> And finally, I'm most certainly not getting 802.11n connection speeds
> with this driver. The connection speed seems to be about equivalent to
> 802.11g (54mb/s), but I can't tell for certain with the messed up
> bitrate reporting from iwconfig.
>

Another incident of the same thing. I let it go a bit longer and it had this:
[...]
[22558.757888] ath_set_channel: unable to reset channel 56 (5280Mhz)
flags 0x10142 hal status 4294967277
[22558.757917] ath9k_config: Unable to set channel
[22559.048662] ath_set_channel: unable to reset channel 60 (5300Mhz)
flags 0x10142 hal status 4294967277
[22559.048692] ath9k_config: Unable to set channel
[22559.339607] ath_set_channel: unable to reset channel 64 (5320Mhz)
flags 0x10142 hal status 4294967277
[22559.339734] ath9k_config: Unable to set channel
[22559.632215] ath_set_channel: unable to reset channel 149 (5745Mhz)
flags 0x30142 hal status 4294967277
[22559.632261] ath9k_config: Unable to set channel
[22559.922479] ath_set_channel: unable to reset channel 153 (5765Mhz)
flags 0x50142 hal status 4294967277
[22559.922511] ath9k_config: Unable to set channel
[22560.212400] ath_set_channel: unable to reset channel 157 (5785Mhz)
flags 0x30142 hal status 4294967277
[22560.212418] ath9k_config: Unable to set channel
[22560.503130] ath_set_channel: unable to reset channel 161 (5805Mhz)
flags 0x50142 hal status 4294967277
[22560.503149] ath9k_config: Unable to set channel
[22560.795592] ath_set_channel: unable to reset channel 165 (5825Mhz)
flags 0x10142 hal status 4294967277
[22560.795632] ath9k_config: Unable to set channel
[22561.086033] ath_set_channel: unable to reset channel 6 (2437Mhz)
flags 0x700e2 hal status 4294967277
[22561.086053] ath9k_config: Unable to set channel
[22561.704924] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22561.704970] ath9k_start: Unable to complete ath_open
[22561.875781] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22561.875932] ath9k_start: Unable to complete ath_open
[22562.149045] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22562.149058] ath9k_start: Unable to complete ath_open
[22562.292357] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22562.292386] ath9k_start: Unable to complete ath_open
[22574.671761] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22574.671856] ath9k_start: Unable to complete ath_open
[22579.628460] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22579.629153] ath9k_start: Unable to complete ath_open
[22583.631045] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22583.631076] ath9k_start: Unable to complete ath_open
[22587.615757] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[22587.615789] ath9k_start: Unable to complete ath_open
