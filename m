Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52886 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1GOVjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 17:39:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qhq6D-0006jz-CU
	for linux-wireless@vger.kernel.org; Fri, 15 Jul 2011 23:39:05 +0200
Received: from qux3.kyla.fi ([82.130.48.19])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 23:39:05 +0200
Received: from swaminathanvasanth.r by qux3.kyla.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 23:39:05 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Re: [PATCH 0/4] hostapd: add ACS support
Date: Fri, 15 Jul 2011 21:38:50 +0000 (UTC)
Message-ID: <loom.20110715T233642-162@post.gmane.org> (sfid-20110715_233912_605925_B174909F)
References: <1308801053-2461-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Other algorithms for ACS shoudl be easy to plug in, for example,
> spectral scan ;)
> 
> Anyway, to enable and test this thing just set CONFIG_ACS=1
> on your build config and then something like this on your
> hostapd.conf:
> 
> channel=acs_survey
> acs_num_req_surveys=10
> acs_roc_duration_ms=100
> 
> Test results, rants are appreciated.
>

Hi,

 I am trying to enable the Auto Channel Selection in hostapd with ath5k and
ath9k drivers. I cloned the source of hostap from the git and applied the patch
( 
http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/hostapd/acs-all-in-one-v2.patch
). I then went to the hostapd directory of hostap and did make and make install.
Followed instruction from (
http://wireless.kernel.org/en/users/Documentation/hostapd#Download_and_compile_hostapd
).

While building the software i enabled CONFIG_ACS=y in  the defconfig file
present in /hostap/hostapd/ to .config and performed the build. I then did a
make install and configured the hostapd.conf file.

Hostapd is working fine for me without ACS but when i enable channel=0 or
channel=acs_survey and uncomment the

acs_num_req_surveys=10
acs_roc_duration_ms=5

options for ACS to be enabled it throws this error when starting hostapd,


> sudo hostapd hostapd.conf

Configuration file: hostapd.conf
Line 113: set as '0' tries to enable ACS but CONFIG_ACS disabled
Line 125: invalid acs_num_req_surveys 10 (CONFIG_ACS disabled)
Line 126: invalid acs_roc_duration_ms 5 (CONFIG_ACS disabled)1..5000)
3 errors found in configuration file 'hostapd.conf'

Infact i enabled CONFIG_ACS when building.


Any pointers on what to do to enable ACS please.

Awaiting your kind reply.

Thanks,






