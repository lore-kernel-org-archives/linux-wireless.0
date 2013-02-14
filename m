Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63265 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3BNL6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:58:51 -0500
Received: by mail-wi0-f176.google.com with SMTP id hm14so6919163wib.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 03:58:49 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Feb 2013 12:58:43 +0100
Message-ID: <CAND6uNnMB0i9fvVSmqHtCMkf4XVr8dHUz+m1m3CxDCT+j2XD5Q@mail.gmail.com> (sfid-20130214_125854_451687_9DEAC5E3)
Subject: Possible bug with probe_send_count set to 0 and then checked if
 greater than 0
From: =?ISO-8859-1?Q?Magnus_Cederl=F6f?= <mcider@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In net/mac80211/mlme.c function ieee80211_sta_tx_notify:
If a null frame was acked, ieee80211_sta_reset_conn_monitor is called.
This function sets probe_send_count to 0.
After the call to ieee80211_sta_reset_conn_monitor, it is checked if
probe_set_count is > 0.
This means that ieee80211_queue_work will not be called even though
the nullfunc was successful.

The symptom of this error is that when using power save, it will take
500ms to enter power save again after a successfully acked null frame.

What case will the check for 'probe_send_count > 0' cover?

Regards,
Magnus Cederlöf
