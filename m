Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2HCQYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 12:24:19 -0400
Message-ID: <501BFB29.7010801@canonical.com> (sfid-20120803_182456_195468_6BBC5170)
Date: Fri, 03 Aug 2012 12:24:09 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
MIME-Version: 1.0
To: wey-yi.w.guy@intel.com, johannes.berg@intel.com,
	ilw@linux.intel.com, linville@tuxdriver.com,
	emmanuel.grumbach@intel.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [REGRESSION][v3.5] iwlwifi: include rssi as part of decision making
 for reduce txpower
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

A bug[0] was reported against Ubuntu that reports a kernel panic when 
using the hotkey to disable then re-enable wifi on a Dell XPS 14z.  A 
kernel bisect was performed, which indicated the following commit as the 
source of the regression:


commit dd551ab7b47ace14753b0d73f79437cc35adcf6b
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Thu May 3 14:22:01 2012 -0700

     iwlwifi: include rssi as part of decision making for reduce txpower

     In bt coex, consider the average rssi as part of decision making 
process

     Change-Id: I8d11d7f177a6875e2a9d08f7539d42253226fd7a
     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
     Reviewed-on: http://git-mwg.jer.intel.com/gerrit/1945
     Tested-by: Jenkins
     Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

A test kernel was created with this commit reverted, which stopped the 
kernel panic from occurring.

A bugzilla bug[1] has been opened.

Thanks,

Joe


[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1029547
[1] https://bugzilla.kernel.org/show_bug.cgi?id=45491
