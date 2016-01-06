Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:38134 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751595AbcAFRwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 12:52:50 -0500
Message-ID: <1452102761.24575.44.camel@perches.com> (sfid-20160106_185311_476755_1FA80765)
Subject: Re: [PATCH] staging: wilc1000: Removed unnecessary braces
From: Joe Perches <joe@perches.com>
To: Anjali Menon <cse.anjalimenon@gmail.com>,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 06 Jan 2016 09:52:41 -0800
In-Reply-To: <1452086991-6997-1-git-send-email-cse.anjalimenon@gmail.com>
References: <1452086991-6997-1-git-send-email-cse.anjalimenon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-06 at 18:59 +0530, Anjali Menon wrote:
> Removed unnecessary braces for single statement blocks to
> fix the warning detected by checkpatch.pl
> 
> WARNING: braces {} are not necessary for single statement blocks
> 
> Signed-off-by: Anjali Menon <cse.anjalimenon@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
> index a34a81c..afb5d2c 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
> +++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
> @@ -251,9 +251,8 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
>  
>  	if ((b != NULL) && (size != 0)) {
>  		memcpy(&buf[4], b, size);
> -		for (i = 0; i < size; i++) {
> +		for (i = 0; i < size; i++)
>  			checksum += buf[i + 4];
> -		}
>  	}
>  
>  	buf[size + 4] = checksum;

Please think of what the code is doing instead
of just shutting up checkpatch.

Maybe instead of walking the buffer twice, once
for the memcpy, another for the checksum, perhaps
using a routine to do both at the same time would
be better.

Maybe something like:

	if (b && size) {
		u32 count = size;
		u8 *to = &buf[4];

		while (count--)
			checksum += (*to++ = *b++);
	}

