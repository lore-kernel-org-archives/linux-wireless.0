Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45036 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0HSUZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 16:25:00 -0400
Received: by vws3 with SMTP id 3so2226353vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Aug 2010 13:25:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Aug 2010 16:25:00 -0400
Message-ID: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com>
Subject: scanning a specific ssid
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I wrote a small C++ program using libdbus-c++ to scan for access
points via wpa_supplicant's dbus interface.  It works very well, and I
can retrieve the list just fine.

Now I want to cause it to scan for a specific SSID by issuing a probe,
but the dbus interface fi.epitest.hostap.WPASupplicant.Interface has
only one scan method, and it does not seem to take arguments.
(Looking at the source file ctrl_iface_dbus_handlers.c in function
wpas_dbus_iface_scan() you can see why - it doesn't handle or even
look at the arguments to the message).

Is there another way to accomplish this?  I notice that a number of
dbus messages trigger a scan.  I don't really want to try to associate
with it, but perhaps that's the only way.

(I guess I could try to trigger the scan via netlink and receive the
results via dbus..... messy).

--Chris
