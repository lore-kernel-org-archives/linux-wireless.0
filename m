Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506Ab1DMLdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 07:33:05 -0400
Received: by bwz15 with SMTP id 15so479226bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 04:33:03 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Wed, 13 Apr 2011 13:32:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com> <201104131214.53633.chunkeey@googlemail.com> <BANLkTikKvO6EvMrGtOCdYCO9_pdgUzPxyQ@mail.gmail.com>
In-Reply-To: <BANLkTikKvO6EvMrGtOCdYCO9_pdgUzPxyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104131332.47029.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 April 2011 12:51:58 Damian Lesiuk wrote:
> It doesn't solved my problem. Still max dl speed 16 mbps.
ok, so it could be something else... maybe it's a driver bug, maybe
something is outdated [avoid hostapd older than 0.7,3], or maybe
just a simple configuration problem [on either side]?

you can't tell that by just looking at the low throughput figure.
Instead you probably have to capture the handshake between the
AP+client and look who's lying about their 11n capabilities.

Luckily, all mac80211-based driver come with a nifty feature which
allows you to monitor any incoming/outgoing data. Just setup a
monitor interface.
<http://wireless.kernel.org/en/users/Documentation/iw#Adding_interfaces_with_iw>

and start a sniffer. tcpdump/whireshark is more than enough.

> btw, Can I use ath9k_htc with my Atheros 9170 in N master mode.
no, ar9170 is too old. ath9k_htc is exclusive driver for the
ar9271,ar701x+ar928x devices, which appeared in late 2009.

> What about performance?
it's ok.

Regards,
	Chr
