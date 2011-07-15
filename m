Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53528 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1GOMfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 08:35:43 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QhhcM-00081D-7b
	for linux-wireless@vger.kernel.org; Fri, 15 Jul 2011 14:35:42 +0200
Received: from 130.233.194.206 ([130.233.194.206])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 14:35:42 +0200
Received: from swaminathanvasanth.r by 130.233.194.206 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 14:35:42 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Auto Channel Selection in hostapd with ath5k and ath9k
Date: Fri, 15 Jul 2011 12:35:30 +0000 (UTC)
Message-ID: <loom.20110715T143153-415@post.gmane.org> (sfid-20110715_143546_911179_2F4D45E3)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

 I am trying to enable the Auto Channel Selection (ACS) in hostapd with ath5k
and ath9k drivers.
1) I cloned the source of hostap from the git and applied the patch
2) I then went to the hostapd directory of hostap and did make and make install.

While building i enabled CONFIG_ACS=y in defconfig present in /hostap/hostapd/
and then copied to .config and performed the build. I then did a make install
and configured the hostapd.conf file.

Hostapd is working fine for me without ACS but when i enable channel=0 or
channel=acs_survey and uncomment the acs_num_req_surveys=10 and
acs_roc_duration_ms=5 options for ACS to be enabled it throws this error when
starting hostapd,

Configuration file: hostapd.conf
Line 113: set as '0' tries to enable ACS but CONFIG_ACS disabled
Line 125: invalid acs_num_req_surveys 10 (CONFIG_ACS disabled)
Line 126: invalid acs_roc_duration_ms 5 (CONFIG_ACS disabled)1..5000)
3 errors found in configuration file 'hostapd.conf'

Infact i enabled CONFIG_ACS when building.Any pointers on what to do to enable
ACS please. Awaiting your kind reply. Thanks,


