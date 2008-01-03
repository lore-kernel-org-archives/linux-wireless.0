Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:63121 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYACXck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 18:32:40 -0500
Received: by py-out-1112.google.com with SMTP id u52so10753755pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 15:32:39 -0800 (PST)
Message-ID: <43e72e890801031532g6eb57af2g18bd9491c53ad2f1@mail.gmail.com> (sfid-20080103_233245_671722_2C739444)
Date: Thu, 3 Jan 2008 18:32:37 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Rafael Remy" <rafi@theater-kgr.com>
Subject: Re: what kernel modules are nessecary for compact wireless
Cc: linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <loom.20071231T052528-182@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <loom.20071231T052528-182@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 31, 2007 12:28 AM, Rafael Remy <rafi@theater-kgr.com> wrote:
> hello
>
> i use a small holded 2.6.23-12 kernel with debian.
>
> what modules i have to put into the kernel for wireless working?
>
> i installed the kernel modules, the fwcutter and the firmware.
>
> PrinzIP:/lib/modules/2.6.23.12/updates/drivers/net/wireless/b43# modprobe b43
> WARNING: Error inserting ssb
> (/lib/modules/2.6.23.12/updates/drivers/ssb/ssb.ko): Unknown symbol in module,
> or unknown parameter (see dmesg)
> FATAL: Error inserting b43
> (/lib/modules/2.6.23.12/updates/drivers/net/wireless/b43/b43.ko): Unknown symbol
> in module, or unknown parameter (see dmesg)
>
> dmesg:
>
> ssb: Unknown symbol pcmcia_access_configuration_register

This is the problem. pcmcia_access_configuration_register() is a
routine exported by drivers/pcmcia/pcmcia_resource.c. This is built as
part of the pcmcia kernel module so you need pcmcia module built. Do
you have CONFIG_PCMCIA=m ?

Then since pcmcia was not loaded ssb couldn't be loaded, and since ssb
couldn't be loaded b43 couldn't be loaded.

  Luis
