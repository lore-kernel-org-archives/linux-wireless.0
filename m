Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31919 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab2FUTTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 15:19:05 -0400
Date: Fri, 22 Jun 2012 00:50:22 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
Message-ID: <20120621192020.GB30896@vmraj-lnx.users.atheros.com> (sfid-20120621_211909_247196_91A18630)
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
 <4FE36B2D.4000407@candelatech.com>
 <20120621190716.GA30896@vmraj-lnx.users.atheros.com>
 <4FE372CE.3020105@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE372CE.3020105@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 21, 2012 at 12:15:26PM -0700, Ben Greear wrote:
> On 06/21/2012 12:07 PM, Rajkumar Manoharan wrote:
> >On Thu, Jun 21, 2012 at 11:42:53AM -0700, Ben Greear wrote:
> >>On 06/21/2012 11:31 AM, Rajkumar Manoharan wrote:
> >>>ath9k_get_et_stats() warn: side effect in macro
> >>>'AWDATA' doing 'i++'
> >>>
> >>>Cc: Ben Greear<greearb@candelatech.com>
> >>>Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >>>---
> >>>  drivers/net/wireless/ath/ath9k/main.c | 9 +++++----
> >>>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>>
> >>>diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >>>index 85f9ab4..32474b0 100644
> >>>--- a/drivers/net/wireless/ath/ath9k/main.c
> >>>+++ b/drivers/net/wireless/ath/ath9k/main.c
> >>>@@ -2003,10 +2003,11 @@ static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
> >>>  #define PR_QNUM(_n) (sc->tx.txq_map[_n]->axq_qnum)
> >>>  #define AWDATA(elem)							\
> >>>  	do {								\
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> >>>-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> >>>+		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> >>>+		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> >>>+		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> >>>+		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> >>>+		i += 4; \
> >>>  	} while (0)
> >>
> >>The macro is still changing i.  So, whatever smatch is, seems it
> >>should still warn, or it's broken :P
> >>
> >No it is not. The warning message is a hint. The smatch assumes that replacing
> >the macro 'i++' might cause unexpected behaviour like 5++ in each statement.
> 
> Well, my opinion is that your patch only adds un-needed code and that
> smatch is either currently giving false-positives, or that it is
> missing a warning when you add your patch.
> 
> But, not a big deal either way.
> 
Thanks. Most of my smatch fixes could address false-positives. Anyway i prefer
warning free code :)

-Rajkumar
