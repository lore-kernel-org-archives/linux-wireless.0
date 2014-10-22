Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45866 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaJVKP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 06:15:29 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so3418845pab.30
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 03:15:28 -0700 (PDT)
MIME-Version: 1.0
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Date: Wed, 22 Oct 2014 19:14:56 +0900
Message-ID: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com> (sfid-20141022_121532_626552_7C95768F)
Subject: Change channel bandwidth without iw command
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are trying to implement a protocol to evaluate the performance our
algorithm using QCA9880.

To implement our protocol, a receiver have to change the bandwidth
when a Action frame (what we define) is successfully received.
We know that the QCA9880 can change bandwidth by using iw command in
monitor mode.
So, we use similar function path used by "iw dev set freq ..."
When the receiver detects the reception of the Action frame we call
"ieee80211_set_monitor_channel" at the end of ieee80211_rx as follows:

/*************** net/mac80211/rx.c ******************/

// receive action frame, change bandwidth 80 -> 20

                rtnl_lock(); //lock rtnetlink used in pre_doit of nl80211
                chandef = local->monitor_chandef; // copy current chandef
                chandef.width = NL80211_CHAN_WIDTH_20; // set bandwidth
                chandef.center_freq1 = 5180; // set center freq...
                ieee80211_set_monitor_channel(wiphy, &chandef);
                rtnl_unlock();

/********************************************************/

However, the receiver invokes kernel panic when receives the Action frame.
As fas as we know, the panic is occurred in ath10k_config_chan of
ath10k device driver.
To the best our knowledge, our implementation exploits same function
path of iw command in nl80211, cfg80211, mac80211 and ath10k.
Moreover, we confirm that the input parameters (wiphy, chandef) in our
implementation are identical to the parameters used by iw command.

Is there any reason why we cannot change bandwidth?
Of course, iw command work correctly.

If you have any idea to solve this, please let me know.

Thanks a lot for your reading.

Sincerely yours,

Okhwan Lee , Ph.D. student
