Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:42072 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZEAMAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 08:00:08 -0400
Received: by bwz7 with SMTP id 7so2281145bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 05:00:07 -0700 (PDT)
Subject: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 May 2009 15:00:03 +0300
Message-Id: <1241179203.8086.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't know if this is new regression, or just exposed race condition,
but currently using rfkill, and/or s2disk sometimes leaves the card in
state in which it can't scan.

Tested with and without hardware scanning.

It just returns -EBUSY till I reload the driver.

I use iwlwifi.git, iwl3945

Best regards,
	Maxim Levitsky 

