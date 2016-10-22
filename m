Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57006 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751816AbcJVUbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 16:31:44 -0400
Message-ID: <1477168300.4123.8.camel@sipsolutions.net> (sfid-20161022_223147_083849_68A9A863)
Subject: Re: crypto: aesni - add ccm(aes) algorithm implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>,
        Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Date: Sat, 22 Oct 2016 22:31:40 +0200
In-Reply-To: <4298972.T1UOBYP9Tx@debian64> (sfid-20161022_211600_609367_51AA87DC)
References: <1476895046-16549-1-git-send-email-greearb@candelatech.com>
         <3e0552f3-b7f5-2ff3-1f63-9001bceb96f0@candelatech.com>
         <4298972.T1UOBYP9Tx@debian64> (sfid-20161022_211600_609367_51AA87DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-22 at 21:15 +0200, Christian Lamparter wrote:
> 
> It would be a great if mac80211 would do to the encryption and
> decryption asynchronously. As this would work for other ciphers
> and also allows crypto offload to dedicated crypto hardware.

The only problem with that is that we'd essentially need a software
queue for *all* frames, and release them from there in RX order after
decrypt. That's surely doable, but so far nobody has thought it
important enough since mostly HW crypto is used ...

johannes
