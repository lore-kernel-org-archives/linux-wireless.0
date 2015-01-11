Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:55650 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbAKM4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 07:56:22 -0500
Received: by mail-we0-f178.google.com with SMTP id p10so14914243wes.9
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 04:56:21 -0800 (PST)
Message-ID: <54B272F0.70307@googlemail.com> (sfid-20150111_135640_361505_627E92E9)
Date: Sun, 11 Jan 2015 12:56:16 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org
Subject: IWLWIFI - 3.18-stable
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Having recently bought a new laptop, I've just started using the iwlwifi driver for wireless networking. I found both
3.18.x and the current development tree to be very unreliable due to frequent disconnections from the router.

Before you merged them into your tree, I grabbed the latest fixes from iwlwifi-fixes tree and applied them to the
development kernel. Since I did that I've had no problems at all with dropped connections. I then looked at each patch
to see whether it might be applicable to 3.18 and found that two of them looked as if they should be useful. They are:

c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it

a9dc5060bf3a32ac3dad472f15416054b92dc5b5 - iwlwifi: mvm: fix out of bounds access to tid_to_mac80211_ac

With those two applied, I've had stable wireless networking on 3.18.2 and, more recently, 3.18.2. Consequently, they
seem appropriate for tagging for 3.18-stable, but, as far as I can see, they haven't been tagged for stable. Apologies,
if I'm mistaken, but if I'm not, could you consider submitting the two patches for inclusion in 3.18, please? Of course,
they may be appropriate to earlier kernels too - I haven't looked.

Thanks

Chris
