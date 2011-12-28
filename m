Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49840 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1L1UKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:10:33 -0500
Received: by vcbfk14 with SMTP id fk14so9714904vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:10:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-2-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 21:10:32 +0100
Message-ID: <CAOZOX0U=huKsZ-4PPDwOA9iPkJksewGuq-J7ZszewVFq_sciYg@mail.gmail.com> (sfid-20111228_211037_372912_C01D1314)
Subject: Re: [PATCH 1/7] rt2x00: Identify rt2800usb chipsets.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> According to the latest USB ID database these are all RT2770 / RT2870 / RT307x
> devices.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   26 ++++++++++++--------------
>  1 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 3265b34..313cc7f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -914,12 +914,14 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x050d, 0x8053) },
>        { USB_DEVICE(0x050d, 0x805c) },
>        { USB_DEVICE(0x050d, 0x815c) },
> +       { USB_DEVICE(0x050d, 0x825a) },
>        { USB_DEVICE(0x050d, 0x825b) },
>        { USB_DEVICE(0x050d, 0x935a) },
>        { USB_DEVICE(0x050d, 0x935b) },
>        /* Buffalo */
>        { USB_DEVICE(0x0411, 0x00e8) },
>        { USB_DEVICE(0x0411, 0x0158) },
> +       { USB_DEVICE(0x0411, 0x015d) },
>        { USB_DEVICE(0x0411, 0x016f) },
>        { USB_DEVICE(0x0411, 0x01a2) },
>        /* Corega */
> @@ -934,6 +936,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x07d1, 0x3c0e) },
>        { USB_DEVICE(0x07d1, 0x3c0f) },
>        { USB_DEVICE(0x07d1, 0x3c11) },
> +       { USB_DEVICE(0x07d1, 0x3c13) },
> +       { USB_DEVICE(0x07d1, 0x3c15) },
>        { USB_DEVICE(0x07d1, 0x3c16) },
>        /* Draytek */
>        { USB_DEVICE(0x07fa, 0x7712) },
> @@ -943,6 +947,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x7392, 0x7711) },
>        { USB_DEVICE(0x7392, 0x7717) },
>        { USB_DEVICE(0x7392, 0x7718) },
> +       { USB_DEVICE(0x7392, 0x7722) },
>        /* Encore */
>        { USB_DEVICE(0x203d, 0x1480) },
>        { USB_DEVICE(0x203d, 0x14a9) },
> @@ -977,6 +982,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x1737, 0x0070) },
>        { USB_DEVICE(0x1737, 0x0071) },
>        { USB_DEVICE(0x1737, 0x0077) },
> +       { USB_DEVICE(0x1737, 0x0078) },
>        /* Logitec */
>        { USB_DEVICE(0x0789, 0x0162) },
>        { USB_DEVICE(0x0789, 0x0163) },
> @@ -1000,9 +1006,13 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x0db0, 0x871b) },
>        { USB_DEVICE(0x0db0, 0x871c) },
>        { USB_DEVICE(0x0db0, 0x899a) },
> +       /* Ovislink */
> +       { USB_DEVICE(0x1b75, 0x3071) },
> +       { USB_DEVICE(0x1b75, 0x3072) },
>        /* Para */
>        { USB_DEVICE(0x20b8, 0x8888) },
>        /* Pegatron */
> +       { USB_DEVICE(0x1d4d, 0x0002) },
>        { USB_DEVICE(0x1d4d, 0x000c) },
>        { USB_DEVICE(0x1d4d, 0x000e) },
>        { USB_DEVICE(0x1d4d, 0x0011) },
> @@ -1055,7 +1065,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* Sparklan */
>        { USB_DEVICE(0x15a9, 0x0006) },
>        /* Sweex */
> +       { USB_DEVICE(0x177f, 0x0153) },
>        { USB_DEVICE(0x177f, 0x0302) },
> +       { USB_DEVICE(0x177f, 0x0313) },
>        /* U-Media */
>        { USB_DEVICE(0x157e, 0x300e) },
>        { USB_DEVICE(0x157e, 0x3013) },
> @@ -1139,25 +1151,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x13d3, 0x3322) },
>        /* Belkin */
>        { USB_DEVICE(0x050d, 0x1003) },
> -       { USB_DEVICE(0x050d, 0x825a) },
>        /* Buffalo */
>        { USB_DEVICE(0x0411, 0x012e) },
>        { USB_DEVICE(0x0411, 0x0148) },
>        { USB_DEVICE(0x0411, 0x0150) },
> -       { USB_DEVICE(0x0411, 0x015d) },
>        /* Corega */
>        { USB_DEVICE(0x07aa, 0x0041) },
>        { USB_DEVICE(0x07aa, 0x0042) },
>        { USB_DEVICE(0x18c5, 0x0008) },
>        /* D-Link */
>        { USB_DEVICE(0x07d1, 0x3c0b) },
> -       { USB_DEVICE(0x07d1, 0x3c13) },
> -       { USB_DEVICE(0x07d1, 0x3c15) },
>        { USB_DEVICE(0x07d1, 0x3c17) },
>        { USB_DEVICE(0x2001, 0x3c17) },
>        /* Edimax */
>        { USB_DEVICE(0x7392, 0x4085) },
> -       { USB_DEVICE(0x7392, 0x7722) },
>        /* Encore */
>        { USB_DEVICE(0x203d, 0x14a1) },
>        /* Gemtek */
> @@ -1171,19 +1178,13 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* LevelOne */
>        { USB_DEVICE(0x1740, 0x0605) },
>        { USB_DEVICE(0x1740, 0x0615) },
> -       /* Linksys */
> -       { USB_DEVICE(0x1737, 0x0078) },
>        /* Logitec */
>        { USB_DEVICE(0x0789, 0x0168) },
>        { USB_DEVICE(0x0789, 0x0169) },
>        /* Motorola */
>        { USB_DEVICE(0x100d, 0x9032) },
> -       /* Ovislink */
> -       { USB_DEVICE(0x1b75, 0x3071) },
> -       { USB_DEVICE(0x1b75, 0x3072) },
>        /* Pegatron */
>        { USB_DEVICE(0x05a6, 0x0101) },
> -       { USB_DEVICE(0x1d4d, 0x0002) },
>        { USB_DEVICE(0x1d4d, 0x0010) },
>        /* Planex */
>        { USB_DEVICE(0x2019, 0x5201) },
> @@ -1202,9 +1203,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x083a, 0xc522) },
>        { USB_DEVICE(0x083a, 0xd522) },
>        { USB_DEVICE(0x083a, 0xf511) },
> -       /* Sweex */
> -       { USB_DEVICE(0x177f, 0x0153) },
> -       { USB_DEVICE(0x177f, 0x0313) },
>        /* Zyxel */
>        { USB_DEVICE(0x0586, 0x341a) },
>  #endif
> --
> 1.7.7.4
>
