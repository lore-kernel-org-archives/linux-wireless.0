Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eastrmpop111.cox.net ([68.230.240.53]:38793 "EHLO
	eastrmpop111.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYFBFb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 01:31:29 -0400
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao107.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080602051734.ODTV14275.eastrmmtao107.cox.net@eastrmimpo03.cox.net>
          for <linux-wireless@vger.kernel.org>;
          Mon, 2 Jun 2008 01:17:34 -0400
From: "Mark S." <throaway@yahoo.com>
To: linux-wireless@vger.kernel.org
Subject: Problem with 2.6.22 / Unknown symbol netif_subqueue_stopped
Date: Sun, 1 Jun 2008 22:17:22 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806012217.22151.throaway@yahoo.com> (sfid-20080602_073154_328251_4A90E40A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm running kernel 2.6.22. I've compiled and installed the wireless dri=
vers=20
from your latest tarball, which the documentation says should work with=
=20
2.6.22.  I'm using the kernel source for KLIB_BUILD. When attempting to=
 load=20
the resulting module zd1211rw, there is a cascade of errors starting wi=
th=20

  mac80211:  Unknown symbol netif_subqueue_stopped

Scanning through your wireless drivers and through the kernel source, I=
 don't=20
see where this exact symbol is defined. I see that it is called for=20
in /net/mac80211/tx.c And  I  see that __netif_subqueue_stopped is defi=
ned in=20
compat.h. But not netif_subqueue_stopped. Googling online, it appears t=
hat=20
netif_subqueue_stopped may be first defined in 2.6.23 in the kernel, th=
ough=20
I'm not sure on that point. =20

=46inally, I deleted tx.o and compiled again to be able to catch the me=
ssages. I=20
have  pasted the messages at the bottom of this message. The upshot is =
that a=20
great many symbols, but netif_subqueue_stopped in particular, do not ap=
pear=20
to be defined anywhere.

Please let me know If I'm looking in the wrong place for this symbol, a=
nd=20
what, if anything, I can do about it.

Thanks!
Mark

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

make KLIB=3D/tmp/olpc-kernel/linux-2.6.22/=20
KLIB_BUILD=3D/tmp/olpc-kernel/linux-2.6.22/
make -C /tmp/olpc-kernel/linux-2.6.22/ M=3D/tmp/compat-wireless-2008-05=
-31=20
modules
make[1]: Entering directory `/tmp/olpc-kernel/linux-2.6.22'
  CC [M]  /tmp/compat-wireless-2008-05-31/net/mac80211/tx.o
/tmp/compat-wireless-2008-05-31/net/mac80211/tx.c: In=20
function =E2=80=98__ieee80211_tx=E2=80=99:
/tmp/compat-wireless-2008-05-31/net/mac80211/tx.c:1037: warning: implic=
it=20
declaration of function =E2=80=98netif_subqueue_stopped=E2=80=99
  LD [M]  /tmp/compat-wireless-2008-05-31/net/mac80211/mac80211.o
  Building modules, stage 2.
  MODPOST 35 modules
WARNING: "netif_subqueue_stopped"=20
[/tmp/compat-wireless-2008-05-31/net/mac80211/mac80211.ko] undefined!
WARNING: "ssb_pcmcia_switch_coreidx"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "ssb_pcmcia_hardware_setup"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "ssb_pcmcia_switch_segment"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "ssb_pcmcia_ops" [/tmp/compat-wireless-2008-05-31/drivers/ssb/=
ssb.ko]=20
undefined!
WARNING: "ssb_pcmcia_init"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "ssb_pcmcia_exit"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "ssb_pcmcia_get_invariants"=20
[/tmp/compat-wireless-2008-05-31/drivers/ssb/ssb.ko] undefined!
WARNING: "rt2x00lib_free_firmware"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/rt2x00/rt2x00lib.=
ko]=20
undefined!
WARNING: "rt2x00lib_load_firmware"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/rt2x00/rt2x00lib.=
ko]=20
undefined!
WARNING: "pcmcia_request_irq"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pccard_parse_tuple"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_register_driver"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pccard_get_tuple_data"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_request_configuration"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_request_window"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pccard_get_first_tuple"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_map_mem_page"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_unregister_driver"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
WARNING: "pcmcia_disable_device"=20
[/tmp/compat-wireless-2008-05-31/drivers/net/wireless/b43/b43.ko] undef=
ined!
  LD [M]  /tmp/compat-wireless-2008-05-31/net/mac80211/mac80211.ko
make[1]: Leaving directory `/tmp/olpc-kernel/linux-2.6.22'


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
