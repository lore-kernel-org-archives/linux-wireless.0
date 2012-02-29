Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59621 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2B2LDc (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 29 Feb 2012 06:03:32 -0500
Received: by bkcik5 with SMTP id ik5so2143351bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 03:03:21 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 19:03:21 +0800
Message-ID: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com> (sfid-20120229_120336_920233_A898FB6F)
Subject: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Matt Chen <machen@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

I am working on verifying the ath9k_rfkill_poll_state() function. It
would execute the ath_is_rfkill_set() the read the GPIO and change the
LED. I found the POLL_INTERVAL would take 5 secs according the
definition in net/rfkill/core.c
#define POLL_INTERVAL (5 * HZ)
So it would detect the GPIO status in every 5 seconds. But the ath9k I
run in different platform, with the same modules, it works different
way. The LED for one is working very fast, in another one is working
so slow.

I would like to clarify it is driver or BIOS issues. The way I come
out is manually to change the GPIO status, see how the driver work.
But so far I only found the devmen2 to access the specific address of
GPIO. Any other good ways recommended ?
And another question is the address defined in reg.h correct to access
? Such as
#define AR_GPIO_IN    (AR_SERV_9340(ah)) ? 0x402c : 0x404c)
can I access the value of 0x404c directly?

Thank you for your patience. :)
