Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:35315 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbcDGNBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 09:01:55 -0400
Received: by mail-yw0-f173.google.com with SMTP id i84so89071127ywc.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 06:01:54 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Apr 2016 18:31:34 +0530
Message-ID: <CABPxzYLaWKgYrwjyjDpiZzWCbCpCzr7mKLorm9mzxspE5n0rHQ@mail.gmail.com> (sfid-20160407_150158_555155_304403A7)
Subject: RFC: Handling DL only traffic when already in Powersave
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When using HW_PS and running Downlink only traffic like UDP-RX, mac80211
has the mechanism to not to enter power-save (postpone the dynamic ps
timer).

But if we are already in power-save it continues to stay in PS
and retrieves the frames, for large traffic this is not acceptable.

The standard doesn't say anything, its left to vendor to implement their
own mechanism.

I have the below questions

1) Are any other vendors seeing this issue?

2) Are they using proprietary algorithms to solve this,
implemented in their HW/FW?

3) If yes, how are they keeping the mac80211 and FW FSM in sync,
as the driver cannot request/indicate the power save state to mac80211.
(no feedback path).

IMHO,

a) we should implemented a feedback path, where the vendor
can implement proprietary mechanism to handle this and inform/request
mac80211 for a specific power save state.

b) mac80211 just conveys the user/system preferences to the driver
and driver handles the FSM on when to enter/exit PS? (true HW_PS).


Any suggestions/comments?

-- 
Thanks,
Regards,
Chaitanya T K.
