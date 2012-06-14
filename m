Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48656 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2FNKsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 06:48:11 -0400
Received: by ghrr11 with SMTP id r11so1202101ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 03:48:10 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 12:48:10 +0200
Message-ID: <CAMJBoFN48EZ0Bh6wSwtHz950PMS-bUR30aHq0v2hXg3spKbHFA@mail.gmail.com> (sfid-20120614_124814_888199_CF554215)
Subject: bug in __ieee80211_suspend?
From: Vitaly Wool <vitalywool@gmail.com>
To: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

I have some doubts about the following patch: "mac80211: quiesce vif
before suspending". In fact, I think it introduces a hard-to-track
bug: when a driver signals disconnection from the AP and the device
goes to sleep shortly thereafter, beacon_connection_loss_work will get
cancelled and the actual disconnection will never happen. Shouldn't we
fix that or is there something I'm missing?

Thanks,
   Vitaly
