Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39582 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC0Omf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:42:35 -0400
Received: by bwz17 with SMTP id 17so1030088bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:42:31 -0700 (PDT)
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and power management
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Mar 2009 16:42:29 +0200
In-Reply-To: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com> (Davide Pesavento's message of "Fri\, 27 Mar 2009 15\:27\:22 +0100")
Message-ID: <87ljqr58oa.fsf@litku.valot.fi> (sfid-20090327_154237_636270_85D8F223)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Davide Pesavento <davidepesa@gmail.com> writes:

> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
> (with -Dnl80211).
> Enabling power management when connected (i.e. 'iwconfig wlan0 power
> on'), causes the currently established connection to break and the
> machine is no longer able to reconnect to the AP.

Try with a timeout, for example three seconds:

iwconfig wlan0 power timeout 3

It might be that ath9k doesn't work when timeout is zero (which 'power
on' effectively does). You need a fairly new wireless-tools to set the
timeout, older versions had a bug with that.

-- 
Kalle Valo
