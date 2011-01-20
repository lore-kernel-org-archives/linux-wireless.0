Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2495 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1ATMXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 07:23:13 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: zach <conflatulence@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 20 Jan 2011 04:23:03 -0800
Subject: RE: [PATCH] Kernel Panic on Associate with brcm80211.
Message-ID: <400C43189542CE41BC0A5B252FC90136952F059551@SJEXCHCCR02.corp.ad.broadcom.com>
References: <4D334D00.4030604@mythicnet.org>
 <4D3521FD.9020001@mythicnet.org>,<loom.20110120T120235-29@post.gmane.org>
In-Reply-To: <loom.20110120T120235-29@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zach, Ilya,

I posted an official patch (removing the assert) to the staging repository as I did run into this same issue. It will take some time before it is propagated. As this is a staging driver patches are to be sent to devel@linuxdriverproject.org (see http://driverdev.linuxdriverproject.org/pipermail/devel/).

Gr. AvS
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of zach [conflatulence@gmail.com]
Sent: Thursday, January 20, 2011 12:21 PM
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Kernel Panic on Associate with brcm80211.

Ilya Kogan <ikogan@...> writes:

>
> I'm going to admit I'm fairly new to this but after some reading, I
> couldn't quite understand why there is an assertion ensuring that the
> sk_buff being sent is not cloned. I was going to see what exploded if I
> removed it and to my surprise...nothing did. In fact, except for a few
>
> [12014.013409] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
> 382/256 dur 3562/1504
>
> things seem to work fine. I'll be doing some more testing with this over
> the next couple of days. What obvious thing does this break horribly?
>

Hi, I think I had the same panic on emachines em350 with BCM4313 using Fedora 14
and kernel 2.6.38-rc1. Network manager applet shows little blue dots going round
and then panic. Applying your change solved it. Thanks!
Photo of panic
http://picasaweb.google.com/lh/photo/hWEO_uFGNO-jAKjqhyJvkLevz6n8KX8fvZ44UIlA3yw?feat=directlink

config http://pastebin.com/9z8AmJ3E

zach

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


