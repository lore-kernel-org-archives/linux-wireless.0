Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39136 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0FCKtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 06:49:47 -0400
Received: by bwz11 with SMTP id 11so619459bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jun 2010 03:49:45 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 12:49:45 +0200
Message-ID: <AANLkTinChab0MINV64h1UFb7YUxVRNvDztRbcKxZuDJO@mail.gmail.com>
Subject: rt73usb & Mesh network
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

There is a kernel bugzilla report regarding rt73usb and mesh networks:
https://bugzilla.kernel.org/show_bug.cgi?id=16099

The stacktrace indicates the problem is a scheduling while atomic bug,
however this seems to be triggerd by mac80211 making the bss_info_changed()
callback function in atomic context. But the current documentation of mac80211
implies that this callback function is allowed to sleep.

Could you check the stacktrace to see if this is indeed a mac80211 bug rather
then rt73usb?

Thanks,

Ivo
