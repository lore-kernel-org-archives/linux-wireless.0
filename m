Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36644 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbIEQaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2015 12:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAE_Gge2iu1m_h4CZNjHJRd7HeGzejnBQQEs+xtH0niHHx9x8zg@mail.gmail.com>
References: <20150819025942.GD4588@kroah.com> <cover.1439953865.git.raphael.beamonte@gmail.com>
 <98b8f344a4c610b9273a0c753a1ec470dee10153.1439953865.git.raphael.beamonte@gmail.com>
 <20150903011926.GA30914@kroah.com> <CAE_Gge2iu1m_h4CZNjHJRd7HeGzejnBQQEs+xtH0niHHx9x8zg@mail.gmail.com>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Sat, 5 Sep 2015 12:29:52 -0400
Message-ID: <CAE_Gge0+iqTBqD0oLewnrWDbKQxZ8O+0uSrx6WK22XfeOZ7w4A@mail.gmail.com> (sfid-20150905_183018_133051_8C5FE6F9)
Subject: Re: [PATCHv4 1/2] staging: wilc1000: remove FREE_WILC_BUFFER()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh well. Actually you did it. I answered while pulling the git...
Sorry for that unuseful mail! :)

2015-09-05 12:25 GMT-04:00 Raphaël Beamonte <raphael.beamonte@gmail.com>:
> 2015-09-02 21:19 GMT-04:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>> Turns out this file is never even built, you should just remove it :)
>
> You're right, although it seems that is one of the "To-dos" of that
> module, as the references I find about the config variable to allow
> the compiling of that file is the following:
>
> config WILC1000_PREALLOCATE_DURING_SYSTEM_BOOT
>           bool "Preallocate memory pool during system boot"
>           ---help---
>                     To do.
>
> Found on https://github.com/linux4sc/wireless-driver/blob/master/wilc1000/Kconfig
> However, it seems that entry of the Kconfig has been removed in the
> kernel. It thus can probably be safe to remove all occurences linked
> to that option from the driver in the kernel, while the authors will
> be able to add them back when it will be a working configuration
> option. I'll do that!
