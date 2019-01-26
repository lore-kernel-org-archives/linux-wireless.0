Return-Path: <SRS0=mT4l=QC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04E4C282C3
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 04:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9966B21903
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 04:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfAZEOm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 23:14:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33382 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfAZEOm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 23:14:42 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.91 #2 (Red Hat Linux))
        id 1gnFMG-00020f-RD; Sat, 26 Jan 2019 04:14:16 +0000
Date:   Sat, 26 Jan 2019 04:14:16 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Shuah Khan <shuah@kernel.org>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, w.d.hubbs@gmail.com,
        chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        robh@kernel.org, jslaby@suse.com, sameo@linux.intel.com,
        davem@davemloft.net, arnd@arndb.de,
        nishka.dasgupta_ug18@ashoka.edu.in, m.maya.nakamura@gmail.com,
        santhameena13@gmail.com, zhongjiang@huawei.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tty: Fix WARNING in tty_set_termios
Message-ID: <20190126041416.GF2217@ZenIV.linux.org.uk>
References: <20190125232905.21727-1-shuah@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125232905.21727-1-shuah@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 25, 2019 at 04:29:05PM -0700, Shuah Khan wrote:
> tty_set_termios() has the following WARMN_ON which can be triggered with a
> syscall to invoke TIOCGETD __NR_ioctl.
> 
> WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
>                 tty->driver->subtype == PTY_TYPE_MASTER);
> Reference: https://syzkaller.appspot.com/bug?id=2410d22f1d8e5984217329dd0884b01d99e3e48d
> 
> A simple change would have been to print error message instead of WARN_ON.
> However, the callers assume that tty_set_termios() always returns 0 and
> don't check return value. The complete solution is fixing all the callers
> to check error and bail out to fix the WARN_ON.
> 
> This fix changes tty_set_termios() to return error and all the callers
> to check error and bail out. The reproducer is used to reproduce the
> problem and verify the fix.

> --- a/drivers/bluetooth/hci_ldisc.c
> +++ b/drivers/bluetooth/hci_ldisc.c
> @@ -321,6 +321,8 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
>  		status = tty_set_termios(tty, &ktermios);
>  		BT_DBG("Disabling hardware flow control: %s",
>  		       status ? "failed" : "success");
> +		if (status)
> +			return;

Can that ldisc end up set on pty master?  And does it make any sense there?

> diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
> index fa1672993b4c..29b51370deac 100644
> --- a/drivers/tty/serdev/serdev-ttyport.c
> +++ b/drivers/tty/serdev/serdev-ttyport.c
> @@ -136,7 +136,9 @@ static int ttyport_open(struct serdev_controller *ctrl)
>  	ktermios.c_cflag |= CRTSCTS;
>  	/* Hangups are not supported so make sure to ignore carrier detect. */
>  	ktermios.c_cflag |= CLOCAL;
> -	tty_set_termios(tty, &ktermios);
> +	ret = tty_set_termios(tty, &ktermios);

How can _that_ happen to pty master?

> diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
> index 78fe622eba65..9978c21ce34d 100644
> --- a/net/nfc/nci/uart.c
> +++ b/net/nfc/nci/uart.c
> @@ -447,6 +447,7 @@ void nci_uart_set_config(struct nci_uart *nu, int baudrate, int flow_ctrl)
>  	else
>  		new_termios.c_cflag &= ~CRTSCTS;
>  
> +	/* FIXME tty_set_termios() could return error */

Ditto for this one.

IOW, I don't believe that this patch makes any sense.  If anything,
we need to prevent unconditional tty_set_termios() on the path
that *does* lead to calling it for pty.
