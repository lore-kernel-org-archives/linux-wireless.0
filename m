Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56171 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0L3WKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 17:10:14 -0500
Received: by ewy5 with SMTP id 5so5240547ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 14:10:12 -0800 (PST)
Date: Fri, 31 Dec 2010 01:08:47 +0300
From: Sergey Matyukevich <geomatsi@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wl1271: how to use without runtime pm
Message-ID: <20101231010847.79a55fda@lair>
In-Reply-To: <AANLkTim55FJ_cBE1M7HmhVagfphntZZBLSs9NjTmK_F+@mail.gmail.com>
References: <20101230000737.74d30852@lair>
	<AANLkTim55FJ_cBE1M7HmhVagfphntZZBLSs9NjTmK_F+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 29 Dec 2010 23:22:05 +0200
Ohad Ben-Cohen <ohad@wizery.com> wrote:

> On Wed, Dec 29, 2010 at 11:07 PM, Sergey Matyukevich
> <geomatsi@gmail.com> wrote:
> > So the question is: what is the proper use of wl1271 driver in the
> > case when  wl1271 card is powered all the time ?
> 
> The wl1271 driver assumes it can control the power of the card.
> 
> If your card's power is always on, you will not be able to toggle the
> interface down and up (as you have experienced).
> 
> It might be possible to change the driver around this "limitation",
> but I'm not sure anyone has ever really tried.

A simple solution which comes to mind would be to perform some kind of
'complete soft reset procedure' for wl1271 card in the beginning of the
function 'wl1271_op_add_interface'. But I guess such a feature is not
available for this card. Qtherwise it would be already implemented by
Luciano and his colleagues.

Thanks, 
Sergey
