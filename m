Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:60065 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0CBFwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 00:52:09 -0500
Received: by iwn34 with SMTP id 34so3158282iwn.15
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 21:52:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ffa0ad881003011917i6943b91cm3e3682c8ca0b8d3e@mail.gmail.com>
References: <ffa0ad881003011917i6943b91cm3e3682c8ca0b8d3e@mail.gmail.com>
Date: Mon, 1 Mar 2010 21:29:22 -0800
Message-ID: <c1545bb51003012129n79b872a1k3892c3be9d9639de@mail.gmail.com>
Subject: Re: About libertas spi driver
From: Andrey Yurovsky <yurovsky@gmail.com>
To: Soohyung Cho <celius202@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Soohyung,

On Mon, Mar 1, 2010 at 7:17 PM, Soohyung Cho <celius202@gmail.com> wrote:
> Hello.
>
> We developed a s3c2442-based custom board and
> it has WM-G-MR-09 wireless lan chip connected with spi interface.
>
> I added spi_register_board_info to our mach-xxx.c like cm-x270.c
> and I included libertas spi modules.
>
> When the board starts, if_spi_init_module function is called but
> if_spi_probe function is never called.
>
> Do I miss something?
> Any help will be appreciated.

Did you follow the instructions at the bottom of this page?
http://wireless.kernel.org/en/users/Drivers/libertas

Namely you need to define platform resources for your Libertas GSPI
device in your board file.  The driver then needs to be registered
with the platform_device bus.

  -Andrey
