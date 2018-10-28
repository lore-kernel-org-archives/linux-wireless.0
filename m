Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034BBECDE47
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 10:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC8A720665
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 10:27:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjaBIRiD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC8A720665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJ1TLl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Oct 2018 15:11:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34446 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbeJ1TLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Oct 2018 15:11:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id g8-v6so2125232ljk.1;
        Sun, 28 Oct 2018 03:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mYLn8WvJnm+tIsXralmBJ8c1walAN84G9IosFwUVl5g=;
        b=TjaBIRiDE7D55ZtbPhny9lWdXo4jEnjtzPze41OS3ZCU3OLPYZLdi2dEYlezn0QyL5
         naCDiimmZni7omA/K+X9+ywGzYnAUbAHvzuG69+4t+D7WosQYuR7nrkbwCPodmx8ZFPz
         3ATO2ofwgA7SJnq2JXS2hvMxHobgvHCeYBz2QHD8nXrO2CBjwWvgQE66DCWtbcBhMDHN
         u+SMdhWiiLdeee6g1k2gnnQqX0zW7dvShLx/jmtCz/4nn54kZ7qLosoCOoPo8EuBarCV
         AbcAIvgqjdXubqqT6CApn3IAccgESWzAazwv0IMowRASk3KEz1nnMHeKvAu9GfV/DtXe
         yxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=mYLn8WvJnm+tIsXralmBJ8c1walAN84G9IosFwUVl5g=;
        b=o6l3oyWfHrDPbQxoyL7s8v/zjKxEY1qwEL/Rp2dtx2AOra6UpmkaBh9wcZGLinmQ/o
         ZH7HmDt+2Bk9/JCdjNqTbzNy3eG5VWEqsO8ChB014y/6+bcgSf8gWjFh5y7D+QvZroig
         hiD4ifhZaU2gZF0OhhhGP4vRkong996zrYfY9u0C0+LxJto4ceiU/h0JhTzwWD/zbcXY
         DkZaTRhOx9VNS3R1ClL45dGcNccnjB13ESN8RqcGDyCUGYn5qJjlijQlc0IORJkv3M3R
         cHNo4LxsKpn5G00HcVQfZ+nFPGZs4i+sKR1QA1yOcQL+dE2mVe4eEsrP6EkjKJexs5YO
         Zmyg==
X-Gm-Message-State: AGRZ1gIBplYP/HRN0YbyZtJs3cAm+jhsm072JrkgqYBJ6F2eycli2g9U
        0ETmM4fnl6ney1P10NgwU+wMnqq1
X-Google-Smtp-Source: AJdET5dlR4Nu4IVNSQjCo9bcTRI2SBY+YNo9WmiyjjYzcgG7X677QGLNw8hwtA8jZAztcyotzTtgOw==
X-Received: by 2002:a2e:84c5:: with SMTP id q5-v6mr6299056ljh.65.1540722443302;
        Sun, 28 Oct 2018 03:27:23 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id y127-v6sm2594515lfc.13.2018.10.28.03.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 03:27:22 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gGiI1-0002r4-Hz; Sun, 28 Oct 2018 11:27:26 +0100
Date:   Sun, 28 Oct 2018 11:27:25 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181028102725.GL27852@localhost>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181025132937.24405-3-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 25, 2018 at 03:29:34PM +0200, Lars Poeschel wrote:
> This adds the UART phy interface for the pn533 driver.
> The pn533 driver can be used through UART interface this way.
> It is implemented as a serdev device.

Just a few drive-by comments below.

> +// SPDX-License-Identifier: GPL-2.0

This should match MODULE_LICENSE below which currently says v2 *or
later*.

> +/*
> + * Driver for NXP PN532 NFC Chip - UART transport layer
> + *
> + * Copyright (C) 2018 Lemonage Software GmbH
> + * Author: Lars Pöschel <poeschel@lemonage.de>
> + * All rights reserved.
> + */

> +#define VERSION "0.1"

We don't version kernel drivers individually, so please drop this here
and below.

> +static int pn532_uart_send_frame(struct pn533 *dev,
> +				struct sk_buff *out)
> +{
> +	static const u8 wakeup[] = {
> +		0x55, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +	/* wakeup sequence and dummy bytes for waiting time */

Comments should go above the code they apply to.

> +	struct pn532_uart_phy *pn532 = dev->phy;
> +	int count;
> +
> +	print_hex_dump_debug("PN532_uart TX: ", DUMP_PREFIX_NONE, 16, 1,
> +			     out->data, out->len, false);
> +
> +	pn532->cur_out_buf = out;
> +	if (pn532->send_wakeup)
> +		count = serdev_device_write(pn532->serdev,
> +				wakeup, sizeof(wakeup),
> +				MAX_SCHEDULE_TIMEOUT);

No error handling?

> +
> +	count = serdev_device_write(pn532->serdev, out->data, out->len,
> +			MAX_SCHEDULE_TIMEOUT);

Same here.

> +	if (PN533_FRAME_CMD(((struct pn533_std_frame *)out->data)) ==
> +			PN533_CMD_SAM_CONFIGURATION)
> +		pn532->send_wakeup = 0;
> +
> +	mod_timer(&pn532->cmd_timeout, HZ / 40 + jiffies);
> +	return 0;
> +}
> +
> +static int pn532_uart_send_ack(struct pn533 *dev, gfp_t flags)
> +{
> +	struct pn532_uart_phy *pn532 = dev->phy;
> +	static const u8 ack[PN533_STD_FRAME_ACK_SIZE] = {
> +			0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
> +	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */

Same as above.

> +	int rc;
> +
> +	rc = serdev_device_write(pn532->serdev, ack, sizeof(ack),
> +			MAX_SCHEDULE_TIMEOUT);

Error handling.

> +
> +	return 0;
> +}

> +static int pn532_uart_probe(struct serdev_device *serdev)
> +{
> +	struct pn532_uart_phy *pn532;
> +	struct pn533 *priv;
> +	int err;
> +
> +	err = -ENOMEM;
> +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> +	if (pn532 == NULL)

I'd use !pn532 here (and elsewhere).

> +		goto err_exit;
> +
> +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> +	if (pn532->recv_skb == NULL)
> +		goto err_free;
> +
> +	pn532->serdev = serdev;
> +	priv = pn533_register_device(PN533_DEVICE_PN532,
> +				     PN533_NO_TYPE_B_PROTOCOLS,
> +				     PN533_PROTO_REQ_ACK_RESP,
> +				     pn532, &uart_phy_ops, NULL,
> +				     &pn532->serdev->dev,
> +				     &serdev->dev);
> +

Stray new line.

> +	if (IS_ERR(priv)) {
> +		err = PTR_ERR(priv);
> +		goto err_skb;
> +	}

Should you not set up your device fully before registering it? I'd
assume you could get callbacks from NFC core here.

> +
> +	pn532->priv = priv;
> +	serdev_device_set_drvdata(serdev, pn532);
> +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> +	err = serdev_device_open(serdev);
> +	if (err) {
> +		dev_err(&serdev->dev, "Unable to open device %s\n",
> +				serdev->dev.init_name);

dev_err will include the device name so you can drop the init_name bit.

> +		goto err_unregister;
> +	}

Keeping the serial device open at all times will prevent low power
states on some platforms. Wouldn't it be possible to open the device
when the nfc interface is brought up (and during setup)?

> +
> +	err = serdev_device_set_baudrate(serdev, 115200);
> +	if (err != 115200) {
> +		err = -EINVAL;
> +		goto err_serdev;
> +	}
> +
> +	serdev_device_set_flow_control(serdev, false);
> +	pn532->send_wakeup = 1;
> +	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
> +	err = pn533_finalize_setup(pn532->priv);
> +	if (err)
> +		goto err_serdev;
> +
> +	return 0;
> +
> +err_serdev:
> +	serdev_device_close(serdev);
> +err_unregister:
> +	pn533_unregister_device(pn532->priv);
> +err_skb:
> +	kfree_skb(pn532->recv_skb);
> +err_free:
> +	kfree(pn532);
> +err_exit:
> +	return err;
> +}

> +MODULE_AUTHOR("Lars Pöschel <poeschel@lemonage.de>");
> +MODULE_DESCRIPTION("PN532 UART driver ver " VERSION);
> +MODULE_VERSION(VERSION);

Drop version.

> +MODULE_LICENSE("GPL");

Doesn't match SPDX identifier above.

Johan
