Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39693 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYAKQkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 11:40:33 -0500
Message-ID: <47879BE4.7040108@lwfinger.net> (sfid-20080111_164042_599754_D904213A)
Date: Fri, 11 Jan 2008 09:40:04 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFT] b43: Add support for new firmware
References: <200801102046.56979.mb@bu3sch.de>
In-Reply-To: <200801102046.56979.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This patch adds support for new firmware.
> Please test this on old and new firmware.

I have tested this patch with old firmware. It seems to work; however my testing is not complete as
my computer has started hanging with the "Caps Lock" light flashing. The crash is not caused by this
patch as it happened with 2.6.24-rc5, which has run for many days. I do have a suggestion for
changing the patch (see below).

> +static inline
> +size_t b43_txhdr_size(struct b43_wldev *dev)
> +{
> +	if (b43_is_old_txhdr_format(dev))
> +		return 100 + sizeof(struct b43_plcp_hdr6);
> +	return 104 + sizeof(struct b43_plcp_hdr6);
> +}

Why not eliminate most of the magic numbers in this part with

size_t b43_txhdr_size(struct b43_wldev *dev)
{
	if (b43_is_old_txhdr_format(dev))
		return sizeof(struct b43_txhdr) - 4;
	return sizeof(struct b43_txhdr);
}

Larry
