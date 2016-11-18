Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35759 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbcKRVnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:43:07 -0500
Received: by mail-oi0-f41.google.com with SMTP id b126so65626130oia.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 13:43:07 -0800 (PST)
MIME-Version: 1.0
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Fri, 18 Nov 2016 22:43:06 +0100
Message-ID: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com> (sfid-20161118_224311_107524_E54EED71)
Subject: ath10k stuck in mesh mode
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>,
        me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I experimented a strange behavior during some data rate tests between
two wireless interfaces in mesh mode. The data rate stuck on 120Mbps
(iperf UDP test) and MCS7 that is the higher MCS of 80211n without
using MIMO, even when the channel is completely free.

My configuration:
two boards Gateworks Ventana 5410 running Ubuntu 14.04 kernel 3.14,
each board has two miniPCIe WiFi adapter Compex WLE600V5-27, 2
antennas each, ath10k drivers 802.11ac capabilities.
Backports-4.4.2
Firmware firmware-5.bin_10.2.4.70.58

I set up a mesh configuring, on each board, one interface as mesh
point, and I run an iperf UDP test, but even using channels free of
any other communication (48 and 149 in particular) the max data rate
achieved was 120Mbps on MCS7, and it stucked on that value and MIMO
was not in use despite the two antennas.
By sniffing the packets I discovered that only 802.11n was in use, and
I didn't notice nothing clearly strange in the syslog.
I tried on other channels but no MIMO nor 80MHz bandwidth (as expected
from the capabilities) was never  used (at most 40MHz with SGI). I
tried to have line of sight and play with the antennas position and
distance, but the data rate stuck on that value.
Note: I didn't the "@80" in any regulatoru domain by iw reg get (but
only @40), as it's using the reg. domain from ath9k (used on a
previous 802.11n miniPCIe adapter).
Note: I also tried to set up an AP and STA, and in that case MIMO was used.

So the question is: who decide if use MIMO and higher MCS hopefully on
80MHz channel or not? Is the firmware? Is there a way to force the
interface to use 80MHz and/or MIMO? (iw provide the possibility to
choose between [HT20/HT40-/HT40+]).

Any advice is the welcome, this project is part of my master thesis
and are weeks that I'm struggling with this problem.

Thank you

Matteo
