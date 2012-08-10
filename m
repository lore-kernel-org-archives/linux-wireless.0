Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2HJGH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 02:07:28 -0400
Received: by pbbrr13 with SMTP id rr13so2175920pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 23:07:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 11:37:27 +0530
Message-ID: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com> (sfid-20120810_080731_101463_8799AA08)
Subject: [cfg80211] Issue with simultaneous AP-STA operation in mwifiex/cfg80211
From: Avinash Patil <avinashapatil@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Lately simultaneous AP-STA functionality in mwifiex driver is not
working. I feel this has something to do with recent changes in
cfg80211.

If we associate mwifiex STA to external AP first and then try to start
mwifiex AP using hostapd(on different channel), we get –EBUSY error
from cfg80211. This happens from path
nl80211_start_ap->cfg80211_can_use_chan.  cfg80211_can_use_chan
returns EBUSY error. In our design if mwifiex STA is already
associated on some different channel, AP follows this channel and BSS
is started using STA channel settings. If we start hostapd on same
channel, BSS is successfully started, but association requests from
external station result in failure.

Please let me know if we are missing something while registering
n_iface and iface combinations. num_different_channels in
ieee80211_iface_combination has been advertised as 1.

Regards,
Avinash.
