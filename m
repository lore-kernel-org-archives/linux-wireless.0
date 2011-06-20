Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52391 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1FTSNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 14:13:19 -0400
Received: by qyk9 with SMTP id 9so1247262qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 11:13:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110619174739.GC19934@localhost.localdomain>
References: <20110604144854.GA4865@localhost.localdomain>
	<20110604172940.GA10984@localhost.localdomain>
	<20110619174602.GB19934@localhost.localdomain>
	<20110619174739.GC19934@localhost.localdomain>
Date: Mon, 20 Jun 2011 20:13:18 +0200
Message-ID: <BANLkTi=NAH7Gso69YFjWZD7yGuypn4z-Cg@mail.gmail.com> (sfid-20110620_201322_587749_8634F1AA)
Subject: Re: [PATCH 2/2] rt2x00: reset usb devices at probe
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Jun 19, 2011 at 7:47 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> When module is reloaded, device may fail to work, with messages:
>
> [  342.211926] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x0059, type=2.
> [  342.314254] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x004a, type=2.
> [  342.416458] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 3183 max 2432.
> [  342.518605] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x00c9, type=2.
> [  342.620836] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x00ae, type=1.
> [  342.723201] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 0 max 2432.
> [  342.825399] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 0 max 2432.
> [  342.927624] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 0 max 2432.
> [  343.029804] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 2491 max 2432.
> [  343.132008] phy40 -> rt2x00lib_rxdone: Warning - Wrong frame size 2576 max 2432.
> [  343.234326] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x004c, type=1.
> [  343.438723] phy40 -> rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0000, signal=0x00e6, type=1.
>
> Whereas replugging device make it functional. To solve that problem
> force reset device during probe.
>
> With patch messages are gone. Unfortunately device may sometimes
> still does not operate correctly after module reload (fail to receive
> data after associate), but such cases are rarer than without the patch.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 8f90f62..b6b4542 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -802,6 +802,7 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
>        int retval;
>
>        usb_dev = usb_get_dev(usb_dev);
> +       usb_reset_device(usb_dev);
>
>        hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
>        if (!hw) {
> --
> 1.7.4
>
>
