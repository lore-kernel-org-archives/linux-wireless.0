Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42787 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1DJQf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:35:29 -0400
Received: by qwk3 with SMTP id 3so2863420qwk.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 09:35:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302450962.5282.129.camel@localhost>
References: <1302450962.5282.129.camel@localhost>
Date: Sun, 10 Apr 2011 18:35:28 +0200
Message-ID: <BANLkTi=-bRn_6yie1b=wxgVowqZq6+03CQ@mail.gmail.com>
Subject: Re: Firmware files for Ralink RT28x0
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Apr 10, 2011 at 5:56 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> I notice that rt2800{pci,usb} each specify only one firmware image,
> regardless of the controller version.
>
> This is inconsistent with rt28{6,7}0sta and with the firmware images in
> linux-firmware.

Well the rt2800pci/usb firmware behavior is consistent with the original
Ralink drivers (Not sure about the staging drivers, I only look to the drivers
on the Ralink website).

As for the linux-firmware that contains some firmware files for rt30** chipsets,
but that are not used by rt2800pci/usb for the simple reason that the latest
version of the rt2860.bin and rt2870.bin files contain support for
those chipsets
as well.

> If you think that a single image per bus type can cover all controllers,
> please identify those firmware images, test them on each hardware
> generation, and get them into linux-firmware.

Updating the firmware files in the linux-firmware tree seems to be
close to impossible. Multiple attempts have been made to update the
firmware files for rt73usb, rt61pci, rt2800pci and rt2800usb, and every
attempt has been ignored.
Even when Ralink sent the update directly, and it seemed that the patches
were accepted, they were still not applied.
So honestly, I think it might be easier to simply remove the Ralink firmware
files from the linux-firmware tree, as then at least the users won't accidently
use the outdated firmware files from that tree.

Ivo
