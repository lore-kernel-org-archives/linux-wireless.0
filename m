Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:63948 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdGDIrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 04:47:53 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v2] wlcore: add missing nvs file name info for wilink8
Date: Tue, 4 Jul 2017 08:47:48 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B363E29ED@DFRE01.ent.ti.com> (sfid-20170704_104833_081570_4BE23BF9)
References: <8665E2433BC68541A24DFFCA87B70F5B363E2669@DFRE01.ent.ti.com>
 <20170704081917.GI3730@atomide.com>
In-Reply-To: <20170704081917.GI3730@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony,

> > When working with wl18xx the nvs file is used for defining an alternate
> > mac address and override the default mac address that is stored inside
> > the wl18xx chip.
> >
> > The following commits:
> > c815fde wlcore: spi: Populate config firmware data
> > d776fc8 wlcore: sdio: Populate config firmware data
> >
> > Populated the nvs entry for wilink6 and wilink7 only while it is
> > still needed for wilink8 as well.
> > This broke user space backward compatibility when upgrading from older
> > kernels, as the alternate mac address would not be read from the nvs th=
at is
> > already present in the file system (lib/firmware/ti-connectivity/wl1271=
-
> nvs.bin)
> > causing mac address change of the wlan interface.
> >
> > This patch fix this and update the structure field with the same defaul=
t nvs
> file
> > name that has been used before.
>=20
> I think more checks on the nvs file being used are needed to avoid other
> nasty issues, see the comments I just made in the earlier version of this
> patch.
>=20
Just replied on your comments for v1

Best Regards,
Eyal
