Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:34010 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752283AbdLELl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 06:41:27 -0500
Received: by mail-wr0-f177.google.com with SMTP id y21so20642907wrc.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Dec 2017 03:41:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d776bc3d-7712-8430-93e2-72e4b6bbf23c@exactcode.com>
References: <d776bc3d-7712-8430-93e2-72e4b6bbf23c@exactcode.com>
From: Belisko Marek <marek.belisko@gmail.com>
Date: Tue, 5 Dec 2017 12:41:25 +0100
Message-ID: <CAAfyv35EDMmyW_FTJJsNbOweivd=xwDgb=omRA4swQiu4ZXUqQ@mail.gmail.com> (sfid-20171205_124135_216869_B7DABB31)
Subject: Re: MWIFIEX still unstable after two years on MS Surface Pro 3
To: =?UTF-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rene,

On Tue, Dec 5, 2017 at 12:06 PM, Ren=C3=A9 Rebe <rene@exactcode.com> wrote:
> Hi all,
>
> I write to start a discussion about the state of the mwifiex driver.
> For over two years many other and me wait that the driver finally becomes
> "stable". However, even with kernel 4.14.2 it still fails after some
> minutes, or latest after some hours. With various stray errors in the sys=
tem
> log:
>
> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: MWIFIEX
> VERSION: mwifiex 1.0 (15.68.7.p119)
> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: driver_versio=
n =3D
> mwifiex 1.0 (15.68.7.p119)
>
> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: trying =
to
> associate to 'XXX' bssid xx:xx:xx:xx:xx:xx
> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: associa=
ted
> to bssid xx:xx:xx:xx:xx:xx successfully
> ...
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: Firmware wake=
up
> failed
As workaround you can disable powersave for wifi (using iw command)
and test it should resolve an issue (at least it fixes for me).
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: FW =
in
> reset state
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: car=
d
> is removed
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the
> crypto keys
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: car=
d
> is removed
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the
> crypto keys
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: car=
d
> is removed
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the
> crypto keys
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: car=
d
> is removed
> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the
> crypto keys
>
> Also, rmmod usually then hangs, and even if it eventually force unloads a=
nd
> such re-loading the module does not even get it back into some working
> state. Not even with echoing 1 into the pci reset file.
>
> If this firmware and driver is already for years not working very stable,
> can this not at least recover more gracefully?
>
> Any suggestions how to finally address and solve these issues are welcome=
.
>
> If someone needs more logs and debug fluff let me know to generate it as
> necessary.
>
> For what it is worth, at least the USB attached mwifi chip in the Surface=
 2
> appears to work more reliable with the Linux driver.
>
> Best regards,
>         Ren=C3=A9 Rebe
>
> --
>   Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10117 Berlin
>   http://exactcode.com | http://t2-project.org | http://rene.rebe.de

BR,

marek

--=20
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
