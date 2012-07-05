Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62503 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2GEOZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 10:25:52 -0400
Received: by wibhm11 with SMTP id hm11so6699819wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 07:25:51 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 16:25:49 +0200
Message-ID: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com> (sfid-20120705_162557_048014_F2AC6601)
Subject: SIOCSIFFLAGS: operation not supported error message when tryinging to
 bring up an interface in adhoc mode
From: Philippe Agostini <philippe.agostini@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am currently developing a wifi driver and I am having trouble with
the adhoc mode. I am developing on Ubuntu 10.04 with kernel 2.6.32. To
verify that my initialization is correct, I try to bring up and
configure virtual interfaces. It's working in managed mode, but when I
try an "ifconfig wlan0 up" in adhoc mode I get the following error
message: "SIOCSIFFLAGS: operation not supported". At first I thought
that it was because of the regulatory domain, but I defined only one
supported channel (channel 6, F=2437 MHz) and it seems to me that iw
reg get tells me that on this frequency I am allowed to set up
wireless device in adhoc mode (country 00: (2402 - 2472 @ 40), (3, 20)
and no flags following).

Are there mandatory flags to set up (besides wiphy->interface_modes =
BIT(NL80211_IFTYPE_ADHOC)) that I missed, or callbacks to define in
order to have a working adhoc interface ?

Best regards

Philippe
