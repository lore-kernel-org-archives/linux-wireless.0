Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:63694 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZASVsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 16:48:10 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1409336fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 13:48:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901190930.11401.Info@delphi-real-estate.com>
References: <200901190930.11401.Info@delphi-real-estate.com>
Date: Mon, 19 Jan 2009 22:48:08 +0100
Message-ID: <69e28c910901191348s47c3db81teff62557055318de@mail.gmail.com> (sfid-20090119_224820_942048_FCBA66AC)
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
From: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 19, 2009 at 6:30 PM, Delphi Real Estate
<Info@delphi-real-estate.com> wrote:
>
> Can anyone tell me what I'm doing wrong?  I know that 'n' has problems in later drivers than in kernel 2.6.26, so I am trying to graft the 2.6.26 drivers into the 2.6.27 kernel.  Source:
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary
>
> I moved the regular Ubuntu kernel 2.6.27.10's iwlwifi directory elsewhere, and copied in Reinette's.  But it will not compile, inexplicably:
> ...
>  CC [M]  drivers/pci/hotplug/cpcihp_generic.o
>  LD [M]  drivers/pci/hotplug/pciehp.o
>  LD [M]  drivers/pci/hotplug/shpchp.o
>  CC [M]  drivers/pci/hotplug/fakephp.o
>  LD      drivers/pci/hotplug/pci_hotplug.o
>  LD [M]  drivers/media/video/uvc/uvcvideo.o
>  LD [M]  drivers/pci/hotplug/acpiphp.o
>  LD      drivers/pci/hotplug/built-in.o
>  LD      drivers/media/built-in.o
>  LD      drivers/pci/built-in.o
> make: *** [drivers] Error 2
> #
>
> This kernel does compile with its normal iwlwifi directory.  In configuring I only set the iwlwifi driver to be a module, disabled the 4965, and enabled the 5000.  I can't use the git kernel because I need the Ubuntu patches.

Try diffing the Ubuntu sources against the kernel.org sources, and
merge the resulting diff into the git tree.

>
> Is there any other way to get 5GHz 'n'?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
