Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37145 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYKSTNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 14:13:42 -0500
Subject: Re: [PATCH] wireless: sysfs was displaying different values for
	level and noise than procfs
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200811151831.26403.arvidjaar@mail.ru>
References: <200811151831.26403.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 14:13:39 -0500
Message-Id: <1227122019.2196.14.camel@dv> (sfid-20081119_201348_225220_15F9403F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-11-15 at 18:31 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] wireless: sysfs was displaying different values for level and noise than procfs
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> /proc/net/wireless asjusts display of signal and noise level depending on
> whether units are percentage or dBm. Use the same format in sysfs. This
> makes it easy to know unit - below zero is dBm, above zero is percent.

I've seen received power up to 3 dBm.  The AP was using an amplifier
(it's specialized hardware), and it's possible that the card on the
station side was exaggerating the signal.  However, the data we report
should not need any guesswork to be interpreted.  It may be parsed by
userspace software.

Receiving 1 mW out of 200 mW is not impossible in some antenna
configurations even with consumer devices.

> Before:
> {pts/1}% cat /sys/class/net/eth1/wireless/level
> 203
> {pts/1}% cat /sys/class/net/eth1/wireless/noise
> 166

> +	return sprintf(buf, format_string, (__s32)iw->field -		\
> +			((iw->qual.updated & IW_QUAL_DBM) ? 0x100 : 0)); \

I think non-dBm data should be shown in a special format: "203/255"
where 255 is the maximal value, and the dBm data should be shown as
numbers: "-48".  This way, we encourage use of dBm data by making it
easier to parse.

-- 
Regards,
Pavel Roskin
