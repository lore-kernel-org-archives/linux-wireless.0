Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BCAC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 15:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CA322360
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 15:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i53Je44C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38CA322360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbeKOBjJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 20:39:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43797 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbeKOBjI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 20:39:08 -0500
Received: by mail-lj1-f194.google.com with SMTP id g26-v6so14455739lja.10;
        Wed, 14 Nov 2018 07:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ku9To3g5J2n/ZQ1s9CH1LfJ+HFQVU74xCCwl4l2lqm0=;
        b=i53Je44CYvY9eXzadCGmrqnHNUHRLQ1dNmgUMcKNJDLA9DmSNOf87il/PJaPI1lxD+
         Jxwk3HPtq1wR6g3+jwI4elnF1C87igibut/GNoB7YvjX+jhCpUixFYgR2dqRFBZ7+v25
         vpYPrCVKWryo8l1KwsKxIhXTFto/woiTHKo/7/aTFlzGCh+MyHKO52SA6E2+wFtTXcWB
         7ipX61IAeZWpEjbrzIqBGwpawUBaNtihxB+35+FfgBpN7xt7k4p7rjfKlhKutiZtYbVS
         ofIqNrrDY7if2qJ7C49ax2rkA66faakrE2QWypUKJWD2EUvFZautb/LCBC/l3F7zxm3M
         lvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ku9To3g5J2n/ZQ1s9CH1LfJ+HFQVU74xCCwl4l2lqm0=;
        b=h4jupwGfC4YPqF/SaNcc7dokHQyxvN21pY5yhI4Bq9GkdGwMh8GIEkBKXfqGjoFxqO
         Nw7SFNRzZwoMOX5ZVupKd+1yZ+QK/NjYbYsLX1ro6/vh5ijm/f37B5rsr00FN+OwMc+2
         b1Rr2YtoKJ8ku0ZkKbO73mMrzBdQNKj+oL0XHbTO9hTNWOfYe7YX7r1byFd8Hj8/YtcQ
         FjTOi2e4WUsS73FP3AAUMJTiWn9M2GBVZhwk215Aje1Z0Z0uigM/zQIu7tMk4gZzT7vt
         bH8WAXmEkFpFS7ucnyoPwZnYbJ9Byepjfd4bqvjw/mmAM1SJulnwC3sdoEWfHi34XqFk
         1GzA==
X-Gm-Message-State: AGRZ1gJtOpltLqFr8xVgXCcuU9PswYY+L18GQiN4MIHPgC/JYmVROqDk
        qCPE+S7qqq3GlPq5vHnXQKj7Q8ki
X-Google-Smtp-Source: AJdET5eb1zQJ93Y/VT1fyrlJMXSZXCGcG+pIkISC0W3XsDSMe/S86jZTvAjQdT5SgMe8KVMuYBFmAQ==
X-Received: by 2002:a2e:5816:: with SMTP id m22-v6mr1347943ljb.177.1542209722555;
        Wed, 14 Nov 2018 07:35:22 -0800 (PST)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id r29-v6sm3439606ljd.44.2018.11.14.07.35.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 07:35:21 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gMxCH-0005KK-Ut; Wed, 14 Nov 2018 16:35:18 +0100
Date:   Wed, 14 Nov 2018 16:35:17 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] nfc: pn533: add UART phy driver
Message-ID: <20181114153517.GB19900@localhost>
References: <20181101100216.613-1-poeschel@lemonage.de>
 <20181101100216.613-4-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101100216.613-4-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 01, 2018 at 11:02:12AM +0100, Lars Poeschel wrote:
> This adds the UART phy interface for the pn533 driver.
> The pn533 driver can be used through UART interface this way.
> It is implemented as a serdev device.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Please make sure to include reviewers on CC.

> ---
> Changes in v4:
> - SPDX-License-Identifier: GPL-2.0+
> - Source code comments above refering items
> - Error check for serdev_device_write's
> - Change if (xxx == NULL) to if (!xxx)
> - Remove device name from a dev_err
> - move pn533_register in _probe a bit towards the end of _probe
> - make use of newly added dev_up / dev_down phy_ops
> - control send_wakeup variable from dev_up / dev_down
> 
> Changes in v3:
> - depend on SERIAL_DEV_BUS in Kconfig
> 
> Changes in v2:
> - switched from tty line discipline to serdev, resulting in many
>   simplifications
> - SPDX License Identifier
> 
>  drivers/nfc/pn533/Kconfig  |  11 ++
>  drivers/nfc/pn533/Makefile |   2 +
>  drivers/nfc/pn533/pn533.h  |   8 +
>  drivers/nfc/pn533/uart.c   | 311 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 332 insertions(+)
>  create mode 100644 drivers/nfc/pn533/uart.c
> 
> +static void pn532_dev_up(struct pn533 *dev)
> +{
> +	struct pn532_uart_phy *pn532 = dev->phy;
> +
> +	serdev_device_open(pn532->serdev);
> +	pn532->send_wakeup = PN532_SEND_LAST_WAKEUP;
> +}
> +
> +static void pn532_dev_down(struct pn533 *dev)
> +{
> +	struct pn532_uart_phy *pn532 = dev->phy;
> +
> +	serdev_device_close(pn532->serdev);
> +	pn532->send_wakeup = PN532_SEND_WAKEUP;
> +}
> +
> +static struct pn533_phy_ops uart_phy_ops = {
> +	.send_frame = pn532_uart_send_frame,
> +	.send_ack = pn532_uart_send_ack,
> +	.abort_cmd = pn532_uart_abort_cmd,
> +	.dev_up = pn532_dev_up,
> +	.dev_down = pn532_dev_down,
> +};

> +static int pn532_uart_probe(struct serdev_device *serdev)
> +{
> +	struct pn532_uart_phy *pn532;
> +	struct pn533 *priv;
> +	int err;
> +
> +	err = -ENOMEM;
> +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> +	if (!pn532)
> +		goto err_exit;
> +
> +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> +	if (!pn532->recv_skb)
> +		goto err_free;
> +
> +	pn532->serdev = serdev;
> +	serdev_device_set_drvdata(serdev, pn532);
> +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> +	err = serdev_device_open(serdev);
> +	if (err) {
> +		dev_err(&serdev->dev, "Unable to open device\n");
> +		goto err_skb;
> +	}
> +
> +	err = serdev_device_set_baudrate(serdev, 115200);
> +	if (err != 115200) {
> +		err = -EINVAL;
> +		goto err_serdev;
> +	}
> +
> +	serdev_device_set_flow_control(serdev, false);
> +	pn532->send_wakeup = PN532_SEND_WAKEUP;
> +	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
> +	priv = pn533_register_device(PN533_DEVICE_PN532,
> +				     PN533_NO_TYPE_B_PROTOCOLS,
> +				     PN533_PROTO_REQ_ACK_RESP,
> +				     pn532, &uart_phy_ops, NULL,
> +				     &pn532->serdev->dev,
> +				     &serdev->dev);
> +	if (IS_ERR(priv)) {
> +		err = PTR_ERR(priv);
> +		goto err_serdev;
> +	}
> +
> +	pn532->priv = priv;
> +	err = pn533_finalize_setup(pn532->priv);
> +	if (err)
> +		goto err_unregister;
> +
> +	serdev_device_close(serdev);

This looks broken; what if the NFC interface is brought up before this
point? You'd get a double open, which is likely to crash things, but
even if you survive that, the port would not be closed despite the
interface being up.

Can't you finalise your setup before registering the interface?

> +	return 0;
> +
> +err_unregister:
> +	pn533_unregister_device(pn532->priv);
> +err_serdev:
> +	serdev_device_close(serdev);
> +err_skb:
> +	kfree_skb(pn532->recv_skb);
> +err_free:
> +	kfree(pn532);
> +err_exit:
> +	return err;
> +}
> +
> +static void pn532_uart_remove(struct serdev_device *serdev)
> +{
> +	struct pn532_uart_phy *pn532 = serdev_device_get_drvdata(serdev);
> +
> +	pn533_unregister_device(pn532->priv);
> +	serdev_device_close(serdev);

This is also broken; the port should have been closed when the interface
was deregistered.

> +	kfree_skb(pn532->recv_skb);
> +	kfree(pn532);
> +}

Johan
