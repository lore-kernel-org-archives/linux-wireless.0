Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:36226 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753651AbdBGRWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 12:22:45 -0500
From: Tobias Guggenmos <slartibartfas421@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dmitry Osipenko <digetx@gmail.com>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
Date: Tue, 07 Feb 2017 18:22:29 +0100
Message-ID: <1685531.kB3gARbWZx@slartibartfas> (sfid-20170207_182316_981522_00346DCE)
In-Reply-To: <92f6dcb7-bbee-533a-7d49-21670286a3f3@lwfinger.net>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com> <03153d2a-abfd-78b4-4365-b80ec718e3e1@gmail.com> <92f6dcb7-bbee-533a-7d49-21670286a3f3@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12818537.8AGrHUBa5h"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12818537.8AGrHUBa5h
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Sonntag, 5. Februar 2017, 11:30:30 CET schrieb Larry Finger:
> On 02/05/2017 05:34 AM, Dmitry Osipenko wrote:
> > BTW, I have an issue with the 8192cu: WiFi stops to work after a while
> > (3-15 minutes) if I enable WMM QoS on the AP. There is nothing suspicious
> > in KMSG, connection is up but no packets go in/out. I tried to enable
> > debug messages in the driver, so when the WiFi stops to work I see that
> > some "temperature/led" notify still going on in the driver, but nothing
> > happens when I try to initiate a transfer (say to open a web page) - the
> > log is silent, like the requests are getting stuck/dropped somewhere
> > before reaching the driver. Is it a known issue? With the QoS disabled
> > everything works hunky-dory, however I get 2x-4x faster download speed
> > with QoS enabled (while it works.)
> > 
> > I noticed that rtl92c_init_edca_param() isn't wired in the driver, so I
> > suppose the QoS isn't implemented yet, right?
> > 
> > If it is an expected behaviour, I think at least printing a warning
> > message in the KMSG like "QoS unimplemented, you may expect problems"
> > should be good enough to avoid confusion.
> 
> As you have already seen, I decided to defer the more invasive patch. When
> backporting to stable, the smaller the change the better.
> 
> I have no knowledge of the internals of the RTL8192CU chip. As a result, the
> kinds of changes I can make are limited. I do know that the chip does
> implement QoS. I also noticed that the set_qos() callback routine was very
> different in rtl8192ce than in rtl8192cu. Attached is an untested patch to
> make the CU routine look like the CE version. Please see if it makes a
> difference.
> 
> Driver rtl8192cu has never been maintained by Realtek, and it will likely be
> removed from the kernel in the next few cycles. As you are running a new
> kernel, I would recommend rtl8xxxu instead. That driver has high
> reliability, and the speed is improving. Your other option would be a
> driver offered by the vendor of your particular device. Realtek used to
> have these drivers on their web site, but they now seem to have been
> removed. If your vendor does not have a driver,
> http://www.edimax.com/edimax/mw/cufiles/files/download/Driver_Utility/trans
> fer/Wireless/NIC/EW-7811Un/EW-7811Un_Linux_driver_v1.0.0.5.zip should work.
> 
> Larry

On my Realtek RTL8188CE card (using the rtl8192ce driver) the patch seems to 
fix the Issue (on Kernel 4.9.0). 

In contrast to what Dmitry Osipenko experienced, before the patch was applied, 
the WIFI usually crashed already a few seconds instead of 3-15 minutes after 
connecting to a network.

--nextPart12818537.8AGrHUBa5h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYmgJVAAoJEHWN/oaUcOEC/UkH/jFwxmWvOJFluFbBwqlFxRkb
iW/lLr9ggUV5/+BEQULLntg6hLf7AD2I8jwrU10McutLeGrcQ5tC3OlblFP1dySz
Fv91vsm4CZbMGUWylotK7+yPMYK+ZlXQ1Zm0QaevQ+fl43L0VVesY4PgwcQhK2bH
6+naJTGIm7TuBpneixeMmiBvERo9yO/EjrjDSZgfALkqcXXt/gV2021dIOqefD4v
GYqDPFip6MODw+Ynyp1FKfmGOoR0Fthu7UR60BWn9NTDGHBoPJUte/zVJCn3k1W5
FS3EyACvQhgyJ+lyEOoTAH+J8C5INfdkisF+GyLwyolFkjb0mY7jsMLGouGLmtA=
=gHup
-----END PGP SIGNATURE-----

--nextPart12818537.8AGrHUBa5h--
