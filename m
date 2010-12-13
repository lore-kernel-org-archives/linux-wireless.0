Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42047 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0LMMgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 07:36:50 -0500
Received: by qwa26 with SMTP id 26so6177227qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 04:36:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <688860.58781.qm@web56806.mail.re3.yahoo.com>
References: <201012131232.50201.IvDoorn@gmail.com>
	<688860.58781.qm@web56806.mail.re3.yahoo.com>
Date: Mon, 13 Dec 2010 13:36:49 +0100
Message-ID: <AANLkTi=fp3yiFYKBjkMvis4TAdMAc27J-0d=n2VhQMUB@mail.gmail.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, js@sig21.net,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have two issues to report regarding system hangs. The system would either freeze entirely, prompting me to hard-reset it, or it would freeze certain parts of the system like, no shell commands execution. These occurrences manifest themselves sporadically, when I'm switching between modes (ad-hoc, monitor etc.), also when I try to rmmod the rt2xxx stuff or when unplugging the USB chip. I have to "ifconcfig wlanx down" the device first in order to not hang my box. My question is, will this patch fix all of that, or only parts of it? Here's log I managed to dig out.

This patch, but also the queue refactoring patches in this series
should resolve all unplug and rmmod bugs.

> My second question pertains to the STA drivers - rt3070sta. It is not possible to switch between the rt2800usb and rt3070sta without having to unplug the device and plugging it back again followed by loading manually the desired driver.
> I'm not sure but I think this might have  something to do withe voltage settings or the firmware. But it really is annoying to physically unplug the USB chip every time I switch between the two modules.
> Is it possible to enable switching between rt3070sta/rt2800usb without unplugging/plugging the USB chip?

It should be possible, but what are the exact problems that you encounter?
Is there a difference between going from rt3070sta to rt2800usb and vice versa?
(Please note that the rt2x00 project doesn't maintain the rt3070sta
driver in the staging directory).

Ivo
