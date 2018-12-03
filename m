Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538BEC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D1F20834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19D1F20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbeLCP14 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:27:56 -0500
Received: from smtp3.goneo.de ([85.220.129.37]:45572 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbeLCP14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 10:27:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 6AC3F23FF97;
        Mon,  3 Dec 2018 16:27:51 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Hbr9RBp-gTOS; Mon,  3 Dec 2018 16:27:50 +0100 (CET)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id EB12023F3CC;
        Mon,  3 Dec 2018 16:27:49 +0100 (CET)
Date:   Mon, 3 Dec 2018 15:26:22 +0100
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] nfc: pn533: add UART phy driver
Message-ID: <20181203142622.GA8057@lem-wkst-02.lemonage>
References: <20181101100216.613-1-poeschel@lemonage.de>
 <20181101100216.613-4-poeschel@lemonage.de>
 <20181114153517.GB19900@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114153517.GB19900@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 14, 2018 at 04:35:17PM +0100, Johan Hovold wrote:
> On Thu, Nov 01, 2018 at 11:02:12AM +0100, Lars Poeschel wrote:
> > This adds the UART phy interface for the pn533 driver.
> > The pn533 driver can be used through UART interface this way.
> > It is implemented as a serdev device.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> Please make sure to include reviewers on CC.

It's hard to do all things right, about how to correctly email patches,
patch sets and follow ups and send what to whom.
I am still learning. Sorry about that.

> > ---
> > Changes in v4:
> > - SPDX-License-Identifier: GPL-2.0+
> > - Source code comments above refering items
> > - Error check for serdev_device_write's
> > - Change if (xxx == NULL) to if (!xxx)
> > - Remove device name from a dev_err
> > - move pn533_register in _probe a bit towards the end of _probe
> > - make use of newly added dev_up / dev_down phy_ops
> > - control send_wakeup variable from dev_up / dev_down
> > 
> > Changes in v3:
> > - depend on SERIAL_DEV_BUS in Kconfig
> > 
> > Changes in v2:
> > - switched from tty line discipline to serdev, resulting in many
> >   simplifications
> > - SPDX License Identifier
> > 
> >  drivers/nfc/pn533/Kconfig  |  11 ++
> >  drivers/nfc/pn533/Makefile |   2 +
> >  drivers/nfc/pn533/pn533.h  |   8 +
> >  drivers/nfc/pn533/uart.c   | 311 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 332 insertions(+)
> >  create mode 100644 drivers/nfc/pn533/uart.c
> > 
> > +static void pn532_dev_up(struct pn533 *dev)
> > +{
> > +	struct pn532_uart_phy *pn532 = dev->phy;
> > +
> > +	serdev_device_open(pn532->serdev);
> > +	pn532->send_wakeup = PN532_SEND_LAST_WAKEUP;
> > +}
> > +
> > +static void pn532_dev_down(struct pn533 *dev)
> > +{
> > +	struct pn532_uart_phy *pn532 = dev->phy;
> > +
> > +	serdev_device_close(pn532->serdev);
> > +	pn532->send_wakeup = PN532_SEND_WAKEUP;
> > +}
> > +
> > +static struct pn533_phy_ops uart_phy_ops = {
> > +	.send_frame = pn532_uart_send_frame,
> > +	.send_ack = pn532_uart_send_ack,
> > +	.abort_cmd = pn532_uart_abort_cmd,
> > +	.dev_up = pn532_dev_up,
> > +	.dev_down = pn532_dev_down,
> > +};
> 
> > +static int pn532_uart_probe(struct serdev_device *serdev)
> > +{
> > +	struct pn532_uart_phy *pn532;
> > +	struct pn533 *priv;
> > +	int err;
> > +
> > +	err = -ENOMEM;
> > +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> > +	if (!pn532)
> > +		goto err_exit;
> > +
> > +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> > +	if (!pn532->recv_skb)
> > +		goto err_free;
> > +
> > +	pn532->serdev = serdev;
> > +	serdev_device_set_drvdata(serdev, pn532);
> > +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> > +	err = serdev_device_open(serdev);
> > +	if (err) {
> > +		dev_err(&serdev->dev, "Unable to open device\n");
> > +		goto err_skb;
> > +	}
> > +
> > +	err = serdev_device_set_baudrate(serdev, 115200);
> > +	if (err != 115200) {
> > +		err = -EINVAL;
> > +		goto err_serdev;
> > +	}
> > +
> > +	serdev_device_set_flow_control(serdev, false);
> > +	pn532->send_wakeup = PN532_SEND_WAKEUP;
> > +	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
> > +	priv = pn533_register_device(PN533_DEVICE_PN532,
> > +				     PN533_NO_TYPE_B_PROTOCOLS,
> > +				     PN533_PROTO_REQ_ACK_RESP,
> > +				     pn532, &uart_phy_ops, NULL,
> > +				     &pn532->serdev->dev,
> > +				     &serdev->dev);
> > +	if (IS_ERR(priv)) {
> > +		err = PTR_ERR(priv);
> > +		goto err_serdev;
> > +	}
> > +
> > +	pn532->priv = priv;
> > +	err = pn533_finalize_setup(pn532->priv);
> > +	if (err)
> > +		goto err_unregister;
> > +
> > +	serdev_device_close(serdev);
> 
> This looks broken; what if the NFC interface is brought up before this
> point? You'd get a double open, which is likely to crash things, but
> even if you survive that, the port would not be closed despite the
> interface being up.

I understand the problem and would like to solve it with a mutex. I will
not have time to work on that until next year. Please be patient. I will
send a new patchset.

> Can't you finalise your setup before registering the interface?

Well, propably I can do that. But I did it the way the other drivers
(usb and i2c) are already doing and reusing the code of the pn533 core
driver. Since their probe works very similar to mine, I suspect them to
have the same problems.
I can rewrite the probe for my driver, but not for the other two. I can
not test them.
Would you prefer that I rewrite my own _register_device and
_finalize_setup functions, not using the ones from the core driver ?

> > +	return 0;
> > +
> > +err_unregister:
> > +	pn533_unregister_device(pn532->priv);
> > +err_serdev:
> > +	serdev_device_close(serdev);
> > +err_skb:
> > +	kfree_skb(pn532->recv_skb);
> > +err_free:
> > +	kfree(pn532);
> > +err_exit:
> > +	return err;
> > +}
> > +
> > +static void pn532_uart_remove(struct serdev_device *serdev)
> > +{
> > +	struct pn532_uart_phy *pn532 = serdev_device_get_drvdata(serdev);
> > +
> > +	pn533_unregister_device(pn532->priv);
> > +	serdev_device_close(serdev);
> 
> This is also broken; the port should have been closed when the interface
> was deregistered.

Same as above.

> > +	kfree_skb(pn532->recv_skb);
> > +	kfree(pn532);
> > +}

Thank you for your very valuable feedback.

Regards,
Lars
