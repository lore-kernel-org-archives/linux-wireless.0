Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1FTSoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 14:44:46 -0400
Received: by pvg12 with SMTP id 12so961559pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 11:44:46 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 20 Jun 2011 14:44:21 -0400
Message-ID: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com> (sfid-20110620_204449_827132_DD43A304)
Subject: [3.0 regression] DMAR faults in iwlagn
To: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3.0-git today, I get:

[   40.142872] DRHD: handling fault status reg 2
[   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
[   40.142896] DMAR:[fault reason 05] PTE Write access is not set

lspci says:

03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)

This seems to be triggered by interface state changes.  The driver
still works.  I don't see this on 2.6.39.1.

--Andy
