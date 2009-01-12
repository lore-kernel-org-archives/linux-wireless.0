Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:41743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZALI5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 03:57:47 -0500
Received: by wf-out-1314.google.com with SMTP id 27so11242943wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 00:57:46 -0800 (PST)
Message-ID: <8e92b4100901120057n4cea722fo1a78bcbc45341d00@mail.gmail.com> (sfid-20090112_095754_300747_FFCD5537)
Date: Mon, 12 Jan 2009 14:27:46 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Kalle Valo" <kalle.valo@iki.fi>
Subject: Re: [RFC PATCH v1 2/2] mac80211: use ps-poll to request frames in power save mode
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20090111070353.3849.5303.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090111070148.3849.10799.stgit@tikku>
	 <20090111070353.3849.5303.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2009 at 12:33 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> When a directed tim bit is set, mac80211 currently disables power save
> and sends a null frame to the AP. But if dynamic power save is
> disabled, mac80211 will not enable power save again.

The patch I had sent earlier, 'mac80211: Reset the power save timer
from master_start_xmit' (44378a8e64b9399...) addresses this issue.
This enables mac80211 to start the dynamic ps timer after sending a
null data frame. Hence when the specified time lapses, power save is
enabled again.

Vivek.
