Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59409 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaGGNkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 09:40:19 -0400
MIME-Version: 1.0
In-Reply-To: <53B6DC5F.3090304@rempel-privat.de>
References: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
	<53B6DC5F.3090304@rempel-privat.de>
Date: Mon, 7 Jul 2014 15:40:18 +0200
Message-ID: <CAE4k238pWc4nB1S1S7OJBVh-_bUnO+D6uQJ98wMTk-E7FZ4+yw@mail.gmail.com> (sfid-20140707_154025_833367_5C18FBEA)
Subject: Re: ath9k -> bogus usb xfer on at91
From: Anders Darander <anders.darander@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 July 2014 18:54, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 04.07.2014 18:30, schrieb Alan Stern:
>> On Fri, 4 Jul 2014, Anders Darander wrote:
>>> ~# usb 1-1: new full-speed USB device number 3 using at91_ohci
>>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
>>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>>> -----------[ cut here ]-----------
>>> WARNING: CPU: 0 PID: 93 at
>>> /mnt/cs-builds/anders/oe-build/build-ccu/tmp-eglibc/work/ccu-oe-linux-gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb/core/urb.c:450
>>> usb_submit_urb+0x2ac/0x460()
>>> usb 1-1: BOGUS urb xfer, pipe 1 != type 3

>>
>> I can't tell exactly where the fault is, but this message means that an
>> URB was submitted for a bulk endpoint with a pipe of type
>> PIPE_INTERRUPT.
>
> Then kernel driver and firmware should be updated. There was some
> Bulk/Interrupt issues which was fixed last year.

Any pointers to the bulk/interrupt issues? Was it a general issue, or
related either to
at91-ohci or ar9271?

As far as I've been able to find out, I've got the latest firmware
(check again with linux-firmware).
I've also tried with the master from open-ath9k-htc-firmware.

> I hope this HW will not be used as AP.

Is this based on the use of at91- SoC, or based on the ar9271?

The primary use case is to run as a client, though there will likely
be some instances where it'll
function as a AP. (Though primarily for M2M communications), thus
pretty low traffic.

Cheers,
Anders

-- 
Anders Darander
EPO guidelines 1978: "If the contribution to the known art resides
solely in a computer program then the subject matter is not
patentable in whatever manner it may be presented in the claims."
