Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64573 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbbFXNGC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 09:06:02 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH] mwifiex: avoid freeing improper pointer in
 mwifiex_set_wowlan_mef_entry
Date: Wed, 24 Jun 2015 13:05:49 +0000
Message-ID: <8d4b003dd3a44d1081f565c1f90a543d@SC-EXCH04.marvell.com> (sfid-20150624_150607_383985_99059F4A)
References: <1435085145-9668-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1435085145-9668-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Wednesday, June 24, 2015 12:16 AM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Avinash Patil; Kalle Valo; John W. Linville
> Subject: [PATCH] mwifiex: avoid freeing improper pointer in
> mwifiex_set_wowlan_mef_entry
> 
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

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks,
Amitkumar
