Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:55815 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYI3ISs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 04:18:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
Date: Tue, 30 Sep 2008 10:18:31 +0200
Cc: "Anadi Mishra" <reachanadi@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com> <1221488871.10177.44.camel@localhost.localdomain> <e001a6370809290106s57660209lf590579f11f67647@mail.gmail.com>
In-Reply-To: <e001a6370809290106s57660209lf590579f11f67647@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809301018.31678.hs4233@mail.mn-solutions.de> (sfid-20080930_101854_559888_AB117361)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Your box looks hosed. I'd look into this things:

> [ 230.175944] nommu_map_single: overflow 7f0000000012+1578 of
> device mask ffffffff

Why do you get this strange output all the time?


> [ 230.435363] libertas host: PREP_CMD: command 0x0003

This seems ok (0x0003), but this:

[ 230.435363] libertas leave: lbs_queue_cmd()
[ 230.435363] libertas leave: __lbs_cmd_async(), ret ffff810037800000

can't possibly be. The function returns an internet, not
something like that.



[ 230.433291] libertas DNLD_CMD: 03 00 2e 00 01 00 00 00 00 00 00 00 00 00 00 00
[ 230.433291] libertas DNLD_CMD: ff ff ff ff ff ff 00 00 00 00 00 00 00 00 00 00
[ 230.433291] libertas DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00

That hexdump looks sane at the first glance.


[ 230.435363] usb8xxx usbd (INT): 1-8:Recv length = 0x32, Recv type = 0x160000
[ 230.435363] usb8xxx usbd (INT): 1-8:Unknown command type 0x160000

But the recv type again looks hosed. No wonder
the driver doesn't like this command type.
