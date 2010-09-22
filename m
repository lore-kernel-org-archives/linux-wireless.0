Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21638 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0IVOnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 10:43:06 -0400
Subject: [Fwd: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset
 while doing scan]
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/mixed; boundary="=-EM5sBdz9bVpLSC6KxAH6"
Date: Wed, 22 Sep 2010 07:43:40 -0700
Message-ID: <1285166620.12056.29.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EM5sBdz9bVpLSC6KxAH6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

John,

The "iwlwifi: do not perferm force reset while doing scan" patch, make
sense for .36, but after Gruszka's scan patch(which will in .37), it is
not needed. What is your recommendation?


commit#7acc7c683a747689aaaaad4fce1683fc3f85e552 iwlwifi: do not perferm
force reset while doing scan

Thanks
Wey



--=-EM5sBdz9bVpLSC6KxAH6
Content-Disposition: inline
Content-Description: Forwarded message - Re: [PATCH wireless-2.6] iwlwifi:
 do not perferm force reset while doing scan
Content-Type: message/rfc822

Received: from rrsmsx603.amr.corp.intel.com (10.31.0.57) by
 orsmsx606.amr.corp.intel.com (10.22.226.128) with Microsoft SMTP Server
 (TLS) id 8.2.254.0; Wed, 22 Sep 2010 01:57:54 -0700
Received: from azsmga001.ch.intel.com (10.2.17.19) by
 rrmsx603-1.rr.intel.com (10.31.0.57) with Microsoft SMTP Server id
 8.2.254.0; Wed, 22 Sep 2010 02:57:54 -0600
Received: from azsmga101.ch.intel.com ([10.2.16.36])  by
 azsmga001-1.ch.intel.com with ESMTP; 22 Sep 2010 01:57:53 -0700
Received: from mx1.redhat.com ([209.132.183.28])  by mga03.intel.com with
 ESMTP; 22 Sep 2010 01:57:53 -0700
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
 (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])	by mx1.redhat.com
 (8.13.8/8.13.8) with ESMTP id o8M8vp1v013735	(version=TLSv1/SSLv3
 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK);	Wed, 22 Sep 2010 04:57:51
 -0400
Received: from dhcp-lab-109.englab.brq.redhat.com
 (dhcp-26-173.brq.redhat.com [10.34.26.173])	by
 int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id
 o8M8vm8Y016001;	Wed, 22 Sep 2010 04:57:49 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "ipw3945-devel@lists.sourceforge.net" <ipw3945-devel@lists.sourceforge.net>, "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 22 Sep 2010 01:57:22 -0700
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
Thread-Topic: [PATCH wireless-2.6] iwlwifi: do not perferm force reset
 while doing scan
Thread-Index: ActaND7h+Fi2RN3CQ0iBE5pC/+K8Qw==
Message-ID: <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: rrsmsx603.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.56,405,1280732400"; d="scan'208";a="688660002"
x-ironport-anti-spam-filtered: true
x-ironport-anti-spam-result: 
 AokAAH5hmUzRhLcckWdsb2JhbACiLBUBAQEBCQsKBxEGHMJvhUEE
x-scanned-by: MIMEDefang 2.67 on 10.5.11.11
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi Wey

On Fri, 17 Sep 2010 14:24:17 -0700
Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> When uCode error condition detected, driver try to perform either
> rf reset or firmware reload in order bring device back to
> working condition.
> 
> If rf reset is required and scan is in process, there is no need
> to issue rf reset since scan already reset the rf.

Yes, and that is already handled by iwl_scan_initiate().

> If firmware reload is required and scan is in process, skip the
> reload request. There is a possibility firmware reload during
> scan cause problem.

If we skip restart request now, next will be scheduled lately (correct?,
I think there are firmware reset requests that are not repeatable). But we
still will have scan pending since firmware is in bad shape and will not
finish scan. So until scan_check delayed work (7s) will not finish scan,
will not be able to reset firmware. I do not think that is what we want.
I think patch is good for .36, but after my current scan patches, it is
not be needed and actually it should be reverted (see below).

> [  485.804046] WARNING: at net/mac80211/main.c:310 ieee80211_restart_hw+0x28/0x62()
> [  485.804049] Hardware name: Latitude E6400
> [  485.804052] ieee80211_restart_hw called with hardware scan in progress
> [  485.804054] Modules linked in: iwlagn iwlcore bnep sco rfcomm l2cap crc16 bluetooth [last unloaded: iwlcore]
> [  485.804069] Pid: 812, comm: kworker/u:3 Tainted: G        W   2.6.36-rc3-wl+ #74
> [  485.804072] Call Trace:
> [  485.804079]  [<c103019a>] warn_slowpath_common+0x60/0x75ieee80211_restart_hw
> [  485.804084]  [<c1030213>] warn_slowpath_fmt+0x26/0x2a
> [  485.804089]  [<c145da67>] ieee80211_restart_hw+0x28/0x62
> [  485.804102]  [<f8b35dc6>] iwl_bg_restart+0x113/0x150 [iwlagn]

In iwl_bg_restart() we cancel scan. First we try to send abort command
via __iwl_down() ->  iwl_scan_cancel_timeout() -> iwl_do_scan_abort().
If sending abort command fail we will complete scan in mac80211, otherwise
if firmware do not finish scan, we will complete scan in
iwl_cancel_deferred_work() -> iwl_cancel_scan_deferred_work(). Hence we should
be safe.

So why we can see this warning? During my testing I saw it also.
There is race regarding SCAN_HW_SCANNING bit, usually we set/clear
this bit under local->mtx, but not in ieee80211_restart_hw()

cpu0						cpu1
__ieee80211_start_scan
  __set_bit(SCAN_HW_SCANNING, &local->scanning);
  
						iwl_bg_restart()
						  ieee80211_restart_hw()
						    WARN
  
   drv_hw_scan
     iwl_mac_hw_scan
     (OK, fail new scan, return error)
   
   local->scanning = 0;

So nothing wrong will happen except printing a call trace. If we want fix that
I would suggest patch like this:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7c85426..31993c3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -302,16 +302,20 @@ static void ieee80211_restart_work(struct work_struct *work)
 void ieee80211_restart_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool sw_scan = false;
 
 	trace_api_restart_hw(local);
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
 
+	mutex_lock(&local->mtx);
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 		"%s called with hardware scan in progress\n", __func__);
+	sw_scan = test_bit(SCAN_SW_SCANNING, &local->scanning);
+	mutex_unlock(&local->mtx);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
+	if (unlikely(sw_scan))
 		ieee80211_scan_cancel(local);
 
 	/* use this reason, ieee80211_reconfig will unblock it */

Or just leave code as is, many (harmless) warning's can be printed when restarting
iwlwifi firmware.

Stanislaw

--=-EM5sBdz9bVpLSC6KxAH6--

