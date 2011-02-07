Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58178 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1BGXdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 18:33:20 -0500
Received: by wwi17 with SMTP id 17so3519776wwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 15:33:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110202212912.GA28687@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net>
	<20110202212912.GA28687@sig21.net>
Date: Mon, 7 Feb 2011 15:33:19 -0800
Message-ID: <AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com>
Subject: Re: [rt2x00-users] [RFC] rt2x00: Add autowakeup timer for receiving
 beacons while in powersave mode
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 2, 2011 at 1:29 PM, Johannes Stezenbach <js@sig21.net> wrote:
> On Wed, Feb 02, 2011 at 07:42:51PM +0200, Kalle Valo wrote:
>> So the firmware/hardware doesn't have support for tracking and waking
>> up for beacons? I didn't even know that such hardware exists :) Waking
>> up for beacons from host sounds very inefficient and unrealiable. All
>> the devices I have seen either do this in firmware or hardware due to
>> time constraints. Even at76c50x-usb, which is ancient, does all this
>> in firmware.
>
> IMHO this is a bit exaggerated.  Given that the beacon interval
> is typically ~100 msecs, and typical worst cast irq latencies
> on Linux 2.6 are a few 100 usecs, we can sleep e.g. 90msecs
> and wake up in time to catch the beacon with high probability, thus
> saving 90% on PHY power.  Not perfect, but good enough, isn't it?

Half-related to above, and purely from user perspective.  Is there a
way to disable power saving for WiFi cards globally by default (for
example, by passing an option to device driver)?  Having power saving
turned on by default makes sense for laptops, but doesn't make much
sense for desktops.  And in my case (due to problem with at least some
rt2xxx chips that Ivo described) it causes relatively frequent
disconnects/reconnects from/to AP due to lost beacons.

For my desktop system, I'd rather pass an option to device driver to
have power saving default to off, and have a smoother network
experience.
