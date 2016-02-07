Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35110 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcBGEVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 23:21:46 -0500
Received: by mail-io0-f171.google.com with SMTP id d63so166594597ioj.2
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2016 20:21:46 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 6 Feb 2016 23:21:45 -0500
Message-ID: <CALGY4fuC7CHHFtp3VYtEZe_UFb_frHWK+_C+LWQVrC+0fzn4Kg@mail.gmail.com> (sfid-20160207_052151_347889_33C93C93)
Subject: Monitor interface TX performance boost
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I'm seeing strange behavior on my intel 6300 card.

  If I measure TX performance just after boot (iperf in tcp mode), I get this:

[  3]  0.0-10.1 sec  11.2 MBytes  9.32 Mbits/sec

  But if create and enable monitor interface (with command like 'sudo
iw phy phy0 interface add moni0 type monitor && sudo ifconfig moni0
up') I get this:

[  3]  0.0-10.1 sec  34.8 MBytes  29.0 Mbits/sec

That's about three times boost in throughput by just creating an
interface (without even using it).
Doing 'ifconfig moni0 down' bring performance back to 10Mbits range.

Experiments are done with laptop being ~5m from router and not moving.
These results are repeatable, i.e. not caused by random things like
other stations transmitting, or channel being busy.

Is this something expected? Is there any reason performance can be as
good without monitor interface existing?

Thanks!

-- 
Martynov Nikolay.
Email: mar.kolya@gmail.com
