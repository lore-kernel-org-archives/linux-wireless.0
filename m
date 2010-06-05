Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42041 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0FEHVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 03:21:14 -0400
Received: by vws5 with SMTP id 5so736549vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 00:21:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTildAN_AYlUV6l34TcWdVVelRIn9sWe5IEaLO5fS@mail.gmail.com>
References: <1275642369-5024-1-git-send-email-vnatarajan@atheros.com>
	<AANLkTildAN_AYlUV6l34TcWdVVelRIn9sWe5IEaLO5fS@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 5 Jun 2010 00:20:53 -0700
Message-ID: <AANLkTimorQtjCmyiTpimfa4qx0F-cSLaQNO0V4Dv8CH3@mail.gmail.com>
Subject: Re: [stable][PATCH] ath9k: Avoid corrupt frames being forwarded to
	mac80211.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: greg@kroah.com, stable@kernel.org, linux-wireless@vger.kernel.org,
	Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 5, 2010 at 12:20 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Jun 4, 2010 at 2:06 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
>> If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
>> with WEP or TKIP, eventhough the received frame may be a CRC failed
>> corrupted frame. If this bit is set, H/W obeys key type in keycache.
>> If it is not set and if the key type in keycache is neither open nor
>> AES, H/W forces key type to be open.  But bit 29 should be set to 1
>> for AsyncFIFO feature to encrypt/decrypt the aggregate with WEP or TKIP.
>>
>> Reported-by: Johan Hovold <johan.hovold@lundinova.se>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
>> ---
>> Applies on top of 2.6.33 and 2.6.34
>
> You need to Cc: stable@kernel.org on the commit log.

Does 2.6.32 not have this issue?

  Luis
