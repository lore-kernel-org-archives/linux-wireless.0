Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36203 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbKQRmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 12:42:05 -0500
Received: by ykdr82 with SMTP id r82so18535196ykd.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 09:42:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgUdSrwxw7j885ghFu5ivHfWgDCUC7RODbV8iW_AcmfE5Q@mail.gmail.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
	<1447738373-15804-2-git-send-email-steve.derosier@lairdtech.com>
	<CAGRGNgUdSrwxw7j885ghFu5ivHfWgDCUC7RODbV8iW_AcmfE5Q@mail.gmail.com>
Date: Tue, 17 Nov 2015 09:42:04 -0800
Message-ID: <CALupW3C9GrvB24TZ9LVA46TH1oADtV5jgWXPjJDaHu_mp4iR4w@mail.gmail.com> (sfid-20151117_184238_872813_3BEB7A24)
Subject: Re: [PATCH 1/2] ath6kl_sdio: Add reset gpio module parameter for
 CHIP_PWD_L pin
From: Steve deRosier <derosier@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for looking at this.

In short - I agree with your review and will do most of them. As a
well as a few minor changes suggested by the kbuild test robot. Expect
a new version shortly.

On Mon, Nov 16, 2015 at 10:25 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>
>>  static void __exit ath6kl_sdio_exit(void)
>>  {
>>         sdio_unregister_driver(&ath6kl_sdio_driver);
>> +
>> +#ifdef CONFIG_GPIOLIB
>> +       /* Delay to avoid pulling the plug on the chip when an irq is pending
>> +        * and then getting a spurious message:
>> +        * "ath6kl: failed to get pending recv messages: -125"
>> +        */
>> +       msleep(300);
>
> Is there some actual synchronisation you can do here against the IRQ?
> 300msec isn't a long time to wait, but it seems wrong here.
>

Considering this is only called on exit, I wasn't too worried about
this, but then again, on reboot as well as a few types of
reconfiguring the interface speed is an important consideration for
our system.

I'm open to suggestions.  I had looked at this and didn't see an
obvious way to try to sync with the IRQ as it goes through several
subsystems.

But looking at it again in a different light...

125 is ECANCELED.  Which is exactly right and appropriate, and
ath6kl_htc_rxmsg_pending_handler() where the message comes from does a
proper cleanup, or so it looks like. I wonder if maybe we can consider
ECANCELED not an error that needs an error message as it might be a
reasonable case?

So instead of synchronization, just consider that particular status an
expected and properly handled exception condition and not print an
error?

Thoughts?

- Steve
