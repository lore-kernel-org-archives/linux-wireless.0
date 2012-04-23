Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46567 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2DWHAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 03:00:12 -0400
Received: by pbcun15 with SMTP id un15so3525648pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 00:00:11 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 03:00:11 -0400
Message-ID: <CA+7oygft-wqhnkk5wwondb57WuN2hLkVDKMXwKoaK+p9sZwAcw@mail.gmail.com> (sfid-20120423_090016_855159_2D34EC47)
Subject: how to configure compat-wireless to force manual firmware load?
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was using an older version of compat-wireless, specifically a build
from May 2011.  In that release of compat-wireless, the firmware was
loaded manually using a filesystem mounted in /sys.

I recently downloaded a newer version of compat-wireless:
compat-wireless-3.0.9-1.  In this version, it appears to spawn a
kernel thread to check /lib/firmware for the firmware and load it.  If
it is present, it loads the firmware, otherwise it fails saying that
it cannot be found.

I am having trouble with the automatic load:
<3>[  178.957584] otg_err: in s5pc110_otghcd_urb_dequeue()::00508
<3>[  178.958650] => fail to cancel_transfer()
<7>[  178.959879] usb 1-1.2: hcd_unlink_urb d13aa200 fail -1
<7>[  178.962510] usb 1-1.2: khubd timed out on ep0out len=0/4096
<3>[  178.963274] usb 1-1.2: ath9k_htc: Firmware - htc_7010.fw download failed
<4>[  178.971658] ath9k_htc: probe of 1-1.2:1.0 failed with error -22

Is there a way to configure (e.g., config.mk) compat-wireless to use
the manual way?  So I'd like to give the manual route a shot.

Thanks!
George
