Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36185 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbcGSKko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:40:44 -0400
Received: by mail-qk0-f178.google.com with SMTP id x1so11503280qkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:40:43 -0700 (PDT)
Date: Tue, 19 Jul 2016 06:40:34 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
Message-ID: <20160719104034.GB11996@localhost> (sfid-20160719_124047_210734_F2850873)
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
 <20160713135021.GE7819@localhost>
 <3ad771da-f4db-e29d-7b44-7e8a0865e3da@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3ad771da-f4db-e29d-7b44-7e8a0865e3da@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 11:16:24AM +0900, Masashi Honma wrote:
> This patch does not fix starting MPSP, this patch fixes ending of MPSP.
> Without this patch, local peer continues MPSP even if we lost opposite peer
> accidentally.

OK, do we need to also clear WLAN_STA_PS_STA flag for the peer in
ieee80211_mps_sta_status_update(), or does the node completely repeer?

ISTR running into a problem where rebooted peer (previously in power-save)
would send popen but we would buffer the response due to stale PS sta
flag.

-- 
Bob Copeland %% http://bobcopeland.com/
