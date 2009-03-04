Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:3088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZCDVgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 16:36:00 -0500
Received: by rv-out-0506.google.com with SMTP id g37so3505394rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 13:35:57 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Mar 2009 13:35:57 -0800
Message-ID: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com> (sfid-20090304_223604_236420_D308D965)
Subject: Please apply to stable: cfg80211: add support for custom firmware
	regulatory solutions
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "stable@kernel.org" <stable@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to Cc: stable@kernel.org for this patch during its submission,
this is needed on 2.6.28 as otherwise there is an issue for Intel
cards which get their channels 5 GHz disabled if OLD_REG is set to no
(this is not the default) or the channels 12-14 are disabled if
OLD_REG is set to yes (default) set to no and the ieee80211_module
parameter is not used. The later issue is resolved by userspace as
well but we cannot yet expect 2.6.28 kernels to have enough userspace
interfaces to set the regulatory domain just yet. This is why OLD_REG
is still set to default with 2.6.28.

14b9815af3f4fe0e171ee0c4325c31d2a2c1570b
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Wed Nov 12 14:22:03 2008 -0800

   cfg80211: add support for custom firmware regulatory solutions

   This adds API to cfg80211 to allow wireless drivers to inform
   us if their firmware can handle regulatory considerations *and*
   they cannot map these regulatory domains to an ISO / IEC 3166
   alpha2. In these cases we skip the first regulatory hint instead
   of expecting the driver to build their own regulatory structure,
   providing us with an alpha2, or using the reg_notifier().

   Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
   Acked-by: Zhu Yi <yi.zhu@intel.com>
   Signed-off-by: John W. Linville <linville@tuxdriver.com>
