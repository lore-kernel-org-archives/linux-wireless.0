Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55034 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3FXNAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:00:07 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so24870079iee.34
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 06:00:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371915734-13966-3-git-send-email-juhosg@openwrt.org>
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
	<1371915734-13966-3-git-send-email-juhosg@openwrt.org>
Date: Mon, 24 Jun 2013 15:00:05 +0200
Message-ID: <CAGXE3d9_zOt0h6WaWUedXnJu9yucJ=Jtaa8PPacz1-6G2Wf63w@mail.gmail.com> (sfid-20130624_150011_472944_25BEBDFC)
Subject: Re: [PATCH 2/3] rt2x00: rt2800lib: turn on secondary PAs/LNAs for
 3T/3R devices
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 5:42 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The secondary PAs/LNAs are turned on only for 2T/2R
> devices, however these are used for 3T/3R devices as
> well. Always turn those on if the device uses more
> than one tx/rx chains.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 4072242..f4cd3d8 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2678,16 +2678,16 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>
>         tx_pin = 0;
>
> -       /* Turn on unused PA or LNA when not using 1T or 1R */
> -       if (rt2x00dev->default_ant.tx_chain_num == 2) {
> +       if (rt2x00dev->default_ant.tx_chain_num > 1) {
> +               /* Turn on secondary PAs for 2T adn for 3T devices*/

Typo adn -> and.

Otherwise looks good to me.
Helmut
