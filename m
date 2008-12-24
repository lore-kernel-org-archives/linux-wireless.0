Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56697 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbYLXGIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 01:08:04 -0500
Message-ID: <4951D1BB.1030204@lwfinger.net> (sfid-20081224_070823_218477_243B438E)
Date: Wed, 24 Dec 2008 00:07:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: P54usb getting WARN_ON at line 2247 of net/mac80211/rx.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My system has recently started getting the WARN_ON from routine __ieee80211_rx()
because of a faulty rate_idx value in the following code snippet:

        } else {
                if (WARN_ON(status->rate_idx < 0 ||
                            status->rate_idx >= sband->n_bitrates))
                        return;
                rate = &sband->bitrates[status->rate_idx];
        }

I thought I remembered a patch for this that was circulated, but I couldn't find
it. This warning was logged while using p54usb. It may happen for other drivers
as well, but I have been using only p54usb for the past few days.

Thanks,

Larry
