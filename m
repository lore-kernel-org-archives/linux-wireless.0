Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64031 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1KXLtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 06:49:51 -0500
Received: by vbbfc26 with SMTP id fc26so1414573vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 03:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Thu, 24 Nov 2011 11:49:30 +0000
Message-ID: <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com> (sfid-20111124_124954_928392_69AB9152)
Subject: iwl3945 firmware errors: tentative debugging
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
iwl3945 has had firmware errors triggered 'by' NM after started using
nl80211 instead of wext. Since Intel has stopped supporting iwl3945,
no firmware fix has been possible. It has been workarounded by
disable_hw_scan=1 as default, with the penalty of network performance
being lower and frequent 'hangs' on the connection.

I was able to trigger the firmware error by doing "iw dev wlan0 scan
passive". By comparison, "iw dev wlan0 scan" does NOT trigger the
firmware error.

Having activated firmware debugging, it would seem a firmware error
occurs when a full passive scan is done. If all channels 1-140 are
scanned passively, a firmware error occurs. If at least one of those
channels is actively scanned, no error occurs.

Where should I look next?

Thanks in Advance,
--
Pedro
