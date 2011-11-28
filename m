Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1K1IQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 03:16:18 -0500
Subject: Re: [PATCH v3] mac80211: fix race condition caused by late addBA
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Nikolay Martynov <mar.kolya@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <CANUX_P0E=bhBrGnYOJ7yt8mOgixNNPP5UKC_Cv5jL9uNiNFH9A@mail.gmail.com> (sfid-20111128_073546_924422_9644D86E)
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	 <1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	 <1322394638.4044.32.camel@jlt3.sipsolutions.net>
	 <1322394800.4044.33.camel@jlt3.sipsolutions.net>
	 <CALGY4fufCM2SvYLFaab1TzSr36b55bguFoZRtYZhLuXGMZLG1w@mail.gmail.com>
	 <1322412918.4044.37.camel@jlt3.sipsolutions.net>
	 <CANUX_P0E=bhBrGnYOJ7yt8mOgixNNPP5UKC_Cv5jL9uNiNFH9A@mail.gmail.com>
	 (sfid-20111128_073546_924422_9644D86E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 09:16:13 +0100
Message-ID: <1322468173.4060.0.camel@jlt3.sipsolutions.net> (sfid-20111128_091623_591142_3E78F7EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 08:35 +0200, Emmanuel Grumbach wrote:

> > /*
> >  * addba_resp_timer may have fired before we got here, and
> >  * caused WANT_STOP to be set. If the stop then was already
> >  * processed further, STOPPING might be set.
> >  */
> >
> >
> > Did you notice that I moved this code to after the dialog token check?
> >
> 
> Don't you think we should also send a delBA ? The AP thinks we will Tx
> in Agg and basically we are now out of sync.

We do, during the timer stop path, afaict.

johannes

