Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38346 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1AONeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 08:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <201101131423.51640.helmut.schaa@googlemail.com>
References: <m31v4hkmkf.fsf@ingo.homenetwork>
	<201101131423.51640.helmut.schaa@googlemail.com>
Date: Sat, 15 Jan 2011 14:34:11 +0100
Message-ID: <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ingo Brunberg <ingo_brunberg@web.de>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Just a shot in the dark but since the stack trace shows the newly added
> watchdog this might be the result of a race between a regular txdone work
> (mac80211 workqueue) vs the watchdog work (global workqueue).
>
> I guess the following situation could happen:
> A regular tx done work calls rt2x00lib_txdone which first sets entry->skb to
> NULL, calls the driver specific clear_entry and afterwards increases
> Q_INDEX_DONE. If the watchdog work calls rt2x00lib_txdone on a different CPU
> inbetween the skb might be NULL and cause the above oops.

This could be, would be interesting to know if compat-wireless also shows
this problem. Because the queue refactoring code which should have solved
these race conditions was added after 2.6.37.

Ivo
