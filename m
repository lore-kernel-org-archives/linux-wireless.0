Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2EPPQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 11:16:58 -0400
Message-ID: <1337181413.18519.4.camel@jlt3.sipsolutions.net> (sfid-20120516_171707_684699_6D705683)
Subject: Re: [PATCH 2/4] iwlwifi: fix the Transmit Frame Descriptor rings
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org
Date: Wed, 16 May 2012 17:16:53 +0200
In-Reply-To: <1336665952-24363-3-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180611_132018_BA1732AA)
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120510_180611_132018_BA1732AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

> The logic that allows to have a short TFD queue was completely wrong.
> We do maintain 256 Transmit Frame Descriptors, but they point to
> recycled buffers. We used to attach and de-attach different TFDs for
> the same buffer and it worked since they pointed to the same buffer.
> 
> Also zero the number of BDs after unmapping a TFD. This seems not
> necessary since we don't reclaim the same TFD twice, but I like
> housekeeping.

> Cc: stable@vger.kernel.org

This is Cc stable, can we also get it to 3.4 still? If not I guess Greg
will pick it up

johannes

