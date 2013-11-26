Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:34464 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab3KZOuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:50:18 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: Re: [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
Date: Tue, 26 Nov 2013 15:50:14 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com> <1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311261550.14953.sw@simonwunderlich.de> (sfid-20131126_155025_198829_F5D2981C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When nominal bandwidth falls completely or partly
> within the band 5600MHz to 5650MHz the CAC time shall
> be 10 minutes.
> This is ETSI requirement. FCC forbids weather channels usage.

Although it is correct to handle that with longer times and all, I don't think 
we should enable weather channels at all, not even for ETSI. Unlike "normal" 
channels, it requires 99.99% detection rate in CAC, which is (I think) 
practically impossible.

I guess we need ath9k (or other drivers, maybe ath10k too) to disallow CAC on 
these channels, if we know that the drivers can do it? Although I don't think 
it's technically possible ...

Cheers,
    Simon
