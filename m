Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36710 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBYBAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:00:52 -0500
Received: by mail-io0-f173.google.com with SMTP id l127so72294076iof.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:00:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-3-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-3-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:00:31 +1100
Message-ID: <CAGRGNgVTC7KvXi==oZo-yRF5sJDjVwvWRwEb4hCx9hHbY5LkOw@mail.gmail.com> (sfid-20160225_020054_966258_02E2C9EC)
Subject: Re: [PATCH 2/7] mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 52 +++++++++++++----------------
>  1 file changed, 23 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 43d7a92..276382e 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -76,6 +76,18 @@ static u8 mwifiex_rsn_oui[CIPHER_SUITE_MAX][4] = {
>         { 0x00, 0x0f, 0xac, 0x04 },     /* AES  */
>  };
>
> +static bool
> +has_ieee_hdr(struct ieee_types_generic *ie, u8 key)
> +{
> +       return (ie && (ie->ieee_hdr.element_id == key));

Please remove all the parentheses in this line as they're all unnecessary.

> +}
> +
> +static bool
> +has_vendor_hdr(struct ieee_types_vendor_specific *ie, u8 key)
> +{
> +       return (ie && (ie->vend_hdr.element_id == key));

Here too.

> +}
> +
>  /*
>   * This function parses a given IE for a given OUI.
>   *

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
