Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55316 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZGHQal (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 12:30:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: WANTED: someone who knows what exactly that ssb thingy is intended/used for
Date: Wed, 8 Jul 2009 18:30:38 +0200
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-wireless@vger.kernel.org
References: <4A548A3C.20800@canonical.com>
In-Reply-To: <4A548A3C.20800@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907081830.38368.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 July 2009 13:59:56 Stefan Bader wrote:
> Hi all,
> 
> I somehow wondered why on a Dell Inspiron 1521 the wireless is not cooperating 
> by default. The problem turns out to be the ssb module, which is not only a 
> dependency to the b44 driver (for the wired network card) but also likes to 
> handle the Broadcom 4328 device.

ssb is an internal bus on your b43 and b44 cards. So your setup looks like this:

pci-bus |
        |
        |>---ssb-
        |       |>-wireless core (b43 drives this)
        |       |>-management cores...
        |
        |>---ssb-
                |>-etheret core (b44 drives this)
                |>-management cores...

> In the end wireless works well when removing b44, ssb and wl. Then loading wl 
> first, followed by b44 (which pulls in ssb).

b43/b44/ssb are not compatible with wl. Uninstall wl.



-- 
Greetings, Michael.
