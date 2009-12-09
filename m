Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56844 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZLIKHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 05:07:42 -0500
Received: by fxm5 with SMTP id 5so7267421fxm.28
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 02:07:48 -0800 (PST)
Message-ID: <4B1F76F2.4090004@gmail.com>
Date: Wed, 09 Dec 2009 11:07:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: useless ath9k commit logs
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith and Vasanthakumar,

could I ask you to ever explain why your ath9k patches are needed? Your
commit logs often describe the change, but not why you are doing that
(e.g. what exact issue it fixes). This is hard for us to decide whether
it should be backported to distro kernels or not.

For example
    ath9k: Fix bug in ANI channel handling

    When processing MIB interrupts, OFDM and CCK error
    handling routines for low RSSI values have to be invoked
    only when the channel mode is 11G/11B. Since HT channels
    will also fall under the bands 2Ghz/5Ghz, check appropriately.
or
    ath9k: Maintain monotonicity of PER while going across different phy

    Monotonicity of packet error rate should be kept when moving
    from one phy to another (legacy to ht, ht single stream to dual,
    etc). Current code skips updating per for other phys.

I don't know from that, what bug, under what circumstanses these fix. If
any -- e.g. a theoretical issue.

thanks,
-- 
js
