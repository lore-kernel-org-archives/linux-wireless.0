Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:36080 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYC1Tft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 15:35:49 -0400
Received: by fg-out-1718.google.com with SMTP id l27so408854fgb.17
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 12:35:48 -0700 (PDT)
To: TK <tobutaz+kernel@gmail.com>
Subject: Re: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Fri, 28 Mar 2008 20:34:55 +0100
Cc: linux-wireless@vger.kernel.org
References: <fsjfq1$vl8$1@ger.gmane.org>
In-Reply-To: <fsjfq1$vl8$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803282034.56042.IvDoorn@gmail.com> (sfid-20080328_193642_287091_062D805E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I get this panic with rt2x00 2.0.10 (2.6.24-12-server kernel
> shipped by ubuntu). It can crash quite regularly given the
> right amount of wireless activity and system load.
> 
> The instruction that crashes seems to be the assignment to
> skb->dev when skb is null (in ieee80211_tx_status_irqsafe);
> skb can be set to null in the caller, rt2x00lib_txdone.
> 
> I'm not really sure what is the right fix, but I can try a patch.

I am not sure what is causing this problem either, the skb pointer
which rt2x00 sends to mac80211 is  being used by rt2x00 itself
just prior before sending it to mac80211.

Which means there could be a race condition somewhere,
although that would still be odd since that means txdone is running
for the same entry simultenously.

Could you try rt2x00 2.0.14 (2.6.25-rc*) or a wireless-testing kernel
to see if the problems persist?
The wireless-testing would be the most interesting since several
race conditions in the queues where fixed in there.

Ivo
