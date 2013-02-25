Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3BYQmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:42:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UA18T-0003iE-N8
	for linux-wireless@vger.kernel.org; Mon, 25 Feb 2013 17:42:41 +0100
Received: from c-68-53-95-0.hsd1.tn.comcast.net ([68.53.95.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 17:42:41 +0100
Received: from aaraines by c-68-53-95-0.hsd1.tn.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 17:42:41 +0100
To: linux-wireless@vger.kernel.org
From: Drew Raines <aaraines@gmail.com>
Subject: Re: drivers/net/wireless/iwlwifi/dvm/tx.c and arch/x86/kernel/apic/ipi.c: Kernel trace when roaming between different Access Points with the same ESSID
Date: Mon, 25 Feb 2013 10:42:07 -0600
Message-ID: <87bob8cpls.fsf@mid.raines.me> (sfid-20130225_174227_935194_CC1F9DD7)
References: <CAD77+gQFfNvz02=0FWDq+KUGk5QO_MywWw=NBMk6YaFGNQ4+kA@mail.gmail.com>
	<CAD77+gTFDbNopgJjMv+BGJCbueR-k8Uiyq41DfOeF_t1oJm7EA@mail.gmail.com>
	<87d2vowff1.fsf@mid.raines.me>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drew Raines wrote:

> Richard Hartmann wrote:
>
>> Yet another one, this time during high USB i/o load.
>
> I've been suffering this issue as well since some version of the
> experimental Wheezy packages of 3.7.x, but it's also happening with a
> make-kpkg build of 3.8.
>
> If I switch APs in my house, my connection immediately fails and it
> won't work until I power the radio off and back on with the hardware
> switch on the side of the laptop.  I can't even `modprobe -r iwlwifi'
> the driver ("FATAL: Module iwlwifi is in use.").

As I was messing around with downgrading my kernel package (where'd
3.5-trunk go??) it occurred to me that I hadn't yet tried a more
recent version of firmware-iwlwifi.  I had been on 0.36+wheezy.1.
After installing 0.37 from experimental, this issue seems to have
disappeared.  I've been roaming around the house watching my wlan0
reassociate several times with a `ping -i3' running and it hasn't
lost its connection.

Richard, if you haven't updated, you might want to try:

  sudo apt-get -t experimental install firmware-iwlwifi

Thanks to the Intel guys for keeping this excellent hardware going on
Linux!

-Drew

