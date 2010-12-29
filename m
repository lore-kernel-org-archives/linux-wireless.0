Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38927 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0L2VW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 16:22:26 -0500
Received: by iyi12 with SMTP id 12so9210225iyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 13:22:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101230000737.74d30852@lair>
References: <20101230000737.74d30852@lair>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Dec 2010 23:22:05 +0200
Message-ID: <AANLkTim55FJ_cBE1M7HmhVagfphntZZBLSs9NjTmK_F+@mail.gmail.com>
Subject: Re: wl1271: how to use without runtime pm
To: Sergey Matyukevich <geomatsi@gmail.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 29, 2010 at 11:07 PM, Sergey Matyukevich <geomatsi@gmail.com> wrote:
> So the question is: what is the proper use of wl1271 driver in the case
> when  wl1271 card is powered all the time ?

The wl1271 driver assumes it can control the power of the card.

If your card's power is always on, you will not be able to toggle the
interface down and up (as you have experienced).

It might be possible to change the driver around this "limitation",
but I'm not sure anyone has ever really tried.
