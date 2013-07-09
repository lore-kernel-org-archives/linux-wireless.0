Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54208 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3GIHWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 03:22:06 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro2so5233460pbb.27
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 00:22:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51DB4195.8090103@inov.pt>
References: <51DB0ACC.7050800@inov.pt> <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
 <51DB4195.8090103@inov.pt>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 9 Jul 2013 10:21:50 +0300
Message-ID: <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com> (sfid-20130709_092211_184585_288AC704)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 9, 2013 at 1:47 AM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:
> Hi Arik,
>
> Yep, that patch solved the kernel warning, but the association with  the AP
> is still lost after 3 warnings;
>
>
> wlcore: Beacon loss detected. roles:0xff

This one is possibly a FW version issue. I'd give it a go with the
latest FW in TI's git:
https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware

>
> To use the driver in the Luca's tree I need to do some work to adapt my
> platform to the latest kernel version, what I would like to avoid  for now.
> Is there any set of patches to put  the driver in vanilla kernel 3.9 in a
> more stable condition?

Well 3.9 is pretty new, so the difference is not that big. A simple
cherry pick of all patches done on <root>/drivers/wireless/ti/ would
do the trick.

Or you could always used compat-wireless, or in it's new name "driver
backports":
https://backports.wiki.kernel.org/index.php/Main_Page

Arik
