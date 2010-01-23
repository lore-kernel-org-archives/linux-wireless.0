Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f186.google.com ([209.85.223.186]:51980 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0AWKvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 05:51:12 -0500
Received: by iwn16 with SMTP id 16so842842iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 02:51:11 -0800 (PST)
Date: Sat, 23 Jan 2010 04:51:11 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: ath5k phy0: unsupported jumbo
Message-ID: <20100123105111.GA24790@progeny.tock>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Every now and then, I get a few messages like the following:

[11316.285087] ath5k phy0: unsupported jumbo
[14256.975594] ath5k phy0: unsupported jumbo
[26376.342970] ath5k phy0: unsupported jumbo

drivers/net/wireless/ath/ath5k/base.c tells me this is unlikely (or at
least the slow path), and that it means that after calling the
sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs) callback, rs.rs_more was
nonzero.

What I still don’t know:

 - So, what happened?
 - Does this indicate some subtle misconfiguration?
 - Is this a hardware bug?
 - Is this a driver bug?

The network generally works great, so there is no cause for me to
worry, but still it would give me some peace of mind to know.

In turn, I would gladly write a Documentation/networking/ath5k.txt or
a comment near drivers/net/wireless/ath/ath5k/base.c:1817 for others
to refer to.

Thoughts?
Jonathan

$ uname -r
2.6.33-rc4-next-20100121-04118-gbaa1751
