Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:53963 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZA2Rwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 12:52:32 -0500
Received: by ewy14 with SMTP id 14so71249ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 09:52:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
Date: Thu, 29 Jan 2009 17:52:30 +0000
Message-ID: <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com> (sfid-20090129_185237_313508_F802D261)
Subject: Re: rtl8187 wireless issues
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 29, 2009 at 12:46 PM, P.G. Richardson
<p.g.richardson@phantomjinx.co.uk> wrote:
> id: 0x8189 chipset: rtl8187b

That's an older rtl8187b - there is no point trying mainline kernels,
as the interesting development are happening
in wireless-testing and takes a few months to get to mainline. i.e.
trying 2.6.29 won't help. Can you download the current compat-wireless
tar ball (http://linuxwireless.org/en/users/Download) and give it a
try?

Also can you show your "dmesg | grep rtl" result ?

The "can't ping" , etc behavior with multiple network interfaces is
normal and quite simple to work around - you need to read up on
"default route" and the "route" command.

Are you using NetworkManager or configuring by hand? If you are not
using NetworkManager, you need to set up dhcp manually. On 2nd
thought, I am suprised you have problem with ping, because if you are
using NetworkManager it should switch the default route, etc if you
choose to switch to the wired interface.

(You have come to the right place - Larry and Herton and I are the
current maintainers of the rtl8187 driver).
