Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4747 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYF0Pr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:47:26 -0400
Date: Fri, 27 Jun 2008 11:28:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Joonwoo Park <joonwpark81@gmail.com>,
	Dan Williams <dcbw@redhat.com>, JMF <tolas_feup@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Message-ID: <20080627152843.GA16003@tuxdriver.com> (sfid-20080627_174730_003674_9102A0BA)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com> <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com> <loom.20080527T105701-941@post.gmane.org> <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com> <1211896423.1746.9.camel@localhost.localdomain> <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64> <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com> <1213605989.3803.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213605989.3803.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 10:46:29AM +0200, Johannes Berg wrote:
> 
> > > [PATCH] wireless: Limit wep key size to 128/104-bits
> > >
> > > This patch prevents overflow which is occured by invalid long wep key
> > > insertion
> > >
> > > $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
> > >
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > > IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
> > > PGD 13a590067 PUD 12e471067 PMD 0
> > > Oops: 0000 [1] PREEMPT SMP
> > > CPU 1
> > > ...
> > > Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
> > > ...
> > > Call Trace:
> > >  [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:iwl4965_enqueue_hcmd+0x12b/0x220
> > >  [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_sync+0x67/0x290
> > >  [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
> > > ...
> > >
> > > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > > ---
> > >  net/wireless/wext.c |   11 ++++++++++-
> 
> I'm sure Jean will cry murder because he expects there are some stupid
> full-mac cards that actually support other sizes.
> 
> Can't somebody just post a patch to mac80211 that only accepts the two
> correct sizes like cfg80211 does?

Strawman patch below...

---

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: allow only standard size WEP keys through WEXT

Limit ieee80211_ioctl_siwencode to only accept standard sized WEP keys.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/wext.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 5af3862..d16b975 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -26,6 +26,8 @@
 #include "wpa.h"
 #include "aes_ccm.h"
 
+#define KEY_SIZE_WEP104 13      /* 104/128-bit WEP keys */
+#define KEY_SIZE_WEP40  5       /* 40/64-bit WEP keys */
 
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
 				    int idx, int alg, int remove,
@@ -879,6 +881,14 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
 	u8 bcaddr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	int remove = 0;
 
+	switch (erq->length) {
+	case KEY_SIZE_WEP40:
+	case KEY_SIZE_WEP104:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	idx = erq->flags & IW_ENCODE_INDEX;
-- 
1.5.5.1

-- 
John W. Linville
linville@tuxdriver.com
