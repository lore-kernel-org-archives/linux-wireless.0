Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:54065 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0CXInS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 04:43:18 -0400
Received: by iwn6 with SMTP id 6so2457826iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 01:43:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 04:43:17 -0400
Message-ID: <33a0299c1003240143l23ecb9d4j8978ea585c50a0a2@mail.gmail.com>
Subject: ath9k: packets sent twice 1Mbps & 54Mbps
From: Anthony <lazugau@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I'm using:
Ubuntu 9.10
Atheros card with ath9k
compat-wireless latest stable version
ad-hoc 802.11g with 2 nodes (same hardware & software configuration)

I tried to inject packets using mac80211 (similar way as in packetspammer)
Radiotap header contains only Flag=0 & Rate=1Mbps (total size = 14 bytes)
However when I use wireshark to capture traffic, I discovered that
each frame was sent twice:
first time with 14 bytes radiotap header
second time with 13 bytes of radiotap header (Rate omitted), so 54Mbps here.

Is this a problem of ath9k or a default feature of 802.11 ???

Another question: if I set the FCS flag to send frame with all zeros
FCS, the receiver reported frame as bad FCS, but still deliver it to
upper layer. Why? I think the frame should be discarded ? I want to
simulate broken phy link by jamming FCS. Is there any alternative way
?

Hope some one can help.

Thank you.

Anthony
