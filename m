Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61278 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2CIV7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 16:59:54 -0500
Received: by wejx9 with SMTP id x9so1447225wej.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 13:59:53 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/5 V2] p54usb: Load firmware from work queue and not from probe routine
Date: Fri, 9 Mar 2012 22:45:14 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201203092245.14420.chunkeey@googlemail.com> (sfid-20120309_225958_790805_1FC42E92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 09, 2012 05:28:57 AM Larry Finger wrote:
> Drivers that load firmware from their probe routine have problems with the
> latest versions of udev as they get timeouts while waiting for user
> space to start. The problem is fixed by loading the firmware and starting
> mac80211 from a work queue. By using this method, most of the
> original code is preserved.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
Well, I thought this over and I think unless we change the Kconfig
and make the backend modules [p54pci, p54usb and p54spi]
module-only options, we have to go with request_firmware_nowait.

You see, if the p54* modules are compiled into the very bzImage:
The instant workqueue option wouldn't work because the device
might be initialized before the filesystem is. A combo approach
[delayed workqueue, when no userspacehelper is available and a 
direct call to request_firmware (when it is availabe)] would
work too, but then we would be reimplementing
request_firmware_nowait ...

Regards,
	Chr
