Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37120 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0DWX6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 19:58:51 -0400
Received: by pvc7 with SMTP id 7so404858pvc.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 16:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100422190923.333971365@kvm.kroah.org>
References: <20100422191857.GA13268@kroah.com>
	 <20100422190923.333971365@kvm.kroah.org>
Date: Fri, 23 Apr 2010 19:50:50 -0400
Message-ID: <o2y40ec3ea41004231650yec3c4452g716ac4993bda8513@mail.gmail.com>
Subject: [178/197] mac80211: fix deferred hardware scan requests
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Luis Rodriguez pointed out, I should have cc'd linux-wireless on
this from the beginning. I hope no one has any objections to this
going out as part of the next stable drop.

Thanks

-- Chase

---------- Forwarded message ----------
From: Greg KH <gregkh@suse.de>
Date: Thu, Apr 22, 2010 at 3:10 PM
Subject: [178/197] mac80211: fix deferred hardware scan requests
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Johannes Berg
<johannes@sipsolutions.net>, "John W. Linville"
<linville@tuxdriver.com>, Chase Douglas <chase.douglas@canonical.com>


2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit c0ce77b8323c1a0d4eeef97caf16c0ea971222a9 upstream.

Reinette found the reason for the warnings that
happened occasionally when a hw-offloaded scan
finished; her description of the problem:

 mac80211 will defer the handling of scan requests if it is
 busy with management work at the time. The scan requests
 are deferred and run after the work has completed. When
 this occurs there are currently two problems.

 * The scan request for hardware scan is not fully populated
   with the band and channels to scan not initialized.

 * When the scan is queued the state is not correctly updated
   to reflect that a scan is in progress. The problem here is
   that when the driver completes the scan and calls
   ieee80211_scan_completed() a warning will be triggered
   since mac80211 was not aware that a scan was in progress.

The reason is that the queued scan work will start
the hw scan right away when the hw_scan_req struct
has already been allocated. However, in the first
pass it will not have been filled, which happens
at the same time as setting the bits. To fix this,
simply move the allocation after the pending work
test as well, so that the first iteration of the
scan work will call __ieee80211_start_scan() even
in the hardware scan case.

Bug-identified-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/scan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -408,6 +408,16 @@ static int __ieee80211_start_scan(struct
       if (local->scan_req)
               return -EBUSY;

+       if (req != local->int_scan_req &&
+           sdata->vif.type == NL80211_IFTYPE_STATION &&
+           !list_empty(&ifmgd->work_list)) {
+               /* actually wait for the work it's doing to finish/time out */
+               set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+               local->scan_req = req;
+               local->scan_sdata = sdata;
+               return 0;
+       }
+
       if (local->ops->hw_scan) {
               u8 *ies;
               int ielen;
@@ -428,14 +438,6 @@ static int __ieee80211_start_scan(struct
       local->scan_req = req;
       local->scan_sdata = sdata;

-       if (req != local->int_scan_req &&
-           sdata->vif.type == NL80211_IFTYPE_STATION &&
-           !list_empty(&ifmgd->work_list)) {
-               /* actually wait for the work it's doing to finish/time out */
-               set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
-               return 0;
-       }
-
       if (local->ops->hw_scan)
               __set_bit(SCAN_HW_SCANNING, &local->scanning);
       else
