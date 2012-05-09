Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37915 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2EIThj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 15:37:39 -0400
Received: by pbbrp8 with SMTP id rp8so896259pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 12:37:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
	<CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
	<CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
Date: Wed, 9 May 2012 21:37:38 +0200
Message-ID: <CAMG6FYgCsMzFB8MbZ50xX+5sVBZ1mxcRUDC=HeRnE2jr8LX06A@mail.gmail.com> (sfid-20120509_213743_221785_1D0108E6)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

> My system does not have Bluetooth at all.  Will the existence of a PTA
> record in my SDD file have any negative impact?
>
It will not have any valuable impact to the driver, just listen interval
will be limited a bit. And you can disable check for PTA record in the
driver code. Maybe it would be smart to make it configurable (?).

More interesting question is if presence of PTA entry affects firmware
and arbiter. I do not have a good answer for that, but I can guess it depends
on actual logical values on the PTA interface.

> Can I just delete the PTA record?  (Easier said than done since it is
> a binary file... but it can be done.)
>
But why can't you use SDD from your distribution, calibrated for your RF design?
It can be really huge difference in calibration parameters with different FEMs,
antennas etc. SDDs are independent from the firmware and you can use an SDD
with any firmware version.

Dmitry
