Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3JBJTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:19:51 -0400
Date: Wed, 2 Oct 2013 11:16:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-wireless@vger.kernel.org, ivdoorn@gmail.com,
	gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: Re: [PATCH] rt2x00_pci: Fix interrupt handler name (visible at
 /proc/interrupts)
Message-ID: <20131002091634.GD1442@redhat.com> (sfid-20131002_111954_409664_00E71BF8)
References: <459361380660046@web2g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <459361380660046@web2g.yandex.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 02, 2013 at 12:40:46AM +0400, Kirill Tkhai wrote:
> Currently driver name is wrong. PCI device address is visible at
> /proc/interrupts instead of the name:
> 
>  43:    124      0      0      0   PCI-MSI-edge    rtsx_pci
>  44:    384      0      0      0   PCI-MSI-edge    snd_hda_intel
>  45:  25096      0      0      0   PCI-MSI-edge    0000:01:00.0
>                                                    ^^^^^^^^^^^^
> 
> So, pass the right name. rt2x00_ops->name contains KBUILD_MODNAME
> and good for that, so pass it.
> 
> Handler names will be "rt2500pci", "rt2500pci" etc.

Looks sane. I was afraid that is not possible to have two or more
interrupts with the same name, but that's not true.

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Stanislaw
