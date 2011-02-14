Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37989 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:14:40 -0500
Received: by qwa26 with SMTP id 26so2972376qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 02:14:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B7288B2B5878D747BA031EF4B170D7F6092D2727@TWHCMBS01.tw.ralinktech.ad>
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net>
	<AANLkTikKevPWkWMu=HLPHt-jACLZLQzqN6thr-2LNk59@mail.gmail.com>
	<B7288B2B5878D747BA031EF4B170D7F6092D2727@TWHCMBS01.tw.ralinktech.ad>
Date: Mon, 14 Feb 2011 11:14:39 +0100
Message-ID: <AANLkTimRT-2B4G1jC4D+BZURmd_FRGSkLT5MKsEvcS3r@mail.gmail.com>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in
 powersave mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: RA-Jay Hung <Jay_Hung@ralinktech.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@adurom.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	RA-Dennis Lee <Dennis_Lee@ralinktech.com>,
	RA-Eddy Tsai <Eddy_Tsai@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Well the official Ralink driver also uses a timer to wakeup the hardware,
>> there are however registers which suggest support for autowake functionality.
>
>> Jay, Dennis, Eddy, can you explain a but how the autowake functionality is
>> implemented in the rt2800usb firmware?
>
> Current power saving and wake up procedure as below.
>
> PCI:
> 1. Driver sends power-save command to firmware to turn off RF/BBP and configure
> mac register (AUTO_WAKEUP_CFG) to set a hardware timer counter.
> 2. When hardware timer timeout, issue an interrupt and notify the driver.
> 3. Driver send wake up command to firmware to turn on RF/BBP and ready to process
> packets
>
> USB:
> 1. Driver sends power-save command to firmware to turn off RF/BBP and set
> a software timer to emulate the purpose of hardware timer.
> 2. When software timer timeout, driver sends wake up command to firmware to
> turn on RF/BBP and ready to process packets.

Thanks. So I'll add this routine to the rt2800usb driver then. :)

Johannes, if you don't want to add the complexity for checking the
"pending MC/BC frames" in
a received frame. Would you mind if I add some utility functions to
mac80211 then? That way the
logic is still shared for the drivers that need it, but it doesn't
impact the code paths in mac80211 itself...

> Note: for future projects, hw or firmware will take more psm mechanism to reduce
> some latency between firmware and host to save more power.

Cool :)

Thanks for the info.

Ivo
