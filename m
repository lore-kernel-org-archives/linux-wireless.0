Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DB2C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC9821850
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbfB1Jo3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:44:29 -0500
Received: from smtp3.goneo.de ([85.220.129.37]:49060 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbfB1Jo2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:44:28 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2019 04:44:27 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id C3D4D23F3F9;
        Thu, 28 Feb 2019 10:38:26 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rGhKgMlismTz; Thu, 28 Feb 2019 10:38:26 +0100 (CET)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 9654F23F3E7;
        Thu, 28 Feb 2019 10:38:25 +0100 (CET)
Date:   Thu, 28 Feb 2019 11:48:01 +0100
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PING] [PATCH v5 1/7] nfc: pn533: i2c: "pn532" as dt compatible
 string
Message-ID: <20190228104801.GA14788@lem-wkst-02.lemonage>
References: <20190111161812.26325-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111161812.26325-1-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A gentle ping on this whole patch series.

Regards,
Lars

On Fri, Jan 11, 2019 at 05:18:04PM +0100, Lars Poeschel wrote:
> It is favourable to have one unified compatible string for devices that
> have multiple interfaces. So this adds simply "pn532" as the devicetree
> binding compatible string and makes a note that the old ones are
> deprecated.
> 
> Cc: Johan Hovold <johan@kernel.org>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v3:
> - This patch is new in v3
> 
>  drivers/nfc/pn533/i2c.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> index 4389eb4c8d0b..f4eae9dd5305 100644
> --- a/drivers/nfc/pn533/i2c.c
> +++ b/drivers/nfc/pn533/i2c.c
> @@ -258,6 +258,11 @@ static int pn533_i2c_remove(struct i2c_client *client)
>  }
>  
>  static const struct of_device_id of_pn533_i2c_match[] = {
> +	{ .compatible = "nxp,pn532", },
> +	/*
> +	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
> +	 * deprecated and will be removed.
> +	 */
>  	{ .compatible = "nxp,pn533-i2c", },
>  	{ .compatible = "nxp,pn532-i2c", },
>  	{},
> -- 
> 2.20.1
> 
