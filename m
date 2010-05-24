Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56691 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab0EXVkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 17:40:14 -0400
Received: by fxm5 with SMTP id 5so2666035fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 14:40:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: CARL9170 features
Date: Mon, 24 May 2010 23:40:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BFAECC0.2000007@dlasys.net>
In-Reply-To: <4BFAECC0.2000007@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005242340.06728.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 May 2010 23:16:48 David H. Lynch Jr. wrote:
>      I am trying to kick carl9170 1.0.9 into either add-hoc or monitor 
> mode or anything else where I can xmit to any wireless device. I do not 
> care if the receiving device is interested - so long as the radio ACK's 
> the packet, which it should do automatically.

iwconfig and all other wext-based wireless-tools are obsolete.

The new CLI "iw" can be found on:
http://wireless.kernel.org/en/users/Documentation/iw

>      I tried iwconfig wl_ath mode ad-hoc
>      And I get and errror:
> 
> root# iwconfig wl_ath mode ad-hoc
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wl_ath ; Device or resource busy.

This is expected. The wl_ath interface must be *down* before
you can chance the operation mode of the master interface.

try: (of course, after calling: ifconfig wl_ath down)
iw dev wlanX ibss join <SSID> freq/channel <MHz/Chan No.> 
> root# iwconfig wl_ath mode monitor
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wl_ath ; Device or resource busy.
iw dev wlanX set monitor [otherbss control ...]
 
> root# iwconfig wl_ath mode master
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wl_ath ; Invalid argument.
Master/Accesspoint mode is no longer fully implemented into the
kernel and therefore needs a userspace daemon: hostapd.

http://wireless.kernel.org/en/users/Documentation/hostapd
> I can add something to the driver if needed if you could recommend
> another wireless driver for a reference.

Well, we could add a beacon scheduler. This way we might be able
to support more than just one AP/IBSS interface. But this is
really complicated as the whole CAB implementation needs to be
extended to support multiple (concurrent) AP/IBSS links.
(And of course, there's the problem of the shared TSF in such a
 configuration, so this might not be feasible after all...)

Regards,
	Chr
