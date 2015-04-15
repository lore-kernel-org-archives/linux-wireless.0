Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36340 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbbDOOw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 10:52:56 -0400
Received: by obbeb7 with SMTP id eb7so23272994obb.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 07:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429035033-14076-11-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
Date: Wed, 15 Apr 2015 16:52:38 +0200
Message-ID: <CACna6rwJn695OzCdHu9KWUczcXext5mrLHvfVSMXsLekBm2tUg@mail.gmail.com> (sfid-20150415_165259_896034_1F6BA3B6)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 April 2015 at 20:10, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> With PCIE it is possible to support multiple devices with the
> same device type. They all load the same nvram file. In order to
> support this the nvram can specify which part of the nvram is
> for which pcie device. This patch adds support for these new
> types of nvram files.

I'm a bit unsure about this patch. Does it support NVRAM files that
are already in use by any platform? Or are you trying to solve problem
we hit with ARM routers like Netgear R8000?

If you developed this patch to support e.g. Netgear R8000 I'm afraid
it won't be really helpful. You won't be able to provide a single
NVRAM file for all devices because of many differences between
devices. I don't only mean different models, but even units. I believe
these PCIe devices have to receive NVRAM with e.g. MAC address so you
don't want to provide one file for all users.
It means we'll need to develop some extra layer that will fetch
*system* (SoC) NVRAM and translate it into a NVRAM file that will be
stored in user space. Then this file will be loaded back into the
kernel.

So if this is about adding support for embedded devices, I'd prefer
much more to simply use Linux's NVRAM driver to get all wanted
entries.

Other than that I'm a bit confused by the "pcie/" prefix you decided
to use. Every Broadcom NVRAM I've seen was using pci/ prefix.
Shouldn't you stick to this standard format? Switching to "pcie/"
would require another translation when reading entries from system
NVRAM.
