Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57658 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1BJEPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 23:15:32 -0500
Received: by iyj8 with SMTP id 8so896929iyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 20:15:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <426364.35269.qm@web36108.mail.mud.yahoo.com>
References: <426364.35269.qm@web36108.mail.mud.yahoo.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 10 Feb 2011 15:15:11 +1100
Message-ID: <AANLkTinoaTFbb3yaEmD5B4q+6U+VVtSVxrqnkryVrxeT@mail.gmail.com>
Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation
 Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Noel Milton Vega <nmvega@computingarchitects.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 14:31, Noel Milton Vega
<nmvega@computingarchitects.com> wrote:
> I'm writing because I'm having problems with the WiFi and Bluetooth interfaces
> provided by the "Intel Centrino Advanced-N 6230AGN" card in my laptop. I am
> running Fedora 14 Linux / 64 Bit, with the latest 2.6 kernel provided by their
> repositories (2.6.35.10-74.fc14.x86_64).

[snip]

> So it looks like (1) either these driver are not working for this device and
> needs to be fixed or *enhanced* to support this card; or (2) this is not the
> driver for this Intel Centrino Advanced-N 6230AGNdevice, and one needs to
> be written. So neither Wireless nor Bluetooth work because devices cannot be
> accessed.

Nothing needs to be done, these devices are already supported.

See the linked line in:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-6000.c;h=af505bcd7ae0977f1095fc02ce8b9553f70dd86d;hb=HEAD#l601

They have been supported since the 6th of May last year.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1808972f16adba592ceb10a47dee42ef8ee39cee

This support hit mainline in 2.6.36.

May I suggest that you upgrade your kernel or, failing that, use
compat-wireless. You should also make sure that you have the firmware
installed, it's in the iwl6000g2b-firmware package. (See:
https://admin.fedoraproject.org/pkgdb/acls/name/iwl6000g2b-firmware)

That said, given that F14 ships the firmware for this device, I'm
guessing it's supported somehow. You *did* install the firmware,
right?

Next time you submit a bug report like this, make sure that you:
1. Include the dmesg output for an attempt to load the driver. In your
case the output of "dmesg | grep iwl" would be a good start.
Completely unloading the driver and then re-loading it while recording
the output would be better.
2. Include lspci-n output as this means that we can match up your card
with the list supported in the driver - given the number of PCI ids
out there, we cannot match a text description like you provided to an
actual card as there's likely to be several different versions out
there with the same name, but differing IDs. If yours has a slightly
different ID than the officially supported ones, then it won't work.
3. Don't treat us like idiots.

Hope that helps,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
