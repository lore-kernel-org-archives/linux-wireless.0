Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57369 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbZHWTio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 15:38:44 -0400
Received: by ewy3 with SMTP id 3so1861747ewy.18
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2009 12:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890908221459j70e31c20ufa5ea03973a16e0a@mail.gmail.com>
References: <200908220038.35564.herton@mandriva.com.br>
	 <3ace41890908221459j70e31c20ufa5ea03973a16e0a@mail.gmail.com>
Date: Sun, 23 Aug 2009 20:38:43 +0100
Message-ID: <3ace41890908231238h32b85839qe74bce2852103402@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 22, 2009 at 10:59 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Sat, Aug 22, 2009 at 4:38 AM, Herton Ronaldo
> Krzesinski<herton@mandriva.com.br> wrote:
>> This change implements rfkill support for RTL8187B and RTL8187L devices,
>> using new cfg80211 rfkill API.
>>
>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>
> Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>
> Neat!
>
> I ran a ping to the router while flicking the switch on and off, and
> have 'ping: sendmsg: Network is unreachable' in the middle. dmesg also
> shows

It appears that I wrote prematurely - flicking the switch with the
patch seems to just do the equivalent of ifconfig down.
(before the patch, the switch has no effect). However, NetworkManager
soon notices the interface going down and ifup it again. So I have
simply got a 30s to 1 minute disruption in connectivity.

Is this intentional? I thought it is supposed to actually switch off
the hardware, or is this how the code supposed to work?
Maybe some component needs to let NM knows not to reenanble the device.

Hin-Tak
