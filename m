Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:56810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZAWFRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:17:32 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2410390fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 21:17:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4979269F.1060500@lwfinger.net>
References: <4979269F.1060500@lwfinger.net>
Date: Fri, 23 Jan 2009 05:17:30 +0000
Message-ID: <3ace41890901222117q55040043lfcab89fc928422ed@mail.gmail.com> (sfid-20090123_061736_371761_D587BEB8)
Subject: Re: Regression caused by commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	John Linville <linville@tuxdriver.com>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 2:08 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> With the commit of the subject, my b43 and p54usb devices stopped working. They could
> associate and authenticate with my WPA2 network, but never finish the DHCP connection and
> get an IP address. Surprisingly, my rtl8187 devices continued to work.

I don't want to do a "me too", but my rtl8187B broke yesterday after
upgrading to wireless-testing/compat-wireless head,
and it worked again today. There are only two patches between
yesterday and today and one of them is John's revert, so it is
possible that the rtl8187B is also affected.

The symptom is as you said, I can associate and authenticate, but dhcp
won't finish and wpa_suplicant ifdown the device.
I tried that a few times and restarting NM, modprobe -r/-v, etc. In
the end it was easier just to blow away the compat-wireless update
redirectory and revert back to the vendor-shipped kernel modules - and
hope that it is just a transient problem and the problem would go away
when I git fetch next time :-).
