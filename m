Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48577 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZI2K2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 06:28:07 -0400
Received: by ewy7 with SMTP id 7so5259765ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 03:28:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909291145.35972.malte.gell@gmx.de>
References: <999306.93095.qm@web23102.mail.ird.yahoo.com>
	 <200909291058.43765.malte.gell@gmx.de>
	 <3ace41890909290206g3019a9cbv29048837804f830@mail.gmail.com>
	 <200909291145.35972.malte.gell@gmx.de>
Date: Tue, 29 Sep 2009 11:28:09 +0100
Message-ID: <3ace41890909290328l14620ed6o4939488e268d76a3@mail.gmail.com>
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need
	help to create driver for Netgear WN111v2
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 10:45 AM, Malte Gell <malte.gell@gmx.de> wrote:
>
> "Hin-Tak Leung" <hintak.leung@gmail.com> wrote
>
>> > So, no need to modify compat-2.6.28.c? Does it automatically happen?
>>
>> You may or may not  see any errors at the linker stage (the LD part in
>> stage 2). If you get to that point without further error, then, well,
>> count yourself lucky and just give "make install ; make unload;
>> modprobe -v ar9170" a go.
>
> Ho ho ;-) I got a lot of warnings like this:
>
>  include/linux/tracepoint.h:86:1: warning: this is the location of the
> previous definition
>
> But, it DID compile! Thanx a lot.
>
> To be sure I did a find . -name "*.ko" and got these modules:
>
> ./drivers/net/wireless/ath/ath.ko
> ./net/rfkill/rfkill_backport.ko
> ./net/wireless/cfg80211.ko
> ./net/mac80211/mac80211.ko
>
> I just wonder, where is ar9170usb !? I did ./scripts/driver-select ar9170
>
> Malte
>

Argh... try changing this line  in config.mk

ifndef CONFIG_COMPAT_WIRELESS_28

to ...27.

apparently it is disabled below 2.6.28.  but then, yours is somewhere between.
------------
commit 13e9384e59b2cadaef7468f1417b9a1327419c89
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Tue Jul 21 14:43:15 2009 -0700

    ar9170 works needs more compat work for 2.6.27

    We leave it only enabled for >= 2.6.28,
    usb_hcd_unlink_urb() is used within usb_poison_urb()
    and although it is available on 2.6.27 its not exported
    and cannot be re-implemented. If we figure out a way
    to drop the urb from the hardware queue as usb_hcd_unlink_urb()
    does then we can backport this.

    Also I think we need to backport usb_kill_urb_queue().

    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
------------
