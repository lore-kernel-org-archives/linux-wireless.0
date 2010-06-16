Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55537 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab0FPOix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 10:38:53 -0400
Received: by gye5 with SMTP id 5so3985333gye.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 07:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C18DA3D.1030303@googlemail.com>
References: <4C18DA3D.1030303@googlemail.com>
Date: Wed, 16 Jun 2010 10:38:52 -0400
Message-ID: <AANLkTimtZBRfkAOnz2vPXp71Z03DfPQniY2qFHCsgI44@mail.gmail.com>
Subject: Re: "ressource temporarily unavailable" on 2.4 GHz, not on 5GHz
From: Bob Copeland <me@bobcopeland.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 10:05 AM, Dennis Borgmann
<dennis.borgmann@googlemail.com> wrote:
> Hello wireless-list!
> Hello hostapd-list!
>
> I am using ath5k with hostapd-0.6.9 on a debian running kernel 2.6.34
> and I am observing a "ressource temporarily unavailable" - error code 11
[...]
> What could be the problem? Is this due to backoff-times in 2.4 GHz, that
> don't occur on 5 GHz? Or could this be a bug?

Does dmesg report any error (e.g. no available txbuf)?

My guess is you have more frequent successful delivery in 5 GHz than in
ISM band so you aren't running out of send buffers somewhere in the stack.

Of course, your program should expect and handle EAGAIN if you are
using MSG_DONTWAIT.

-- 
Bob Copeland %% www.bobcopeland.com
