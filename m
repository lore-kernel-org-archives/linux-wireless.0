Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34346 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbFWIu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 04:50:58 -0400
Received: by wicnd19 with SMTP id nd19so99009877wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 01:50:57 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jun 2015 10:50:57 +0200
Message-ID: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com> (sfid-20150623_105103_567349_85064CF1)
Subject: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT - direct
 probe issue
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: "Peer, Ilan" <ilan.peer@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This is my setup:
t1-ath9k:
- AP (2412)
- P2P_GO - go_intent=15 (2462)

ref P2P - intel 7260
ref STA - t2-ath9k

Scenario:
1. setup AP t1-ath9k
2. connect STA (t2-ath9k) to AP
3. run ping STA->AP
4. t1-ath9k - p2p_connect <intel7260> go_intent=15
5. intel7260 - p2p_connect <t1-ath9k>
6. go_negotiation success
7. connect failed ...
8. ...

Sometimes I see such fail on intel7260:

[533519.009978] p2p-wlan3-0: authenticate with 02:03:7f:4e:a0:cd
[533519.009999] p2p-wlan3-0: Allocated STA 02:03:7f:4e:a0:cd
[533519.013667] p2p-wlan3-0: Inserted STA 02:03:7f:4e:a0:cd
[533519.014128] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 1/3)
[533519.217270] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 2/3)
[533519.421349] p2p-wlan3-0: direct probe to 02:03:7f:4e:a0:cd (try 3/3)
[533519.624329] p2p-wlan3-0: authentication with 02:03:7f:4e:a0:cd timed out
[533519.633084] p2p-wlan3-0: Removed STA 02:03:7f:4e:a0:cd
[533519.633325] p2p-wlan3-0: Destroyed STA 02:03:7f:4e:a0:cd

I suspect this is because of P2P_GO NoA?
Who should care about this direct probes tx when GO is not present?

In case we didn't send direct probes - there is no problem and TC
works correctly

BR
Janusz
