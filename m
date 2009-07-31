Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:37291 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZGaSkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:40:33 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1206197qwh.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:40:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A73394D.1070200@gmx.de>
References: <4A72113F.8000604@gmx.de>
	 <b6c5339f0907301505yde9e457k4ddc87b1c9120a84@mail.gmail.com>
	 <4A73394D.1070200@gmx.de>
Date: Fri, 31 Jul 2009 14:40:33 -0400
Message-ID: <b6c5339f0907311140o7e92a74eqf3ad095ac8412281@mail.gmail.com>
Subject: Re: ath5k: monitor mode needs channel change
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:34 PM, Joerg Albert<jal2@gmx.de> wrote:

>> It reloads the filters at ifup time.
>
> No, unfortunately this patch was already part of my ath5k.
> I'll try to add some printk.

Ah, I was just basing that on your compat-wireless version, but
yeah w-t should have had it.

Hmm, well, probably a ath5k_reset() in add_interface would do the
trick.  Maybe there's some wrong assumption about when
configure_filter() is called.

-- 
Bob Copeland %% www.bobcopeland.com
