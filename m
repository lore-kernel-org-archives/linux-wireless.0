Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CE1C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC751218A3
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548844363;
	bh=C4DU94GWt4qEhbe+dI81RNYkCk5pHp9kQdM+Hm7pDQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FELh4wAmrAEcVqHol4bufZmFSxVfEHihI4mL5Bos28J2WFumUKRwfckS88/9V3EOX
	 wXm369RGSChTmdkn4MOBSfSviiNpeiaReFYYhPSBSWHmmnDerZgVVTCfuaKwcBSPMW
	 kfHZ5fcNrHVCpQGR08toS2rIRy6hZM7mTdjVlZXc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbfA3Kcg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:32:36 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45483 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730703AbfA3Kcg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 05:32:36 -0500
Received: by mail-lj1-f195.google.com with SMTP id s5-v6so20203114ljd.12;
        Wed, 30 Jan 2019 02:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ft9BkvLH1Y/FBfGV+97dpueZ4pwzh0GlQFpeeqI/6cs=;
        b=tEfZikx/f2ZG4Ro7T5jfbVh8BNlZbq8MZjyMWwg2FqZFWgJZoff/dwRaEOpoQWk7cC
         HcnL4iCcnrPDmNsPr7+s6Lb8mLATx7YM4CVajli0gPmh/88k0n9mLsnvTsD6fFfd7KG+
         KZq2FIwVrTN9ke2RqjAncDKhCnmyKZ+AKfVaCiMdu1lPO0eEmZJuDcp8fYu6tcTSic9N
         wFWSz4ePMqts5iXOnMb+rgGg/d4zGgXgJOjH95TfA4EYLI5Gdi1pkC/Rdev7GNU77JC3
         WUN6C2XMpIUIsptKlovCRF/A5L3yXtN7AsQiTSnMpcLm617E271aDjaRu8NfzYE9vxUb
         EGnw==
X-Gm-Message-State: AJcUukdCe+mAYqMd05vdgSL+9yScY3Pbrh0oDk4Tp17wUMLmi5QRLa6f
        BB5fK2I1jNbkYV5fhZIH14w=
X-Google-Smtp-Source: ALg8bN7wNvDaTi8sjUHn4unj76Gvm/ZOfle9NRPXrm315adA+A4WewjMXI6JvmBlEpaSh/6KzAbVmQ==
X-Received: by 2002:a2e:8554:: with SMTP id u20-v6mr23528683ljj.193.1548844352727;
        Wed, 30 Jan 2019 02:32:32 -0800 (PST)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id 4-v6sm200271ljw.84.2019.01.30.02.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 02:32:31 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gonAR-0001O3-Ry; Wed, 30 Jan 2019 11:32:27 +0100
Date:   Wed, 30 Jan 2019 11:32:27 +0100
From:   Johan Hovold <johan@kernel.org>
To:     shuah <shuah@kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-wireless@vger.kernel.org,
        chris@the-brannons.com, devel@driverdev.osuosl.org,
        robh@kernel.org, sameo@linux.intel.com,
        linux-serial@vger.kernel.org, jslaby@suse.com,
        santhameena13@gmail.com, kirk@reisers.ca, johan.hedberg@gmail.com,
        arnd@arndb.de, marcel@holtmann.org, samuel.thibault@ens-lyon.org,
        m.maya.nakamura@gmail.com, zhongjiang@huawei.com,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, nishka.dasgupta_ug18@ashoka.edu.in,
        davem@davemloft.net
Subject: Re: [PATCH] tty: Fix WARNING in tty_set_termios
Message-ID: <20190130103227.GR3691@localhost>
References: <20190125232905.21727-1-shuah@kernel.org>
 <20190126041416.GF2217@ZenIV.linux.org.uk>
 <fe4018a7-19e4-cdd1-3095-bbe88a82788e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4018a7-19e4-cdd1-3095-bbe88a82788e@kernel.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 02:29:22PM -0700, shuah wrote:
> On 1/25/19 9:14 PM, Al Viro wrote:
> > On Fri, Jan 25, 2019 at 04:29:05PM -0700, Shuah Khan wrote:
> >> tty_set_termios() has the following WARMN_ON which can be triggered with a
> >> syscall to invoke TIOCGETD __NR_ioctl.

You meant TIOCSETD here, and in fact its the call which sets the uart
protocol that triggers the warning.

> >> WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
> >>                  tty->driver->subtype == PTY_TYPE_MASTER);
> >> Reference: https://syzkaller.appspot.com/bug?id=2410d22f1d8e5984217329dd0884b01d99e3e48d
> >>
> >> A simple change would have been to print error message instead of WARN_ON.
> >> However, the callers assume that tty_set_termios() always returns 0 and
> >> don't check return value. The complete solution is fixing all the callers
> >> to check error and bail out to fix the WARN_ON.
> >>
> >> This fix changes tty_set_termios() to return error and all the callers
> >> to check error and bail out. The reproducer is used to reproduce the
> >> problem and verify the fix.
> > 
> >> --- a/drivers/bluetooth/hci_ldisc.c
> >> +++ b/drivers/bluetooth/hci_ldisc.c
> >> @@ -321,6 +321,8 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
> >>   		status = tty_set_termios(tty, &ktermios);
> >>   		BT_DBG("Disabling hardware flow control: %s",
> >>   		       status ? "failed" : "success");
> >> +		if (status)
> >> +			return;
> > 
> > Can that ldisc end up set on pty master?  And does it make any sense there?
> 
> The initial objective of the patch is to prevent the WARN_ON by making
> the change to return error instead of WARN_ON. However, without changes
> to places that don't check the return and keep making progress, there
> will be secondary problems.
> 
> Without this change to return here, instead of WARN_ON, it will fail
> with the following NULL pointer dereference at the next thing 
> hci_uart_set_flow_control() attempts.
> 
> status = tty->driver->ops->tiocmget(tty);
> 
> kernel: [10140.649783] BUG: unable to handle kernel NULL pointer 

That's a separate issue, which is being fixed:

	https://lkml.kernel.org/r/20190130095938.GP3691@localhost

> > IOW, I don't believe that this patch makes any sense.  If anything,
> > we need to prevent unconditional tty_set_termios() on the path
> > that *does* lead to calling it for pty.
> 
> I don't think preventing unconditional tty_set_termios() is enough to
> prevent secondary problems such as the one above.
> 
> For example, the following call chain leads to the WARN_ON that was
> reported. Even if void hci_uart_set_baudrate() prevents the very first
> tty_set_termios() call, its caller hci_uart_setup() continues with
> more tty setup. It goes ahead to call driver setup callback. The
> driver callback goes on to do more setup calling tty_set_termios().
> 
> WARN_ON call path:
>   hci_uart_set_baudrate+0x1cc/0x250 drivers/bluetooth/hci_ldisc.c:378
>   hci_uart_setup+0xa2/0x490 drivers/bluetooth/hci_ldisc.c:401
>   hci_dev_do_open+0x6b1/0x1920 net/bluetooth/hci_core.c:1423
> 
> Once this WARN_ON is changed to return error, the following
> happens, when hci_uart_setup() does driver setup callback.
> 
> kernel: [10140.649836]  mrvl_setup+0x17/0x80 [hci_uart]
> kernel: [10140.649840]  hci_uart_setup+0x56/0x160 [hci_uart]
> kernel: [10140.649850]  hci_dev_do_open+0xe6/0x630 [bluetooth]
> kernel: [10140.649860]  hci_power_on+0x52/0x220 [bluetooth]
> 
> I think continuing to catch the invalid condition in tty_set_termios()
> and preventing progress by checking return value is a straight forward
> change to avoid secondary problems, and it might be difficult to catch
> all the cases where it could fail.

I agree with Al that this change doesn't make much sense. The WARN_ON
is there to catch any bugs leading to the termios being changed for a
master side pty. Those should bugs should be fixed, and not worked
around in order to silence a WARN_ON.

The problem started with 7721383f4199 ("Bluetooth: hci_uart: Support
operational speed during setup") which introduced a new way for how
tty_set_termios() could end up being called for a master pty.

As Al hinted at, setting these ldiscs for a master pty really makes no
sense and perhaps that is what we should prevent unless simply making
sure they do not call tty_set_termios() is sufficient for the time
being.

Finally, note that serdev never operates on a pty, and that this is only
an issue for (the three) line disciplines.

Johan
