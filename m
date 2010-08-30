Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60569 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0H3Uk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 16:40:57 -0400
Received: by eyg5 with SMTP id 5so3467464eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 13:40:56 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 16:40:56 -0400
Message-ID: <AANLkTi=R88jHqCkajD4kW=BGStCskBGMLvL1rNErC_71@mail.gmail.com>
Subject: What extra functionality does a driver need to support for access
 point functionality?
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to understand what additional features are needed in
drivers to support AP mode.  I took a look at the mac80211
documentation on the web site and all it says is that:

# honour IEEE80211_TX_CTL_SEND_AFTER_DTIM or set
IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and use the
ieee80211_get_buffered_bc() function
# must honour IEEE80211_TX_RC_USE_SHORT_PREAMBLE or never do
short-preamble transmissions
# When sending probe response frames, the timestamp must be adjusted
by the hardware or firmware. This is important to power saving
stations that happen to adjust their TSF from the timestamp in the
probe response frame.
# implement sequence numbering for frames with the
IEEE80211_TX_CTL_ASSIGN_SEQ flag (or ask the hardware to do it for
those frames)
# react to the set_tim() callback or fetch each beacon from mac80211

This makes it seem like the driver doesn't have to do that much more
than it does normally.  Somehow, I don't believe that's it can be that
easy.  What else does the driver need to do to support something like
hostapd?

Thanks for your help.
