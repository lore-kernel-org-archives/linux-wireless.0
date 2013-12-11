Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:59584 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LKLRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 06:17:06 -0500
MIME-Version: 1.0
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 11 Dec 2013 13:17:04 +0200
Message-ID: <CANUX_P3g_WFvpiUZi9h1MKbHRcDtTdrLjem6n0mSf9wwv_+UwA@mail.gmail.com> (sfid-20131211_121713_233193_7B05EE39)
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-rt-users@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 11, 2013 at 10:33 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> RT folks have raised issues with iwlwifi wrt. RT kernel some time
> ago. Johannes had a few patches to address this, but I had a few
> concerns with them. This series tries to address the RT concerns:
> * we don't do anything in hard-irq context besides stopping the
>   interrupts in the device.
> * the interrupt cause is read from the irq handler and is handled
>   there.
>

Well - this was a bit unfair :)
The code I get is probably very similar (and inspired) from Johannes's
work. But I guess I was missing:
iwlwifi: pcie: track interrupt mask in SW.


> This allows us to avoid the usage of _irqsave all over the driver
> and also avoids any kind of locks in the hard-irq context.
> We still have some work to do with the locks in the handler.
> I believe the locking model can be improved there.
>
> This patch series is split is very small patches. While this can
> annoy the reader - it helped me much to make sure I don't do anything
> wrong (well - I am still not sure) - and IMHO, it makes the review easier.
> For example, in patch
>     iwlwifi: pcie: move the ICT / non-ICT handling functions
> I just copy code from place to place without changing a bit. This makes
> the significant diff smaller.
>
> Emmanuel Grumbach (10):
>   iwlwifi: pcie: clean up ICT allocation code
>   iwlwifi: pcie: track interrupt mask in SW
>   iwlwifi: pcie: re-organize the PCIe ISR code
>   iwlwifi: pcie: move the ICT / non-ICT handling functions
>   iwlwifi: pcie: read the interrupt cause from the handler
>   iwlwifi: pcie: determine the interrupt type in the handler
>   iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
>   iwlwifi: pcie: no need to save inta in trans_pcie
>   iwlwifi: pcie: move interrupt prints to the common handler
>   iwlwifi: pcie: stop using _irqsave
>
>  drivers/net/wireless/iwlwifi/iwl-csr.h       |   3 +-
>  drivers/net/wireless/iwlwifi/pcie/internal.h |   9 +-
>  drivers/net/wireless/iwlwifi/pcie/rx.c       | 389 +++++++++++----------------
>  drivers/net/wireless/iwlwifi/pcie/trans.c    |  27 +-
>  drivers/net/wireless/iwlwifi/pcie/tx.c       |  10 +-
>  5 files changed, 185 insertions(+), 253 deletions(-)
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
