Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51093 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZKKAkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 19:40:52 -0500
Received: by iwn8 with SMTP id 8so537979iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 16:40:58 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 16:40:38 -0800
Message-ID: <43e72e890911101640r69ad67c6l2e48250596c19d44@mail.gmail.com>
Subject: ath9k rate control - busted
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org, Aeolus Yang <Aeolus.Yang@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the oops I just described in the previous e-mail I disabled the
"Wireless-N only" feature and set the AP to "Wireless-BG only" feature
on the AP. I then observed some terrible throughput on iperf using UDP
(TX'ing out). Here is the last "watch cat rcstat" output, the box then
just hung with no panic or trace (even through netconsole):

Every 2.0s: cat rcstat
                              Tue Nov 10 16:31:56 2009

 Rate         Success  Retries  XRetries PER

  1.0:      712     4930     1491      100
  2.0:      103      453      159       87
  5.5:      111      202       55       28
 11.0:        8       30       11       43
  6.0:        0        0        0        0
  9.0:        0        0        0        0
 12.0:        5       19        7       87
 18.0:        1       14        6       75
 24.0:        1        6        1       30
 36.0:        0        0        0        0
 48.0:        0        0        0        0
 54.0:        0        0        0        0

Its unclear if something other than the rate control algorithm used is
what could be busted, I cannot see from the logs.

One way or another I think we should prioritize making ath9k work with
minstrel optionally on legacy networks at least for now, and see if we
can help Felix test/advance minstrel support for MCS rate support.

The ath9k rate control code proves unmaintainable, not clearly
understood even with things like this:

/* Update PER, RSSI and whatever else that the code thinks it is doing.
   If you can make sense of all this, you really need to go out more. */

We can't possibly successfully maintain a driver with code like this.

  Luis
