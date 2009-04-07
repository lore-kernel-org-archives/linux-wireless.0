Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:42566 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZDGFNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 01:13:52 -0400
Received: by fg-out-1718.google.com with SMTP id 16so326332fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 22:13:49 -0700 (PDT)
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: What is needed to inplement a AP support in a driver?
References: <1239062777.4705.30.camel@maxim-laptop>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 07 Apr 2009 08:13:47 +0300
In-Reply-To: <1239062777.4705.30.camel@maxim-laptop> (Maxim Levitsky's message of "Tue\, 07 Apr 2009 03\:06\:17 +0300")
Message-ID: <87k55xhwqc.fsf@litku.valot.fi> (sfid-20090407_071356_252980_35F96522)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> I recently found that now ath5k supports AP mode.
> I also found that most of the work is now done in userspace.
>
> Since many drivers including my IWL3945 support sending beacons for IBSS
> (strictly speaking userspace can send them too, but this is  sub
> optimal), what else driver must support for AP?
>
> Sending to several stations ? (IBSS already has this), have several
> virtual devices (this is optional feature), what else?

At least sending multicast/broadcast frames immediately after DTIM
beacons. This is needed for clients in power save mode.

> Why iwl3945 still doesn't support AP mode?

No idea. I recall Intel talking about having patches to support AP mode
for iwl3945, but quick googling didn't reveal anything. All I found was
this from Tomas:

"We've enabled only iwl4965, not so ever effort was done for iwl3945

[...]

In general there should not problem to extend AP mode also for 3945 on
PC platform"

http://osdir.com/ml/linux.drivers.ipw3945.devel/2007-11/msg00184.html

It would be really nice to get AP mode support for iwl3945.
Unfortunately I don't have any spare time to work on that, but if you
are planning to work on it I (and others) can give you email support via
this mailing list.

-- 
Kalle Valo
