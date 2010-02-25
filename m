Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62543 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab0BYRCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:02:52 -0500
Received: by wya21 with SMTP id 21so1974917wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 09:02:50 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 11:02:50 -0600
Message-ID: <ce50f2e21002250902o19c12921sbbca61d1da999163@mail.gmail.com>
Subject: On power management of ath5k
From: jun <luckyjs@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I encountered problems when I tried to enable power saving mode with
PS-POLL (ath5k with last kernel from git 2.6.33).
I saw from the linux wireless' website that this mode can be enabled
by iwconfig,
but the command (wireless-tools version 29 on my machine) always gives
an error about invalid parameters.

So I traced ath5k's code and found ath5k_hw_enable_pspoll() is called
only when aid is not 0. Is this the place where
a STA can enable/disable PS-POLL based power saving? I thought that
there should be some code to force outgoing
packets to have power management bit set, but I couldn't locate the
code. Any suggestions on how I can make this mode work?

Thank you for your time,

Jun
