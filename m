Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:22145 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYGSMTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 08:19:50 -0400
Received: by ik-out-1112.google.com with SMTP id c28so421733ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 05:19:49 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/4] rfkill: document rfkill_force_state as required
Date: Sat, 19 Jul 2008 14:34:30 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216150327-10904-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807191434.30815.IvDoorn@gmail.com> (sfid-20080719_141955_041211_A8769183)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  Every time the driver gets a notification from the card that one of its rfkill
>  lines changed state (polling might be needed on badly designed cards that don't
> @@ -422,13 +423,24 @@ of the hardware is unknown), or read-write (where the hardware can be queried
>  about its current state).
>  
>  The rfkill class will call the get_state hook of a device every time it needs
> -to know the *real* current state of the hardware.  This can happen often.
> +to know the *real* current state of the hardware.  This can happen often, but
> +it does not do any pooling, so it is not enough on hardware that is subject
> +to state changes outside of the rfkill subsystem.

pooling -> polling

With that typo fixed, you can add my:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Ivo
