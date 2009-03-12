Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbZCLWtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:49:46 -0400
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1236892879.30325.7.camel@maxim-laptop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
	 <1236824994.7177.3.camel@maxim-laptop>  <1236880246.13699.17.camel@rc-desk>
	 <1236892879.30325.7.camel@maxim-laptop>
Content-Type: multipart/mixed; boundary="=-yLk/WMKBBhjlRo/+zPFF"
Date: Thu, 12 Mar 2009 15:41:05 -0700
Message-Id: <1236897665.3911.8.camel@abhi-desktop> (sfid-20090312_234949_148190_58EA7D95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yLk/WMKBBhjlRo/+zPFF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Can you try the attached patch for rate scaling?

Thanks,
Abhijeet

On Thu, 2009-03-12 at 14:21 -0700, Maxim Levitsky wrote:
> On Thu, 2009-03-12 at 10:50 -0700, reinette chatre wrote:
> > On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> > > On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> > > > On Wed, 2009-03-11 at 11:17 -0700, Reinette Chatre wrote:
> > > > > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > > > > 
> > > > > Patch fixes the bug 1900 at
> > > > > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900
> > > > > 
> > > > > Issues:
> > > > > Throughput and success ratio calculations were not done properly.
> > > > > Number of retries were exceeding 16.
> > > > 
> > > > ether.
> > > > 
> > > > On the other omitting  the 'disable_hw_scan=1' option (which appears to
> > > > work once again, since  few days ago it broke s2disk with hung scan) -
> > > 
> > > Ah , I remember now. The disable_hw_scan=0 breaks (!) 
> > > the rfkill support.
> > 
> > Could you please provide more details about this issue? We are
> > interested in steps to reproduce and logs you may have.
> 
> A way to reproduce (without NM):
> 
> * Start scanning in a loop
> while true ; do sudo iwlist scan ; done
> 
> * press rfkill - scan hangs forever.
> * press rfkill again - doesn't help
> 
> I have acer 5720G with hardware rfkill.
> 
> 
> The problem seems to be that if user presses rfkill during scan, it
> hangs.
> 
> 
> How about rate control issues I still see, do you know why upload is
> slower that download?
> 
> Best regards,
> 	Maxim Levitsky
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-yLk/WMKBBhjlRo/+zPFF
Content-Disposition: attachment; filename=0001-iwl3945-control-rate-decrease.patch
Content-Type: application/mbox; name=0001-iwl3945-control-rate-decrease.patch
Content-Transfer-Encoding: 7bit

>From d581c0c00c93df446aa25836a01f8e48b1a6e556 Mon Sep 17 00:00:00 2001
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Date: Thu, 12 Mar 2009 15:46:31 -0700
Subject: [PATCH] iwl3945: control rate decrease

Control the rate decrease. Do not decrese the rate fast.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index f65c308..f92943d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -800,7 +800,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		if (high != IWL_RATE_INVALID && window->success_counter >= IWL_RATE_INCREASE_TH)
 			scale_action = 1;
 		else if (low != IWL_RATE_INVALID)
-			scale_action = -1;
+			scale_action = 0;
 
 	/* Both adjacent throughputs are measured, but neither one has
 	 * better throughput; we're using the best rate, don't change
@@ -826,7 +826,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			else {
 				IWL_DEBUG_RATE(priv,
 				    "decrease rate because of high tpt\n");
-				scale_action = -1;
+				scale_action = 0;
 			}
 		} else if (low_tpt != IWL_INVALID_VALUE) {
 			if (low_tpt > current_tpt) {
-- 
1.5.4.3


--=-yLk/WMKBBhjlRo/+zPFF--

