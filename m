Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB372C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC6F2087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CC6F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbeJIUGY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 16:06:24 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:39937 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeJIUGX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 16:06:23 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2018 16:06:23 EDT
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.90_1)
        (envelope-from <daniel@makrotopia.org>)
        id 1g9r6q-0002nW-LG; Tue, 09 Oct 2018 14:27:34 +0200
Date:   Tue, 9 Oct 2018 14:27:22 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: Re: [PATCH v3 2/4] rt2x00: remove confusing AGC register
Message-ID: <20181009122720.GB2458@makrotopia.org>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1539086170-32528-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

On Tue, Oct 09, 2018 at 01:56:08PM +0200,  Gruszka wrote:
> Register 66 was causing issues on RT6352 if set to the same value as
> in MTK driver. With 1c reg value device was working fine in both HT20
> and HT40 modes.

My guess is that this may change once we add proper TSSI which involes
parts of AGC init as well. I suggest to add a comment in the code to
reflect that.


> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 1a2bf6c49b82..3a04eaef8511 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -3981,11 +3981,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>  		rt2800_bbp_write(rt2x00dev, 196, reg);
>  
>  		/* AGC init */
> -		if (rt2x00_rt(rt2x00dev, RT6352))
> -			reg = 0x04;
> -		else
> -			reg = rf->channel <= 14 ? 0x1c : 0x24;
> -
> +		reg = rf->channel <= 14 ? 0x1c : 0x24;
>  		reg += 2 * rt2x00dev->lna_gain;

We can summerize the two lines into
		reg = 0x1c + (2 * rt2x00dev->lna_gain);
which is also what is was before introducing support for MT7620.


>  		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);


Cheers


Daniel
