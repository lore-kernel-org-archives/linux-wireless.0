Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36710 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdHRMsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 08:48:05 -0400
Received: by mail-lf0-f42.google.com with SMTP id o85so42055521lff.3
        for <linux-wireless@vger.kernel.org>; Fri, 18 Aug 2017 05:48:04 -0700 (PDT)
Received: from leonard (178.43.177.250.ipv4.supernova.orange.pl. [178.43.177.250])
        by smtp.gmail.com with ESMTPSA id u128sm1130455lja.68.2017.08.18.05.48.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Aug 2017 05:48:02 -0700 (PDT)
Date: Fri, 18 Aug 2017 14:48:00 +0200
From: Dariusz Gadomski <dariusz.gadomski@canonical.com>
To: linux-wireless@vger.kernel.org
Subject: Cisco's Wi-Fi Direct Client Policy and iwlwifi (8260)
Message-ID: <20170818124800.q4r6xtflexkbetzq@leonard> (sfid-20170818_144808_666041_F9EF6E0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There is a “Wi-Fi Direct Client Policy” setting in some Cisco AP hardware [1].
I am unaware how that works exactly behind the scenes (except for some hints at
[2]), but I have noticed that with that setting set to “Deny” I am observing
issues when trying to connect from a machine with an Intel 8260 on a 4.10.0
kernel - all connection attempts lead to failure.

I have managed to obtain some captured packets from that attempt as well as
from a successful attempt (a machine with Broadcom bcm43224). What I have
noticed is that AP puts the P2P IE in the beacon frames and when 8260 sends a
probe request it also puts a P2P IE element in it. No response from the AP is
ever transmitted.

In case of the Broadcom-based device the probe request does not contain P2P IE
and it is able to correct normally. My understanding of this issue is that the
AP makes the decision to temporarily blacklist the client after receiving a P2P
IE from it.

I have made an additional test by commenting out the P2P interface types from
iwlwifi/mvn/mac80211.c - using such kernel allowed the 8260 device to connect
successfully.

I’m wondering if there’s a way of changing this behavior to enable the 8260 to
connect to a network ‘secured’ in this way?  I would also appreciate some
information about which behavior is correct (bcm43224 vs 8260) and is it
specified anywhere in the Wi-Fi P2P specs (or anywhere else ftm)?

Thanks, Dariusz

[1] https://www.cisco.com/c/en/us/td/docs/wireless/controller/7-4/configuration/guides/consolidated/b_cg74_CONSOLIDATED/b_cg74_CONSOLIDATED_chapter_010111110.html
[2] https://supportforums.cisco.com/discussion/11851216/wi-fi-direct-client-policy
