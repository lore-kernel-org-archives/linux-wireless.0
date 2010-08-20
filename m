Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0HTLFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 07:05:07 -0400
Subject: Re: scanning a specific ssid
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com>
References: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 13:05:03 +0200
Message-ID: <1282302303.3662.5.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christopher,

On Thu, 2010-08-19 at 16:25 -0400, Christopher Piggott wrote:
> Hi,
> 
> I wrote a small C++ program using libdbus-c++ to scan for access
> points via wpa_supplicant's dbus interface.  It works very well, and I
> can retrieve the list just fine.
> 
> Now I want to cause it to scan for a specific SSID by issuing a probe,
> but the dbus interface fi.epitest.hostap.WPASupplicant.Interface has
> only one scan method, and it does not seem to take arguments.
> (Looking at the source file ctrl_iface_dbus_handlers.c in function
> wpas_dbus_iface_scan() you can see why - it doesn't handle or even
> look at the arguments to the message).
> 
> Is there another way to accomplish this?  
I don't know which version of wpa_supplicant you're using, but the new
D-Bus API (fi.w1.wpa_supplicant1.*) has a much more extended scanning
API. You can pass SSIDs, channels, IEs and the scanning type to it.

Cheers,
Samuel.


