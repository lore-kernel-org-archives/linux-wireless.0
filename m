Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36008 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0EXVbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 17:31:53 -0400
Received: by fxm5 with SMTP id 5so2659067fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 14:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFAECC0.2000007@dlasys.net>
References: <4BFAECC0.2000007@dlasys.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 24 May 2010 23:31:32 +0200
Message-ID: <AANLkTilakBPI6tTkaKq_wJIxvuI1L6Rttnz-3lR3Q2de@mail.gmail.com>
Subject: Re: CARL9170 features
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 24, 2010 at 11:16 PM, David H. Lynch Jr. <dhlii@dlasys.net> wrote:
>    I am trying to kick carl9170 1.0.9 into either add-hoc or monitor mode or
> anything else where I can xmit to any wireless device. I do not care if the
> receiving device is interested - so long as the radio ACK's the packet,
> which it should do automatically.
>
>    I tried iwconfig wl_ath mode ad-hoc
>    And I get and errror:
>
> root# iwconfig wl_ath mode ad-hoc
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wl_ath ; Device or resource busy.
>
> root# iwconfig wl_ath mode monitor
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wl_ath ; Device or resource busy.
>
> root# iwconfig wl_ath mode master
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wl_ath ; Invalid argument.
>
> I can add something to the driver if needed if you coul recomend another
> wireless driver for a reference.
>
>

In mac80211, you can only change interface modes if the interface is
down. However, the best practice is usually to create a new interface
using iw:
iw dev wl_ath interface add mon_ath type monitor
(not sure if this syntax still works; it worked a while ago).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
