Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35698 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1BHTL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 14:11:28 -0500
Received: by wyb28 with SMTP id 28so6066055wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 11:11:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87mxm69ajp.fsf@purkki.adurom.net>
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net>
	<20110202212912.GA28687@sig21.net>
	<AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com>
	<87mxm69ajp.fsf@purkki.adurom.net>
Date: Tue, 8 Feb 2011 11:11:26 -0800
Message-ID: <AANLkTikgASqJ_7omn-Z4JWgAJ1dMtOYoSO8oa=GDtB=a@mail.gmail.com>
Subject: Re: [rt2x00-users] [RFC] rt2x00: Add autowakeup timer for receiving
 beacons while in powersave mode
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Stezenbach <js@sig21.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 8, 2011 at 12:48 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Aleksandar Milivojevic <alex@milivojevic.org> writes:
>
>> Half-related to above, and purely from user perspective.  Is there a
>> way to disable power saving for WiFi cards globally by default (for
>> example, by passing an option to device driver)?  Having power saving
>> turned on by default makes sense for laptops, but doesn't make much
>> sense for desktops.  And in my case (due to problem with at least some
>> rt2xxx chips that Ivo described) it causes relatively frequent
>> disconnects/reconnects from/to AP due to lost beacons.
>>
>> For my desktop system, I'd rather pass an option to device driver to
>> have power saving default to off, and have a smoother network
>> experience.
>
> There is CONFIG_CFG80211_DEFAULT_PS kconfig option, but I'm not aware
> of any other way to globally do this. I can only think of using iw or
> iwconfig to disable power save per device.

I'm using iwconfig currently to disable power saving for wireless card
on my desktop after it boots up.  However, from user perspective of
things, it would be awesome if default was not hard coded in the
kernel.

Though, I must admit that if it wasn't for the problem discussed
earlier in this thread, I probably wouldn't even notice power saving
was set to on.  I'm not sure if there are any other more subtle
downsides of having power saving enabled.
