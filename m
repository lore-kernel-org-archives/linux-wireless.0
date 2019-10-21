Return-Path: <SRS0=EcM/=YO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66519CA9EAF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 15:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424B9214AE
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Oct 2019 15:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfJUPnH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:43:07 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:42857 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726289AbfJUPnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Oct 2019 11:43:07 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 11:43:06 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 05EDF1803E8ED;
        Mon, 21 Oct 2019 15:37:32 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 1B985182CF66C;
        Mon, 21 Oct 2019 15:37:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: dolls01_240eb4bb83a00
X-Filterd-Recvd-Size: 2849
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon, 21 Oct 2019 15:37:27 +0000 (UTC)
Message-ID: <0f91839d858fcb03435ebc85e61ee4e75371ff37.camel@perches.com>
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
From:   Joe Perches <joe@perches.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 21 Oct 2019 08:37:26 -0700
In-Reply-To: <20191021143742.14487-2-geert+renesas@glider.be>
References: <20191021143742.14487-1-geert+renesas@glider.be>
         <20191021143742.14487-2-geert+renesas@glider.be>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-10-21 at 16:37 +0200, Geert Uytterhoeven wrote:
> The existing debugfs_create_ulong() function supports objects of
> type "unsigned long", which are 32-bit or 64-bit depending on the
> platform, in decimal form.  To format objects in hexadecimal, various
> debugfs_create_x*() functions exist, but all of them take fixed-size
> types.
> 
> Add a debugfs helper for "unsigned long" objects in hexadecimal format.
> This avoids the need for users to open-code the same, or introduce
> bugs when casting the value pointer to "u32 *" or "u64 *" to call
> debugfs_create_x{32,64}().
[]
> diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
[]
> @@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
>  
>  #endif
>  
> +static inline void debugfs_create_xul(const char *name, umode_t mode,
> +				      struct dentry *parent,
> +				      unsigned long *value)
> +{
> +	if (sizeof(*value) == sizeof(u32))
> +		debugfs_create_x32(name, mode, parent, (u32 *)value);
> +	else
> +		debugfs_create_x64(name, mode, parent, (u64 *)value);

trivia: the casts are unnecessary.

This might be more sensible using #ifdef

static inline void debugfs_create_xul(const char *name, umode_t mode,
				      struct dentry *parent,
				      unsigned long *value)
{
#if BITS_PER_LONG == 64
	debugfs_create_x64(name, mode, parent, value);
#else
	debugfs_create_x32(name, mode, parent, value);
#endif
}


