Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2DXM2r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 08:28:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SMerL-0005IC-JX
	for linux-wireless@vger.kernel.org; Tue, 24 Apr 2012 14:28:43 +0200
Received: from 193.206.22.97 ([193.206.22.97])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 14:28:43 +0200
Received: from roberto.riggio by 193.206.22.97 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 14:28:43 +0200
To: linux-wireless@vger.kernel.org
From: Roberto Riggio <roberto.riggio@create-net.org>
Subject: Re: [PATCH v2] mac80211: support fixed rate packet injection
Date: Tue, 24 Apr 2012 12:28:34 +0000 (UTC)
Message-ID: <loom.20120424T142502-299@post.gmane.org> (sfid-20120424_142851_152346_A3ABD45F)
References: <20120224173601.2FD1F57EAB@lefflers.sfo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sam Leffler <sleffler@...> writes:

> 
> Support setting the transmit rate, flags, and try count for
> injected packets by parsing the IEEE80211_RADIOTAP_RATE,
> IEEE80211_RADIOTAP_DATA_RETRIES, and IEEE80211_RADIOTAP_MCS radiotap tags.

The patch is working fine for what concerns MCS and retries. However if I use a 
radiotap header that specifies in the flags byte the SGI and/or the HT40 options 
then the frame is not injected. Tested on an ubiquiti SR71A card. If the flags 
are not specified the frame is injected up to the 15 MCS index.

