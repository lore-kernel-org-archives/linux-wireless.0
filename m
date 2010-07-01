Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0GADAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 23:00:07 -0400
Received: by pwj8 with SMTP id 8so529252pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 20:00:06 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <andy@luto.us>
Date: Wed, 30 Jun 2010 22:59:46 -0400
Message-ID: <AANLkTikqJzkFFtmOowq-OzzDFSC9_1SFuAfT4UGZBhqW@mail.gmail.com>
Subject: rfkill failure in 2.6.35-rc3+
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just toggled rfkill on and back off on my X200s (WiFi Link 5350, rev
0x24) and the link didn't come up.  Toggling rfkill again didn't fix
it, but rmmod + modprobe did.

dmesg said:

[13629.424869] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
[13629.432761] iwlagn 0000:03:00.0: Not sending command - RF KILL
[13629.432771] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[13629.432778] iwlagn 0000:03:00.0: Error setting new RXON (-5)
[13631.268646] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
[13631.311232] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[13675.710821] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
[13675.713438] iwlagn 0000:03:00.0: Not sending command - RF KILL
[13675.713448] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[13675.713455] iwlagn 0000:03:00.0: Error setting new RXON (-5)
[13683.090789] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
[13683.145267] ADDRCONF(NETDEV_UP): wlan0: link is not ready

This is 2.6.35-rc3+ with firmware 8.24.2.12.  I've never seen this before.
