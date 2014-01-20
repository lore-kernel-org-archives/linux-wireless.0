Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52091 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 16:48:21 -0500
Received: by mail-wi0-f182.google.com with SMTP id ex4so3667417wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 13:48:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <52D6B31F.8080007@lwfinger.net>
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
	<522F584E.6000806@lwfinger.net>
	<CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com>
	<CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
	<52D6B31F.8080007@lwfinger.net>
Date: Mon, 20 Jan 2014 22:48:20 +0100
Message-ID: <CAN8YU5MCBGD=tUZGgb19wE5+q7D5_x0aco227nQb=QQw2Aop5g@mail.gmail.com> (sfid-20140120_224824_918785_925902F7)
Subject: Re: RTL8187SE staging Linux driver
From: Andrea Merello <andrea.merello@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	John Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

Currently I'm struggling trying to reproduce the panic again..
Unfortunately it is working without problems now..
When it happened to you, was the RTL8187SE associated to any AP ? was
there network traffic flowing ?
Do you have done some other test ? do you have had more panics ?
Any more information about that panic is really welcome..

Jumping back to your older mail, about your note on compile warning of
rtl8187 driver, I have verified that In rtl8187 reference sources I
have, the register is really accessed as 8 bit wide, while in the
rtl8187se reference code (staging linux driver indeed) it is accessed
in 16 bit way.

I don't have a big endian system me too to test if uniforming to 16bit
brokes thing, but:
Despite I suspect the two ASIC have the same MAC and the same AFE, and
that one of the two reference code is  wrong, I can't know which one,
so I'm thinking about keeping the common register struct as it is, and
avoiding modify the rtl8187 driver about this, while eventually I will
stick to the 16 bit access on the rtl8187se using a raw cast..

Better ideas are welcome :)

Thanks
Andrea



Thank you
Andrea





On Wed, Jan 15, 2014 at 5:11 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Andrea,
>
> Just a head's up, but I had a kernel panic overnight. This kernel (3.13-rc7
> from wireless testing) has been stable - the only thing new is the
> RTL8187SE. I have no diagnostic information other than the blinking console
> lights. If/when I get more info, I'll let you know.
>
> Larry
>
