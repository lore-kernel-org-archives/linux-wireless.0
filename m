Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:58630 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZE2SSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 14:18:45 -0400
Received: by pxi29 with SMTP id 29so1685695pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 11:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74C73DFF-F3D6-487F-A279-1F6D142846A5@zinkconsulting.com>
References: <74C73DFF-F3D6-487F-A279-1F6D142846A5@zinkconsulting.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 May 2009 11:18:27 -0700
Message-ID: <43e72e890905291118v4eaadcu786ffaf8129dc92b@mail.gmail.com>
Subject: Re: Ath9k Can't Detect 802.11n Access Points / Refuses To Use
	Channels 100-140
To: Galen P Zink <galen@zinkconsulting.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 9:11 AM, Galen P Zink <galen@zinkconsulting.com> wrote:
> Under stock Ubuntu 9.04, my AR5008 card is picked up and sees my 5 GHz
> 802.11n access points, as well as my 802.11g access points. I do not know
> the precise driver configuration (just booted live disc) but clearly this
> demonstrates the card is working fine. OS X also agrees.
>
> Under Debian with a 2.6.29-2 kernel and compat-wireless built from
> yesterday's nightly, CRDA and regulatory.bin, I cannot pick up my 802.11n
> access points on channels 149 and 157. Moreover, I am having weird problems
> with channels being disabled that should not be disabled, e.g. everything
> from 100 to 140 is disabled, even though my regulatory domain allows those
> channels. I thought this was a DFS issue, but 52-64 requires DFS and those
> channels ARE enabled, so I doubt that's the case.
>
> Can anybody clarify the situation here?!

Sure.

> [    8.808231] ath9k 0000:03:00.0: setting latency timer to 64
> [    8.937198] ath: Country alpha2 being used: 00
> [    8.937201] ath: Regpair detected: 0x64

0x64 or any regpair with 0x60 in it is a world regulatory domain in
the Atheros EEPROM, so the card is configured to world roam. You can
set the regulatory domain to "US" but the card is already programmed
to world roam therefore that regulatory domain is always respected.
Selecting "US" in this case would only help the card be more compliant
in case the used regulatory domain enables channels not allowed in the
US.

  Luis
