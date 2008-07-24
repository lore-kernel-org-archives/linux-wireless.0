Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:56479 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbYGXPGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 11:06:40 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3486782wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 08:06:39 -0700 (PDT)
Message-ID: <69e28c910807240806t24a1c2f9l8814a2d98aac34d@mail.gmail.com> (sfid-20080724_170644_433177_DCA80646)
Date: Thu, 24 Jul 2008 17:06:39 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43: Debugging PHY TX errors
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200807241330.15439.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807241330.15439.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 1:30 PM, Michael Buesch <mb@bu3sch.de> wrote:
> I hacked up some scripts for debugging of the PHY transmission
> errors. It consists of two parts. One patch that has to be applied
> to the kernel driver (latest wireless-testing!) and one firmware
> binary patcher script (for latest supported firmware only!)
>
> Both are included in the attached tarball. Extract the tarball.
>
> So you first have to apply the included "b43-kernel-patch.patch" to
> the kernel driver and recompile your kernel.
> Then you have to patch your firmware by doing:
>
> cd phyerr-patcher-001
> bash ./patch-phyerr-logger.sh /lib/firmware/b43/ucode5.fw
>
> You might have to adjust the path to your firmware.
> On successful patching, the script will exit with a nice smilie: :)
>
>
> So when running the modified driver with the patched firmware, it sho=
uld
> dump the shared memory every time a PHY error occurs.
> More state dumps can be added to the kernel driver. The firmware is h=
alted
> while the phyerr logger function is running, so state should be consi=
stent.
>
> WARNING: This patch might kill your cat, or at least disturb your wir=
eless
> connectivity. Only use it for debugging the PHY transmission errors.
>
> Note that these scripts require a complete compiler toolchain, includ=
ing
> flex and bison, on your machine, as it will compile the assembler and
> disassembler tools.
>
> --
> Greetings Michael.

Please add this functionality to the open-source firmware too.

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
