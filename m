Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:57569 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbdILWT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 18:19:57 -0400
Date: Wed, 13 Sep 2017 08:09:16 +1000
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: rtl8821ae keep alive not set, connection lost
Message-ID: <20170912220916.GB32211@us.netrek.org> (sfid-20170913_002001_084723_13FE9F6F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Summary: 40b368af4b75 ("rtlwifi: Fix alignment issues") breaks
rtl8821ae keep alive, causing "Connection to AP lost" and deauth, but
why?

Wireless connection is lost after a few seconds or minutes, on every
OLPC NL3 laptop with rtl8821ae, with any stable kernel after 4.10.1,
and any kernel with 40b368af4b75.

dmesg contains

  wlp2s0: Connection to AP 2c:b0:5d:a6:86:eb lost

iw event shows

  wlp2s0: del station 2c:b0:5d:a6:86:eb
  wlp2s0 (phy #0): deauth 74:c6:3b:09:b5:0d -> 2c:b0:5d:a6:86:eb reason 4: Disassociated due to inactivity
  wlp2s0 (phy #0): disconnected (local request)

Workaround is to bounce the link, then reconnect;

  ip link set wlp2s0 down
  ip link set wlp2s0 up
  iw dev wlp2s0 connect qz

A nearby monitor host captures a deauthentication packet sent by the
device.

Bisection showed cause is 40b368af4b75 ("rtlwifi: Fix alignment
issues") which changes the width of DBI register read.

On the face of it, 40b368af4b75 looks correct, especially compared
against same function in rtl8723be.

I've no idea why reverting fixes the problem.  I'm hoping someone here
might speculate and suggest ways to test.

As keep alive is set through this path, my guess is that keep alive is
not being set in the device.  Or perhaps reading 16-bits perturbs
another register.  Is there a way to test?

http://dev.laptop.org/~quozl/z/1drtGD.txt dmesg of 4.13

http://dev.laptop.org/~quozl/z/1drt7c.txt dmesg with 4.13 and revert
of 40b368af4b75

-- 
James Cameron
http://quozl.netrek.org/
