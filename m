Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1548 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758712Ab3BYKXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:23:08 -0500
Message-ID: <512B3B7C.8060508@broadcom.com> (sfid-20130225_112313_462843_F833FB14)
Date: Mon, 25 Feb 2013 11:22:52 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Dead code in brcms_c_compute_rspec
References: <CACna6rx57gx7fLEq5Om7q2Pbn82vgRRhH5DpkKtsgyPjHKuEvA@mail.gmail.com>
In-Reply-To: <CACna6rx57gx7fLEq5Om7q2Pbn82vgRRhH5DpkKtsgyPjHKuEvA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/13 14:20, Rafał Miłecki wrote:
> Hey,
>
> I was looking for adding support for more devices in b43 and wanted to
> check how did you handled reading PHY type/id from rxchan/chanstat
> (it's a part of hardware-specific part of RX header).
>
> In rate.c you have brcms_c_compute_rspec which does:
> phy_type = ((rxh->RxChan&  RXS_CHAN_PHYTYPE_MASK)>>  RXS_CHAN_PHYTYPE_SHIFT);
> (you duplicate BRCMS_CHAN_PHYTYPE by the way).
>
> The problem is that:
> #define	RXS_CHAN_PHYTYPE_MASK	0x0007
> and you're comparing the result to the
> #define	PHY_TYPE_LCN		8
> which looks like a minor dead code for me.
>
> You may want to fix that.
>

Thanks, Rafał

That does not seem right. I will look into this.

Gr. AvS

