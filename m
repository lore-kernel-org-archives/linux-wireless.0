Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:45051 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbcIBJAK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 05:00:10 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc: sven@narfation.org, Pannirselvam Kanagaratnam <pannirk@gmail.com>
Subject: Debugging RTL8192CU firmware loading on 3.12 powerpc
Date: Fri, 02 Sep 2016 10:50:41 +0200
Message-ID: <1586991.4QUcrJhXOm@prime> (sfid-20160902_110015_407818_5B56087C)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1962750.gY0HZ3Ftb3"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1962750.gY0HZ3Ftb3
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

we are trying to integrate a RTL8192CU based WiFi adapter (TP-Link TL-WL822N) 
on a PowerPC based platform running a vendor-supplied/modified 3.12 kernel 
using compat-wireless (I've tried 2016-01-06 and 2016-06-20 versions). While 
the adapter works fine on my Laptop (using Debian 4.6 and 4.7 kernels), it 
seems the firmware loading fails on the PowerPC box. Here is some output from 
the kernel log:

[   36.945820] rtl8192cu: Chip version 0x11
[   37.026208] rtl8192cu: MAC address: ec:08:6b:15:38:0e
[   37.031301] rtl8192cu: Board Type 0
[   37.035074] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[   37.040911] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[   37.049583] usbcore: registered new interface driver rtl8192cu
[...]
[  221.588911] rtl8192cu:_ResetDigitalProcedure1():<0-0> #####=> 8051 reset 
failed!.........................
[  221.637599] rtl8192cu: MAC auto ON okay!
[  221.674610] rtl8192cu: Tx queue select: 0x05
[  233.233554] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready 
fail!! REG_MCUFWDL:0x00030006 .
[  233.233566] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not 
ready to run!

The outputs at 221 starts when I enable hostapd with a minimal AP-starting 
configuration.

Do you have any recommendations where the firmware loading problems could come 
from, and where we could start to debug? Any pointers would be appreciated.

Thank you,
      Simon
--nextPart1962750.gY0HZ3Ftb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJXyT1hAAoJEKEr45hCkp6hl74QAN1R8w2oewB5pfzAnzjYaCTc
5I78bAzrT8+M9v6fJXPGzPLGWp87Oe4B4ID+1ylMTL9SjPQ0kX5ECRtqU99tIiEI
gAE80OoFFT8yqspfKHtl6n57PHqTTLKEdyLWgQsPdD+UZR4drGvoO2LttegvWGiF
/qXTA5Jsddx00jk4xdT0iXezS3JVKLtanAlQAYITcmq1Lk9mqpOI0SGR6PLNPyek
n5wnQWHG3e6xKa3LcFUQVlZ1swax3W3s5CdLmvhQNyu3Atz9hhWhyZB7N77vHZl7
qg7WO2GVtIOsyWx/yz+a7BZmDWGIpoJCBJ48baF+k05tlbKKYvQVhrXtOfhOikWk
5upS+C78DPqQ323i0Ce9q3vZ0ho6CEBOn6Y/TjNzESBTz66RNksND8a5AbNGwGtD
CcBckWZHSrEyD41JXkiqFbwbdSYO5fY7fS6RpcRchPYTsnQ1UHPYtDIuHub8fn2z
abi4z/BCUMlyd+9cF0wGEZ0pSa6+t3nZAvUEeRh+l7yQZrydz+MYLIzH2+cMi6Oo
nNJNBoMP1eVt3z3brL69T7T7OKullkrjv2lgGmKb/LvdyJDXAXxM3id7qtPx9bpD
2pc7hx/fFb0mbBc70EDIvdhMrMnGNFKZE1D9CVPMj546pwYHDEhOAlgiWORvjWPR
bQxVoGW7TZCguIJdEdSH
=z0+n
-----END PGP SIGNATURE-----

--nextPart1962750.gY0HZ3Ftb3--
