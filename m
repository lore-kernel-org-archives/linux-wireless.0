Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:51174 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYDZEqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 00:46:08 -0400
Received: by an-out-0708.google.com with SMTP id d31so1015506and.103
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 21:46:04 -0700 (PDT)
Message-ID: <43e72e890804252146y600b6b40x738e0826bc492b0@mail.gmail.com> (sfid-20080426_064632_469493_58A857F6)
Date: Fri, 25 Apr 2008 21:46:04 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Charles Figura" <charles.figura@wartburg.edu>
Subject: Re: Problems loading from compat-wireless-2008-04-24
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4810F9BC.7030104@wartburg.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4810F9BC.7030104@wartburg.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2008 at 2:21 PM, Charles Figura
<charles.figura@wartburg.edu> wrote:
> Greetings -
>
>  I just tried to build, install and load the 2008-04-24 release of the
>  compat-wireless project.  The make and installation seemed to work just
>  fine (a couple of warnings, along the line of
>
>  include/asm/io_32.h: In function 'memcpy_toio':
>  include/asm/io_32.h:217: warning: passing argument 1 of '__memcpy' discards
> qualifiers from pointer target type
>   CC [M]

This comes from your current kernel, so we don't provide update for
those kernel headers. Its safe though.

> /home/figura/compat-wireless-2008-04-24/drivers/net/wireless/rt2x00/rt2500pci.o
>  and
>  /home/figura/compat-wireless-2008-04-24/net/mac80211/wme.c:580: warning:
> initialization from incompatible pointer type
>  and make install showed no errors.
>
>  HOWEVER -
>  when I try to load the modules I get:
>  figura@nightfall:~/compat-wireless-2008-04-24$ sudo modprobe iwl3945
>  WARNING: Error inserting iwlwifi_mac80211
> (/lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/mac80211/compatible/net/mac80211/iwlwifi_mac80211.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>  FATAL: Error inserting iwl3945
> (/lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/iwlwifi/compatible/iwl3945.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>
>  If I do a 'make load', I get the above plus a boatload of other similar
>  error messages for iwl4965, rt2x_mac80211, rt2x00lib, rt2x00pci, etc...
>
>  I've attached the relevant parts of dmesg.  Any ideas what's going on
>  here?

Did you do make unload first? If not try that first and then try just
loading one module you are sure you need. I should probably remove
make load... hmm...

  Luis
