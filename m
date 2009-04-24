Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44239 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZDXOoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 10:44:32 -0400
Message-ID: <49F1D036.6080607@lwfinger.net> (sfid-20090424_164436_427386_6AC39B92)
Date: Fri, 24 Apr 2009 09:44:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net> <20090419200146.GB28885@storm.local.network> <20090419223218.GA30599@kroah.com> <20090424110329.GJ2830@storm.local.network>
In-Reply-To: <20090424110329.GJ2830@storm.local.network>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46orest Bond wrote:
>=20
> The following git repository has a vt6655 branch and a vt6656 branch:
>=20
>   http://www.alittletooquiet.net/media/code/vt665x.git
>=20
> The vt6655 branch contains pretty much all of the work I'll likely be=
 able to do
> for that driver.  The vt6656 branch needs more work.  I've not gone f=
arther than
> build-testing either, at this point.

It would be a little easier for looking at the code if both vt6655 and =
vt6656
directories were in the same branch of the git repo, but it's not a big=
 deal.

> As I've mentioned before, some of this kind of work is really a bit o=
utside my
> usual domain, so if you do look at it, I'd appreciate feedback.

There are a number of warnings when compiling the vt6655 driver on x86_=
64
architecture that arise from pointers having 64 bits while integers hav=
e 32
bits. I think the warnings will not cause any problems. There is, howev=
er, one
error, namely:

  CC [M]  drivers/staging/vt6655/device_main.o
drivers/staging/vt6655/device_main.c:347: error: initializer element is=
 not constant
drivers/staging/vt6655/device_main.c:347: error: (near initialization f=
or
=E2=80=98device_id_table[0].driver_data=E2=80=99)

The following patch fixes the compilation by removing the integer cast =
on
chip_info_table:

Index: vt665x/drivers/staging/vt6655/device_main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- vt665x.orig/drivers/staging/vt6655/device_main.c
+++ vt665x/drivers/staging/vt6655/device_main.c
@@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]=3D {
 };

 static struct pci_device_id device_id_table[] __devinitdata =3D {
-{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[=
0]},
+{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, &chip_info_table[0]},
 { 0, }
 };
 #endif

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

Driver vt6656 also does not build, but that does not seem to be 64-bit =
related.
If it builds on your system, let me know and I'll send you the error me=
ssages.

I didn't look that thoroughly at the code, but I did notice one thing. =
The
constructions like "#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)" ar=
e in the
code so that it can build on a number of different kernels. Once it is =
in
staging, it only has to build on the current kernel and you can trim ou=
t those
conditionals.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
