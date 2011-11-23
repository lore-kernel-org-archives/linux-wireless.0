Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53741 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1KWSgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 13:36:41 -0500
Received: by qyd20 with SMTP id 20so663640qyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 10:36:40 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 23 Nov 2011 19:36:40 +0100
Message-ID: <CAFED-j=5-s7V9HZvYJDJ14KbVm+ioa=KnoBh1fj2ueT05QusTQ@mail.gmail.com> (sfid-20111123_193645_014727_7152EFD5)
Subject: mac80211: AP mode - question about Tx buffered unicast frames drop timeout
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

in sta_info.c I see function we call to remove expired unicast buffered frames.

sta_info_buffer_expired()
{
...
	timeout = (sta->listen_interval *
		   sta->sdata->vif.bss_conf.beacon_int *
		   32 / 15625) * HZ;
	if (timeout < STA_TX_BUFFER_EXPIRE)
		timeout = STA_TX_BUFFER_EXPIRE;
...
}

STA_TX_BUFFER_EXPIRE is define as 10 seconds.
Do you remember why we set this as 10 seconds in case we calculate lower value?
This "listen_interval" calculation seems to be correct.
I found this during UAPSD debuging in AP mode.

BR
Janusz
