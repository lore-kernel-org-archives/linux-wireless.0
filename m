Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59194 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2K1I5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 03:57:54 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so5150196wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 00:57:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL1gcdNLhwECUiJo7c-J3A349ZKNTYjgro6TY564UF7qCQkCmQ@mail.gmail.com>
References: <1354037225-30237-1-git-send-email-helmut.schaa@googlemail.com>
	<CAL1gcdNLhwECUiJo7c-J3A349ZKNTYjgro6TY564UF7qCQkCmQ@mail.gmail.com>
Date: Wed, 28 Nov 2012 09:57:51 +0100
Message-ID: <CAGXE3d-KVfOXa4mvUu0rqj827Us_5ssCRu1GnnaavaxPn=ui9g@mail.gmail.com> (sfid-20121128_095757_454421_1F0EE87A)
Subject: Re: [PATCH] rt2x00: Use addr_mask to catch invalid MAC addresses
 (rt61pci, rt73usb)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sgruszka@redhat.com, IvDoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Nov 28, 2012 at 8:57 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> I think it is possible to collapse your rt2800 related patch and this
> patch with a single patch only touching generic rt2x00 code.
>
> We could use the max_ap_intf field of the rt2x00_ops struct to
> determine the mask in a generic manner.
>
> So, we could have the following statement in generic code (e.g. in
> rt2x00lib_probe_dev):
>
>         rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] =
> (rt2x00dev->ops->max_ap_intf - 1);

Good point. I'll change that accordingly.

Thanks,
Helmut
