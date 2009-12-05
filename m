Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50869 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbZLEX24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 18:28:56 -0500
Received: by fxm5 with SMTP id 5so3698789fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 15:29:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b1ac00a.nP75mlCdUd2PKZib%Larry.Finger@lwfinger.net>
References: <4b1ac00a.nP75mlCdUd2PKZib%Larry.Finger@lwfinger.net>
Date: Sat, 5 Dec 2009 23:29:01 +0000
Message-ID: <3ace41890912051529k395e9408md9dedaea7842938f@mail.gmail.com>
Subject: Re: [RFC/RFT V2] rtl8187: Modify rfkill for new models
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: antti@kaijanmaki.net, Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 5, 2009 at 8:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> There are different bits used to convey the setting of the rfkill
> switch to the driver. The current driver only supports one of these
> possibilities. These changes were derived from the latest version
> of the vendor driver.
>
> This patch fixes the regression noted in Bug #14xxx.

http://bugzilla.kernel.org/show_bug.cgi?id=14743

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-and-tested-by: Antti Kaijanmäki <antti@kaijanmaki.net>
> Tested-by: Hin-Tak Leung <hintak.leung@gmail.com>
> Cc: Stable <stable@vger.org>

Tested okay here. About that printfk and Gábor's suggestion...
I see the 'phy0: hwaddr ______________, RTL8187BvE V0 + rtl8225z2'
line is actually only about 20 lines below in the same routine, so it
is probably appropriate to combine the two, e.g.

phy0: hwaddr ______________, RTL8187BvE V0 + rtl8225z2, rfkill mask 2
