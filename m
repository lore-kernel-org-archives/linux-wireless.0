Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbGUNoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:44:39 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: avoid freeing improper pointer
 inmwifiex_set_wowlan_mef_entry
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435085145-9668-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20150721134439.30BC614106A@smtp.codeaurora.org> (sfid-20150721_154443_906304_BC4ABE17)
Date: Tue, 21 Jul 2015 13:44:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> mwifiex_set_wowlan_mef_entry attempts to free a passed-in pointer in
> case of an error.  The only caller (mwifiex_set_mef_filter) passes that
> pointer as an offset into allocated memory, so any attempt to free that
> will not be the actual allocated pointer.
> 
> Address this by changing mwifiex_set_wowlan_mef_entry to not do any
> free, and to cause mwifiex_set_mef_filter to do the appropriate free if
> the call to mwifiex_set_wowlan_mef_entry fails.
> 
> Coverity CID #1295879
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
