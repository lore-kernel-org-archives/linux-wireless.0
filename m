Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:49157 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0A3VV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 16:21:58 -0500
Received: by iwn3 with SMTP id 3so3004129iwn.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 13:21:57 -0800 (PST)
Message-ID: <4B64A2F2.6060608@lwfinger.net>
Date: Sat, 30 Jan 2010 15:21:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Regression in b43 with BCM4311/2
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I installed my BCM4311/2 card to see if I could reproduce the problems being
reported in the list. It had been some time since I last used this model, and
was quite surprised to discover that the maximum transmit rate was only 1 Mb/s.
It had been much higher in the past. By booting old distributions/kernels, I
found that 2.6.27 could transmit at rates nearly 20 Mb/s, thus the problem
occurred in mainline during the 2.6.28 merge. Bisection found the problem to be
with the following commit:

commit c7ab5ef9bcd281135c21b4732c9be779585181be
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Oct 29 20:02:12 2008 +0100

    b43: implement short slot and basic rate handling

    This implements proper short slot handling and adds code to
    program the hardware for the correct response rates derived
    from the basic rate set for the current BSS.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

It seemed unlikely that the short slot handling was the cause, thus I have
concentrated on the basic rate handling. I found that the returns from
ieee80211_get_response_rate() were not what I expected. I'm not sure the routine
is correct; however, the value for "brates" at entry to b43_update_basic_rates()
is 0xF, thus only the CCK rates are enabled, but sband->n_bitrates is 12, which
includes all the 802.11g rates.

Is b43 missing something needed to set the basic_rates member of struct
ieee80211_bxx_conf to a more reasonable value when b43_op_bss_info_changed() is
entered? I think it should be 0xFFF, not 0xF. I have tested with the larger
value and found that this change did not improve transmit rates.

Thanks,

Larry
