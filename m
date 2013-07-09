Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53323 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3GITKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 15:10:55 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so5895829pab.10
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 12:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51DC0E7C.9080306@inov.pt>
References: <51DB0ACC.7050800@inov.pt> <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
 <51DB4195.8090103@inov.pt> <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
 <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>
 <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>
 <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com> <51DC0E7C.9080306@inov.pt>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 9 Jul 2013 22:10:39 +0300
Message-ID: <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com> (sfid-20130709_211058_628735_41C529E9)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 9, 2013 at 4:22 PM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:
> http://pastebin.com/XmEzqjHs
>
> The dmesg output with debug mask set to 0x63c20:
>
> http://pastebin.com/zGE0Gfp8
>
> Note that with debug activated I did not see the driver's "Beacon loss
> detected" messages.

You have this line in the log:
[   72.435000] wlan0: deauthenticated from 88:43:e1:57:79:c0 (Reason: 23)

This means:
Association request rejected because the information in the Power
Capability element is
unacceptable

In other words the AP is disconnecting you since your Tx power is
inadequate (probably too high?). I'd try to limit it using iw, or just
set a different regdomain where its limited.
Also I'd try with a different AP.

Arik
