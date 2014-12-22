Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49532 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVTsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 14:48:45 -0500
Date: Mon, 22 Dec 2014 13:48:43 -0600
From: Eric Biggers <ebiggers3@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH for 3.19] rtlwifi: Fix error when accessing unmapped
 memory in skb
Message-ID: <20141222194843.GA7575@zzz> (sfid-20141222_204853_458483_B35F9899)
References: <1419269826-12552-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419269826-12552-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this really the same behavior as 3.17?  In 3.17, allocating the new skb is
one of the first things the interrupt handler does, and if that fails it drops
the packet and keeps using the old skb.  In this proposal, it's only after the
packet has been received and the old skb has been freed that a new one is
allocated.  And if that fails --- well, what are you expecting to happen
exactly?
