Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51666 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3KOTuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 14:50:08 -0500
Received: by mail-wi0-f181.google.com with SMTP id f4so1496170wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 11:50:07 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 16 Nov 2013 01:19:47 +0530
Message-ID: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com> (sfid-20131115_205012_024561_36336C6E)
Subject: [Query] Update mac80211 BSS info from cfg8011_bss_inform_frame when
 hw_scan is enabled
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For chip sets that set

IEEE80211_HW_CONNECTION_MONITOR
hw_scan

the hardware does the scan and maintains the
connection.

So some HW's might drop the probe responses and
beacons as they are not required by the mac80211.

In those scenarios, the rate control module minstrel_ht called from
prep_connection throws a warning (in rate_control_send_low)
because "supp_rates" is not set, since scan results are updated
 through "cfg8011_bss_inform_frame" which doesn't call
"ieee80211_bss_info_update'.

How do we handle such scenarios? Does the cfg80211 need to
update the bss information in mac80211?

-- 
Thanks,
Regards,
Chaitanya T K.
