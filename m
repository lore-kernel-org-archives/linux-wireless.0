Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34970 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbcAAXNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 18:13:11 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so75501023lfe.2
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jan 2016 15:13:10 -0800 (PST)
Subject: Re: [PATCH 2/3] net-iwlegacy: One check less in il_eeprom_init()
 after error detection
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686E13F.2010309@users.sourceforge.net>
 <5686E21E.4090901@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56870803.7010807@cogentembedded.com> (sfid-20160102_001332_811827_E725F1E4)
Date: Sat, 2 Jan 2016 02:13:07 +0300
MIME-Version: 1.0
In-Reply-To: <5686E21E.4090901@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 1/1/2016 11:31 PM, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 21:12:29 +0100
>
> This issue was detected by using the Coccinelle software.
>
> Adjust a jump target to avoid a check repetition before the function
> call "il_eeprom_free".

    One question: why?

>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/net/wireless/intel/iwlegacy/common.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
> index c3afaf7..ae45fd3 100644
> --- a/drivers/net/wireless/intel/iwlegacy/common.c
> +++ b/drivers/net/wireless/intel/iwlegacy/common.c
[...]
> @@ -772,9 +772,11 @@ il_eeprom_init(struct il_priv *il)
>   done:
>   	il->ops->eeprom_release_semaphore(il);
>
> -err:
> -	if (ret)
> +	if (ret) {
> +free_eeprom:

    This is ugly, I'd say.

[...]

MBR, Sergei

