Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:35939 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbZDXOKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 10:10:50 -0400
Received: by fg-out-1718.google.com with SMTP id d23so184459fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2009 07:10:49 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: on radio_enabled
References: <1240439975.30082.66.camel@johannes.local>
	<87tz4ed0w7.fsf@litku.valot.fi>
	<1240568807.18031.34.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Apr 2009 17:10:47 +0300
In-Reply-To: <1240568807.18031.34.camel@johannes.local> (Johannes Berg's message of "Fri\, 24 Apr 2009 12\:26\:47 +0200")
Message-ID: <874oweb0rc.fsf@litku.valot.fi> (sfid-20090424_161108_035120_C91CA4C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I wonder where the use case for faster scanning is

Basically the situation where the device is not connected to any AP but
is periodidally trying to find one, for example by scanning every five
minutes. In that case every mW we can save in scanning improves use
times.

> but I guess the slow SPI bus really does make for a long delay in
> initialising due to firmware upload.

Exactly.

> I have no trouble with implementing it this way, and userspace can
> still set the interfaces down when it wishes to do that, while we can
> save a lot of power when userspace doesn't do it that way.

Yes.

> Now, what happens with "iwconfig wlan0 txpower off"? I can't figure out
> that one. Should it be completely equivalent to rfkill, regardless of
> what rfkill ends up doing?

In my opinion should be equivalent to rfkill. NB. I haven't properly
thought about this and I know nothing about rfkill, fortunately :)

-- 
Kalle Valo
