Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab0KXHBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 02:01:25 -0500
Received: by fxm13 with SMTP id 13so4684648fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 23:01:23 -0800 (PST)
References: <AB927C5B3615784183753F31BCC83EA38C58FE29@AD.d3.local> <20101123191338.GG3245@WorkStation> <AB927C5B3615784183753F31BCC83EA38C58FE32@AD.d3.local> <AB927C5B3615784183753F31BCC83EA38C58FE34@AD.d3.local>
In-Reply-To: <AB927C5B3615784183753F31BCC83EA38C58FE34@AD.d3.local>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <44125D8E-793F-49B1-AEE5-52A3265EC6F5@wizery.com>
Cc: "ido@wizery.com" <ido@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: No scan results from wl1271-sdio
Date: Wed, 24 Nov 2010 09:02:37 +0200
To: Josh Watts <JWatts@d3engineering.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 בנוב 2010, at 23:35, Josh Watts <JWatts@d3engineering.com> wrote:

> On Tue, 2010-11-23 at 16:30 -0500, Josh Watts wrote:
>> On Tue, 2010-11-23 at 21:13 +0200, Ido Yariv wrote:
>>> On Tue, Nov 23, 2010 at 10:34:14AM -0500, Josh Watts wrote:
>>>> I'm wondering if there's maybe some
>>>> minor component or setting that I'm missing (like radio-enable, or
>>>> perhaps limit to 802.11a, etc)?
>>> Hi Josh,
>>> 
>>> These kind of problems could be caused by using a wrong reference clock
>>> value. Could you please double check that the reference clock
>>> (board_ref_clock) matches the reference clock connected to the wl1271?
>>> 
>>> Regards,
>>> Ido.
>> 
>> Does board_ref_clock refer to the SLOW_CLK signal fed to the TiWi board?
> 
> Oops, I see now I was confused on this point. It appears board_ref_clock
> refers to the SDIO clock line, correct?

No, it's an external clock source hardwired to the 1271 device. You have no control of it, you just need to let the driver know its frequency.

So you can either consult with your module maker, or just try each of the possible options one by one, and see if any of these fix the issue :)


> It appears that my MMC/SDIO
> interface is auto-configuring itself to 25MHz. Is this close enough to
> 26MHz, or do you think I should look into adjusting/forcing the
> interface to operate at one of the rates listed in wl12xx/boot.c?
> 
> --
> Josh Watts
