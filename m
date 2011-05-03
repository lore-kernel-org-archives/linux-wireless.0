Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1ECBQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 21:16:04 -0400
Message-ID: <4DBF574E.80309@lwfinger.net> (sfid-20110503_031623_509396_AB32F630)
Date: Mon, 02 May 2011 20:15:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan> <4DB74788.2000908@lwfinger.net> <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan> <alpine.DEB.2.02.1105021944560.14515@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1105021944560.14515@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2011 06:46 PM, Justin Piszcz wrote:
> Just an update, this driver has been solid so far:
> rt2870sta
>
> With the Media Link 150 USB stick, not a single crash yet--
> The rt2800usb driver is laggy and crashes the kernel (as of 2.6.38.x)--
> Is there a possiblity to get rtl2870sta into the mainline?

Not a chance. As of 2.6.39, it is gone.

> It is the best wireless driver I've used for Linux with various usb wifi
> adapters--

That driver was in staging because it does not use mac80211, which is an 
absolute requirement for a new mainline driver. Keeping things like rt2870sta 
that contain their own MAC layer just bloats the kernel and has code persist 
that no one really understands.

Please try the version of rt2800usb from compat-wireless with the latest 
firmware. If it still crashes the kernel, then post the bugs.

Larry
