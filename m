Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53828 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaLHIaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 03:30:52 -0500
Received: by mail-pd0-f169.google.com with SMTP id z10so4751722pdj.14
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2014 00:30:52 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Dec 2014 14:00:52 +0530
Message-ID: <CAGKQeFifW2FGKUh_i0h4Nkw22biNLYz1T=bKZW2ZgrkFsp9aTQ@mail.gmail.com> (sfid-20141208_093056_560239_BCE7BB7F)
Subject: Mesh hwmp mpath service causes ping packet drop
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using mesh network. Kernel ver 3.12.2.
Scenario: When 2 wired and 1 wireless boards are forming mesh network,
packets are dropped
because of 'iw mesh0 mpath dump" changed entry.
This case no Issue:
// Own mac X:X:X:14:17:AD  -------> A     wireless
                  X:X:X:10:3f:ad    -------> B     wired
                  X:X:X:14:18:01    -------> C    wired
# iw mesh0 mpath dump
DEST ADDR         NEXT HOP          IFACE
X:X:X:10:3f:ad    X:X:X:10:3f:ad   mesh0         //All traffic travels
through this mesh peer
X:X:X:14:18:01   X:X:X:14:18:01  mesh0
 # iw mesh0 mpath dump        //Changed packet is dropped because of mpath entry
DEST ADDR         NEXT HOP        IFACE
X:X:X:10:3f:ad    X:X:X:14:18:01     mesh0
X:X:X:14:18:01   X:X:X:14:18:01     mesh0

Here the station peer C blocked station B, so drops all the packet
coming from station B.
Can someone please help me?
Anything required please feel free to mail me.
