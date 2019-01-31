Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83166C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF2320863
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfAaPSg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:18:36 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:37725 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfAaPSg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 10:18:36 -0500
Received: from marcel-macpro.fritz.box (p4FF9FD60.dip0.t-ipconnect.de [79.249.253.96])
        by mail.holtmann.org (Postfix) with ESMTPSA id A490ECEE02;
        Thu, 31 Jan 2019 16:26:22 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH] tty: Fix WARNING in tty_set_termios
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190130103227.GR3691@localhost>
Date:   Thu, 31 Jan 2019 16:18:33 +0100
Cc:     shuah <shuah@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        chris@the-brannons.com, devel@driverdev.osuosl.org,
        Rob Herring <robh@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.com>, santhameena13@gmail.com,
        kirk@reisers.ca, Johan Hedberg <johan.hedberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, samuel.thibault@ens-lyon.org,
        m.maya.nakamura@gmail.com, zhongjiang@huawei.com,
        Greg KH <gregkh@linuxfoundation.org>,
        speakup@linux-speakup.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        nishka.dasgupta_ug18@ashoka.edu.in,
        "David S. Miller" <davem@davemloft.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <D0EE5C33-2930-4286-998C-822DD7898B76@holtmann.org>
References: <20190125232905.21727-1-shuah@kernel.org>
 <20190126041416.GF2217@ZenIV.linux.org.uk>
 <fe4018a7-19e4-cdd1-3095-bbe88a82788e@kernel.org>
 <20190130103227.GR3691@localhost>
To:     Johan Hovold <johan@kernel.org>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johan,

>>> On Fri, Jan 25, 2019 at 04:29:05PM -0700, Shuah Khan wrote:
>>>> tty_set_termios() has the following WARMN_ON which can be triggered with a
>>>> syscall to invoke TIOCGETD __NR_ioctl.
> 
> You meant TIOCSETD here, and in fact its the call which sets the uart
> protocol that triggers the warning.
> 
>>>> WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
>>>>                 tty->driver->subtype == PTY_TYPE_MASTER);
>>>> Reference: https://syzkaller.appspot.com/bug?id=2410d22f1d8e5984217329dd0884b01d99e3e48d
>>>> 
>>>> A simple change would have been to print error message instead of WARN_ON.
>>>> However, the callers assume that tty_set_termios() always returns 0 and
>>>> don't check return value. The complete solution is fixing all the callers
>>>> to check error and bail out to fix the WARN_ON.
>>>> 
>>>> This fix changes tty_set_termios() to return error and all the callers
>>>> to check error and bail out. The reproducer is used to reproduce the
>>>> problem and verify the fix.
>>> 
>>>> --- a/drivers/bluetooth/hci_ldisc.c
>>>> +++ b/drivers/bluetooth/hci_ldisc.c
>>>> @@ -321,6 +321,8 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
>>>>  		status = tty_set_termios(tty, &ktermios);
>>>>  		BT_DBG("Disabling hardware flow control: %s",
>>>>  		       status ? "failed" : "success");
>>>> +		if (status)
>>>> +			return;
>>> 
>>> Can that ldisc end up set on pty master?  And does it make any sense there?
>> 
>> The initial objective of the patch is to prevent the WARN_ON by making
>> the change to return error instead of WARN_ON. However, without changes
>> to places that don't check the return and keep making progress, there
>> will be secondary problems.
>> 
>> Without this change to return here, instead of WARN_ON, it will fail
>> with the following NULL pointer dereference at the next thing 
>> hci_uart_set_flow_control() attempts.
>> 
>> status = tty->driver->ops->tiocmget(tty);
>> 
>> kernel: [10140.649783] BUG: unable to handle kernel NULL pointer 
> 
> That's a separate issue, which is being fixed:
> 
> 	https://lkml.kernel.org/r/20190130095938.GP3691@localhost
> 
>>> IOW, I don't believe that this patch makes any sense.  If anything,
>>> we need to prevent unconditional tty_set_termios() on the path
>>> that *does* lead to calling it for pty.
>> 
>> I don't think preventing unconditional tty_set_termios() is enough to
>> prevent secondary problems such as the one above.
>> 
>> For example, the following call chain leads to the WARN_ON that was
>> reported. Even if void hci_uart_set_baudrate() prevents the very first
>> tty_set_termios() call, its caller hci_uart_setup() continues with
>> more tty setup. It goes ahead to call driver setup callback. The
>> driver callback goes on to do more setup calling tty_set_termios().
>> 
>> WARN_ON call path:
>>  hci_uart_set_baudrate+0x1cc/0x250 drivers/bluetooth/hci_ldisc.c:378
>>  hci_uart_setup+0xa2/0x490 drivers/bluetooth/hci_ldisc.c:401
>>  hci_dev_do_open+0x6b1/0x1920 net/bluetooth/hci_core.c:1423
>> 
>> Once this WARN_ON is changed to return error, the following
>> happens, when hci_uart_setup() does driver setup callback.
>> 
>> kernel: [10140.649836]  mrvl_setup+0x17/0x80 [hci_uart]
>> kernel: [10140.649840]  hci_uart_setup+0x56/0x160 [hci_uart]
>> kernel: [10140.649850]  hci_dev_do_open+0xe6/0x630 [bluetooth]
>> kernel: [10140.649860]  hci_power_on+0x52/0x220 [bluetooth]
>> 
>> I think continuing to catch the invalid condition in tty_set_termios()
>> and preventing progress by checking return value is a straight forward
>> change to avoid secondary problems, and it might be difficult to catch
>> all the cases where it could fail.
> 
> I agree with Al that this change doesn't make much sense. The WARN_ON
> is there to catch any bugs leading to the termios being changed for a
> master side pty. Those should bugs should be fixed, and not worked
> around in order to silence a WARN_ON.
> 
> The problem started with 7721383f4199 ("Bluetooth: hci_uart: Support
> operational speed during setup") which introduced a new way for how
> tty_set_termios() could end up being called for a master pty.
> 
> As Al hinted at, setting these ldiscs for a master pty really makes no
> sense and perhaps that is what we should prevent unless simply making
> sure they do not call tty_set_termios() is sufficient for the time
> being.
> 
> Finally, note that serdev never operates on a pty, and that this is only
> an issue for (the three) line disciplines.

I think for PTYs we should just fail setting the HCI line discipline. Fail early and just move on with life.

Regards

Marcel

