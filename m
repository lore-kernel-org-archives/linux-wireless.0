Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61515 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0K3Xa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 18:30:56 -0500
Received: by qwb7 with SMTP id 7so6376187qwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 15:30:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com> <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Wed, 1 Dec 2010 00:30:35 +0100
Message-ID: <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On Tue, Nov 30, 2010 at 10:59 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Make sure you have CONFIG_REGULATOR_FIXED_VOLTAGE enabled, and please
> send us a full terminal log from boot to first error after applying
> the following patch:

The regulator is only enabled once. Equally, the MMC interface is
initialised only at boot, and remains untouched afterwards. It's
config doesn't change:

clock:		25000000 Hz
vdd:		7 (1.65 - 1.95 V)
bus mode:	2 (push-pull)
chip select:	0 (don't care)
power mode:	2 (on)
bus width:	2 (4 bits)
timing spec:	0 (legacy)

Full kernel log (rather large): http://130.89.163.61/dmesg

What concerns me is the regulator config - most boards seem to call
the fixed regulator vmmc, but I require VSIM as well to power the card
(which requires it to be labeled vmmc for the mmc subsystem?).

Joerie
