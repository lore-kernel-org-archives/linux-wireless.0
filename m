Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40343 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1BIMR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:17:27 -0500
To: Aleksandar Milivojevic <alex@milivojevic.org>
Cc: Johannes Stezenbach <js@sig21.net>, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [RFC] rt2x00: Add autowakeup timer for receiving beacons while in powersave mode
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net> <20110202212912.GA28687@sig21.net>
	<AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com>
	<87mxm69ajp.fsf@purkki.adurom.net>
	<AANLkTikgASqJ_7omn-Z4JWgAJ1dMtOYoSO8oa=GDtB=a@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 09 Feb 2011 14:17:25 +0200
In-Reply-To: <AANLkTikgASqJ_7omn-Z4JWgAJ1dMtOYoSO8oa=GDtB=a@mail.gmail.com> (Aleksandar Milivojevic's message of "Tue\, 8 Feb 2011 11\:11\:26 -0800")
Message-ID: <87pqr1767e.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aleksandar Milivojevic <alex@milivojevic.org> writes:

> On Tue, Feb 8, 2011 at 12:48 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> Aleksandar Milivojevic <alex@milivojevic.org> writes:
>>
>> There is CONFIG_CFG80211_DEFAULT_PS kconfig option, but I'm not aware
>> of any other way to globally do this. I can only think of using iw or
>> iwconfig to disable power save per device.
>
> I'm using iwconfig currently to disable power saving for wireless card
> on my desktop after it boots up.  However, from user perspective of
> things, it would be awesome if default was not hard coded in the
> kernel.

Well, we have the kconfig option which you can use to achieve that.

> Though, I must admit that if it wasn't for the problem discussed
> earlier in this thread, I probably wouldn't even notice power saving
> was set to on.  I'm not sure if there are any other more subtle
> downsides of having power saving enabled.

Yeah, with a proper power save implemention user should not even
notice any difference, apart from the reduced power consumptin of
course. But if something in power save is broken (either in the client
or in the AP) all sort of weird problems start to happen: network
drops, randomly lost packets, packects going only one way and so on.

-- 
Kalle Valo
