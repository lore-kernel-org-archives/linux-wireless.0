Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50316 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZLEWQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 17:16:20 -0500
Received: by fxm5 with SMTP id 5so3668783fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 14:16:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910912051355s2f13400eo1eff46c4cd6d32f4@mail.gmail.com>
References: <4b1ac00a.nP75mlCdUd2PKZib%Larry.Finger@lwfinger.net>
	 <69e28c910912051355s2f13400eo1eff46c4cd6d32f4@mail.gmail.com>
Date: Sat, 5 Dec 2009 22:16:25 +0000
Message-ID: <3ace41890912051416p59420651q6a67a7af1924a28d@mail.gmail.com>
Subject: Re: [RFC/RFT V2] rtl8187: Modify rfkill for new models
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, antti@kaijanmaki.net,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/5 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sat, Dec 5, 2009 at 9:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

>> +       printk(KERN_INFO "rtl8187: rfkill mask set to %d for Product ID 0x%x",
>> +              priv->rfkill_mask, product_id);
>
> printk(KERN_DEBUG... ?

While the info itself is a bit technical and only of use to
developers, it is a device sub-type and we currently do try to
distinguish them and tell as such... we do

phy0: hwaddr ______________, RTL8187BvE V0 + rtl8225z2
rtl8187: Customer ID is 0x04

It may be appropriate to add to either. e.g.

phy0: hwaddr ______________, RTL8187BvE V0 + rtl8225z2 (rfkill mask %d)
rtl8187: Customer ID is 0x04 (rfkill mask %d)

The product id isn't much use though, since it is readily available via lsusb.
