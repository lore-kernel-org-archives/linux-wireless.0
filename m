Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:37057 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3EFKCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 06:02:07 -0400
Received: by mail-yh0-f52.google.com with SMTP id z6so662836yhz.39
        for <linux-wireless@vger.kernel.org>; Mon, 06 May 2013 03:02:06 -0700 (PDT)
Received: from ?IPv6:2602:306:c4aa:3410:c900:82e5:f3bf:2166? ([2602:306:c4aa:3410:c900:82e5:f3bf:2166])
        by mx.google.com with ESMTPSA id f71sm46478665yha.8.2013.05.06.03.02.04
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 06 May 2013 03:02:05 -0700 (PDT)
Message-ID: <51877F9C.1000300@berkeley.edu> (sfid-20130506_120213_191861_E2175881)
Date: Mon, 06 May 2013 03:02:04 -0700
From: Andrew Wygle <awygle@berkeley.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Disabling MAC layer ACKs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to disable MAC layer ACKs for some testing I'm doing. I can't 
seem to pin down the best way to do this, though.

 From some mailing list posts it seems I should be able to set the NoAck 
flag on any frames I send from a fairly high level of the networking 
stack. I can't seem to figure out where I'd do this, or what interface I 
should be using to do so - sockets don't know anything about MAC layers, 
and that's as low as I know how to go in userspace.

Coming at it from the other side, I found mac80211_tx_control_flags has 
a field called IEEE80211_TX_CTL_NO_ACK, which one could presumably set 
to achieve this effect. However my (admittedly limited) understanding is 
that mac80211 is at the driver level, or at least not in userspace, so I 
don't know where/when this would get set.

I was hoping that iw's noack_map command would work for me, although I 
didn't really understand what a TID meant in this context, but when I 
try to run it I get "command failed: Operation not supported (-95)". I 
suppose it's possible my hardware just doesn't support 802.11e, but as 
far as I can tell it does. Is that the only reason one should expect to 
see that error? Is it possibly related to the fact that I had to compile 
iw 3.3 myself on Ubuntu 12.04, which ships with 3.2 which doesn't have 
noack_map, and I didn't upgrade any libraries or anything when I did so?

Finally, I noted from a mailing list post from 2011 that this can be 
done for Atheros chips (which this is) by adding REG_SET_BIT(ah, 
AR_DIAG_SW, AR_DIAG_ACK_DIS) into the ath5k/9k code. I suppose I could 
do this, but I'd be glad to avoid a custom driver if at all possible.

Can anyone point me in the right direction?

Thanks,

~Andrew Wygle
