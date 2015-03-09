Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46095 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbCIJJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 05:09:37 -0400
Received: by obcva2 with SMTP id va2so13575655obc.13
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 02:09:37 -0700 (PDT)
MIME-Version: 1.0
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 9 Mar 2015 05:09:17 -0400
Message-ID: <CAHqTa-0U9vP_wMFxDjRu+CSmdTRe2B+Npi3FMEZmzAAQAXAf8g@mail.gmail.com> (sfid-20150309_100941_303116_519CCE24)
Subject: Capturing hardware-decrypted packets in monitor mode on ath9k/ath10k
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On a station or AP device, I'd like to capture packets in monitor mode
(ie. with radiotap headers).  Normally this captures the encrypted
packets as they appear on the air.  In my case, I'd like to capture
the *decrypted* packets where possible (ie. packets communicating with
this node, where the local machine already knows the session key and
is presumably decrypting the packets anyway so that it can carry on
the session).

I know wireshark (etc) can decrypt packets for a given session if you
capture the EAPOL frames.  The advantages of having the driver do it
in hardware are a) hopefully less performance impact, and b) you can
easily start capturing at any time, even post EAPOL, because the
driver already has a cached copy of the keys.

Is there a flag somewhere I can set to make this happen?  Is this even
a feature supported by most hardware?

Thanks,

Avery
