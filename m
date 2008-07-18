Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:7978 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYGRTG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 15:06:28 -0400
Received: by fk-out-0910.google.com with SMTP id 18so314078fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 12:06:27 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 deadlock detection triggering with rt61pci
Date: Fri, 18 Jul 2008 21:20:47 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1216197369.3422.5.camel@johannes.berg>
In-Reply-To: <1216197369.3422.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807182120.47252.IvDoorn@gmail.com> (sfid-20080718_210632_251822_82638B0F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I'm not sure whether this still happens in current versions or not, but
> kerneloops is reporting a number of mac80211 warnings due to the TX
> deadlock detection:
> http://www.kerneloops.org/searchweek.php?search=ieee80211_master_start_xmit
> 
> The rt2x00 mac code seems fine, did it change recently which could
> explain this warning triggering?

Interesting, the TX code did change for 2.6.27 recently with the DMA changes
by GertJan, I think the Fedora kernels which are showing the above panics already
contain those patches,

John, Does Fedora kernel 2.6.25.10-86.fc9.x86_64 contain rt2x00 2.1.8?

I also have some reports about a queue corruption in rt61pci and although I haven't
figured out how that corruption is caused, I do think the above panics might somehow
be related.

Thanks for the report,

Ivo
