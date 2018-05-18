Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:51430 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbeERKuz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:50:55 -0400
Subject: Re: [PATCH 00/10] Some more patches for wcn36xx
To: linux-wireless@vger.kernel.org
Cc: loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, kvalo@codeaurora.org
References: <20180516140820.1636-1-daniel@zonque.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org> (sfid-20180518_125058_961942_E1984503)
Date: Fri, 18 May 2018 12:50:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, May 16, 2018 04:08 PM, Daniel Mack wrote:
> Hence I believe that some sort of firmware internal buffer is overrun if
> too many SMD requests fly in in a short amount of time. The firmware
> does, however, still ack all packets just fine on the SMD channels, and
> also the DXE communication flows are all healthy. No errors are reported
> anywhere, but nothing is being put on the ether anymore.

And FTR, there is a commit in the prima repository that caught my 
attention a while back:

   https://source.codeaurora.org/external/wlan/prima/commit/?id=93cd8f3c

What this does (through an remarkable number of indirection layers) is 
sending the DUMP_COMMAND_REQ command with args = (274, 0, 0, 0, 0) when 
management frames get stuck, which smells pretty much like the issue I'm 
seeing. Doing the same with the mainline driver and the debugfs 
interface it exposes doesn't have any effect though.

But even if it did work, I wouldn't see a way to detect the situation in 
which this is needed reliably.


Daniel
