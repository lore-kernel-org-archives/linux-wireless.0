Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64891 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab0KLWyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 17:54:20 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so3543570bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 14:54:20 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ivo Anjo <knuckles@gmail.com>
Subject: Re: Kernel panic with carl9170
Date: Fri, 12 Nov 2010 23:54:16 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimtnRgJzWx8XUZjNqTkmNzppstcbWxuPr2Hkf41@mail.gmail.com> <AANLkTikqyg_Z5kTWQa1R9ftxEPyqoLf6u=-ptS7RPzt9@mail.gmail.com>
In-Reply-To: <AANLkTikqyg_Z5kTWQa1R9ftxEPyqoLf6u=-ptS7RPzt9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201011122354.16506.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 12 November 2010 21:41:31 Ivo Anjo wrote:
> Hello,
> 
> I'm getting a kernel panic with carl9170 when connecting to a network,
> for example with my home network (WPA2 with AES, 2.4Ghz 802.11b/g/n
> mixed mode).
> I've been running compat-wireless for a while now, and the panic has
> been there for at least a month. With latest compat-wireless
> (09November) I still get this problem.

at least a month? So you are saying that you didn't experience the bug
back in September, when the driver first appeared in compat-wireless?

Have you tried to "git bisect" the panic then.
 
> The kernel panic does not happen always, and it seems to happen more
> frequently when I try to connect to the network and my signal is not
> very good. If I sit right next to the AP, I never get any panics. The
> panic happens right when I'm connecting (network-manager is still
> displaying a spinning icon).
Unrelated but I hope you're running a recent network-manager version
and you've "locked" the AP bssid. Otherwise you might experience
serve link problems due to "expensive" background scans.

> My hardware is the TP-Link TL-WN821N v2 and I'm running kernel 2.6.36-rc8.
What carl9170 firmware are you using?

> Backtrace is in attached picture.
The backtrace is a bit clipped (I would love to see what happens
before the bug too). But what I can say is that it didn't crash
in the driver itself. Maybe the problem could be solved by a
kernel update (isn't 2.6.36-rc8 now nearly a month old?), or
at least it could produce a "better" backtrace?!

Best regards,
	Chr
