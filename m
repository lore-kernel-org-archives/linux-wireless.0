Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54554 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HGPiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 11:38:54 -0400
Received: by obbuo13 with SMTP id uo13so7649099obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2012 08:38:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120807190140.4796a045@emcraft.com>
References: <20120719133452.2fb375ae@emcraft.com>
	<CAOZOX0V=npQuQ03kur0mo7PtkdGVYiFO5B3OKhB7CMibLk50Ew@mail.gmail.com>
	<20120807190140.4796a045@emcraft.com>
Date: Tue, 7 Aug 2012 17:38:53 +0200
Message-ID: <CAOZOX0V1_zA3iTXhz7J4_t-BxNQ6k6V_-A_jky2B=fpbya-Lqg@mail.gmail.com> (sfid-20120807_173857_698586_18B64C2A)
Subject: Re: Access Point Mode for Ralink RT5370?
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Sergei Poselenov <sposelenov@emcraft.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> On Thu, Jul 19, 2012 at 11:34 AM, Sergei Poselenov
>> <sposelenov@emcraft.com> wrote:
>> > Hello,
>> >
>> > Does compat-wireless support the Access Point mode for the Ralink
>> > RT5370 chip? The driver source pack from the Ralink site only
>> > supports Managed and Ad-Hoc modes.
>>
>> Yes, the rt2x00-based drivers as found in the compat-wireless package
>> are working in AP mode.
>>
>
> I'm trying to set the master mode and it fails:
> ~ # iwconfig wlan0 mode Master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Invalid argument.
> ~ #
>
> The Linux Wireless FAQ here
> http://linuxwireless.org/en/users/Documentation/FAQ#Q:_iwconfig_wlan0_mode_master_does_not_work
> tells me that I should use hostapd instead of iwconfig to configure the
> master mode.
>
> However, for my project the WiFi security is not required. Also, I'm
> working on a custom ARM board with Linux 2.6.33 running.

But the FAQ doesn't say you need hostapd for WiFi Security, it says if you want
master mode, you must use hostapd..

> Could you please confirm I should really port hostapd to my target to
> configure my USB WiFi as Access Point?

Yes, you _must_ use hostapd.

Ivo
