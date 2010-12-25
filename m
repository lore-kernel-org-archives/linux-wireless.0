Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36669 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0LYVuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Dec 2010 16:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
References: <AANLkTi=aHU57xDq+-DWrN2sJsAwx_9bZ_ofy1rOmp0VH@mail.gmail.com>
	<Pine.LNX.4.44L0.1012251046060.5079-100000@netrider.rowland.org>
	<AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
Date: Sat, 25 Dec 2010 22:50:52 +0100
Message-ID: <AANLkTikcTSgjdxR106H2XZdmepN40bTKfEgmP04OQAz3@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On Sat, Dec 25, 2010 at 9:58 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Sat, Dec 25, 2010 at 6:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> Right.  You may or may not realize it, but this requirement means that
>> the driver _must_ bypass runtime PM sometimes.
>
> http://www.spinics.net/lists/linux-pm/msg22864.html
>
>> Now you've lost me.  Which of the driver's handlers are you talking
>> about?
>
> The driver's handler, which is called by mac80211, and is responsible
> to power off the device.
> The _same_ handler is being called either during runtime or during a
> system transition to suspend
>
>> What races?
>
> Driver thinks power is off and device is now fully reset, but it's isn't really

maybe it's worth starting off with the description of chip power
states and how they are mapped to runtime PM and static PM?

Most of the WLAN chips have some very low power modes, but you're
talking about _complete_ shutdown as a suspended state for both
runtime PM and static PM, is that correct?

Thanks,
   Vitaly
