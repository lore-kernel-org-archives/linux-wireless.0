Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:38587 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZBJPKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:10:12 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v4 0/2] mac80211: ps-poll implementation
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	vivek.natraj@gmail.com
Date: Tue, 10 Feb 2009 17:09:16 +0200
Message-ID: <20090210150822.21245.87099.stgit@tikku> (sfid-20090210_161015_504875_2AD79573)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my suggestion for how to implement ps-poll in mac80211. Also
this fixes the case when dynamic_ps_timeout is zero.

I decided to use ps-polling when dynamic_ps_timeout is zero. If
userspace sets timeout to zero, it means that it's ready to sacrifice
throughput over power consumption. But in case there throughput is
more, userspace can set timeout to a non-zero value and null frame
wakeup is used instead, throughput is higher but power consumption
also increases.

Most probably this patchset breaks ath9k multicast handling. I
recommend ath9k to try do multicast tim bit handling in hardware, I
would really assume that to be possible. But if that's really
impossible, then it can be done in the driver. But having support for
waking up multicast tim bits in mac80211 is unreliable and complicated
the implementation, I just recommend dropping it.

Open question is that should power save be disabled whenever mac80211
is ps-polling the frames. For example, p54/stlc45xx does not require to
disable power save in that case, it just stays awake long enough to
receive the data frame from the AP. So I did not disable power save
mode in this case, but I would like to hear comments what other
hardware needs.

v4: 

o rebase and resend

v3:

o remove another leftover debug printk

v2:

o RX_CONTINUE after sending ps-poll frame in ieee80211_rx_h_check_more_data()
o remove leftover debug printk
o use ps-poll only when dynamic_ps_timeout is zero, otherwise null frame
  wakeup is used

---

Kalle Valo (2):
      mac80211: use ps-poll when dynamic power save mode is disabled
      mac80211: remove multicast check from check_tim()


 net/mac80211/ieee80211_i.h |    3 ++
 net/mac80211/mlme.c        |   67 +++++++++++++++++++++++++++++++++++++-------
 net/mac80211/rx.c          |   34 ++++++++++++++++++++++
 3 files changed, 93 insertions(+), 11 deletions(-)

