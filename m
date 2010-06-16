Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53284 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0FPFmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 01:42:23 -0400
MIME-Version: 1.0
In-Reply-To: <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-4-git-send-email-justinmattock@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 16 Jun 2010 15:42:02 +1000
Message-ID: <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The patch below fixes the warning message I am seeing with gcc 4.6.0
>  CC      drivers/pci/bus.o
> drivers/pci/bus.c: In function 'pci_enable_bridges':
> drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/pci/bus.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 628ea20..84bdb48 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>  void pci_enable_bridges(struct pci_bus *bus)
>  {
>        struct pci_dev *dev;
> -       int retval;
>
>        list_for_each_entry(dev, &bus->devices, bus_list) {
>                if (dev->subordinate) {
>                        if (!pci_is_enabled(dev)) {
> -                               retval = pci_enable_device(dev);
>                                pci_set_master(dev);
>                        }
>                        pci_enable_bridges(dev->subordinate);

Er, this appears to be bogus: I'm only guessing, but I'd expect that
the pci_enable_device() call is actually doing something useful, and
removing it is going to break *something* - Have you booted a kernel
with this code enabled and these patches applied?

As for this warning, I think that there is a better solution.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
