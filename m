Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:63825 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0CEAis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 19:38:48 -0500
Received: by iwn5 with SMTP id 5so2278303iwn.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 16:38:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9024DE.308@jacobs-university.de>
References: <4B9024DE.308@jacobs-university.de>
Date: Thu, 4 Mar 2010 16:38:47 -0800
Message-ID: <c1545bb51003041638v28e5fe9me336735fc940e1ea@mail.gmail.com>
Subject: Re: Mesh support for gumstix's wireless (Marvell 88W8385 wireless
	chip with CF interface)
From: Andrey Yurovsky <yurovsky@gmail.com>
To: Darko Makreshanski <d.makreshanski@jacobs-university.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 1:23 PM, Darko Makreshanski
<d.makreshanski@jacobs-university.de> wrote:
> 1. will mesh networking work with the 88W8385 chip on gumstix with the
> libertas driver?

No.  The OLPC uses an 88w8288 with in-firmware mesh on the USB
variant.  That firmware won't run on other chips.

> 3. if not, is it possible to make the libertas_tf driver work with this
> chip?

No.  That driver only supports the 88w8388 USB variant with special
firmware.  Your chip is a full-MAC device and therefore cannot use the
mac80211 mesh stack (and there isn't a special firmware to make it do
something else).

  -Andrey
