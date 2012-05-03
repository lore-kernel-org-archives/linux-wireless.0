Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60360 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2ECMnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 08:43:53 -0400
Received: by yhmm54 with SMTP id m54so1680968yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 05:43:52 -0700 (PDT)
Date: Thu, 3 May 2012 08:42:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 12/21] cw1200: sta.*, mac80211 STA callbacks.
Message-ID: <20120503124219.GA27855@localhost> (sfid-20120503_144357_081473_4AD51D59)
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <1330720003-15866-13-git-send-email-dmitry.tarnyagin@stericsson.com>
 <20120429034951.GA32368@localhost>
 <4FA256F2.3020200@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA256F2.3020200@stericsson.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 11:59:14AM +0200, Dmitry Tarnyagin wrote:
> >[...]
> >>+	spin_lock(&priv->event_queue_lock);
> >>+	list_splice_init(&priv->event_queue,&list);
> >>+	spin_unlock(&priv->event_queue_lock);
> >>+	__cw1200_free_event_queue(&list);
> >...and then you won't need to do the above?
> I'm not sure I understand the question :(.

On second reading this code is fine, I just mis-understood it the first
time around.  Sorry for the noise.

> >>+	if (priv->listening ^ listening) {
> >That's a unusual (to me anyway) way to spell "a != b".  On my
> >version of gcc, generated code is exactly the same.
> Yes, true. It looked quite natural for me at 00:16. Pach is welcome.

Ok, I'll send on a couple of patches for these minor changes -- thanks!

-- 
Bob Copeland %% www.bobcopeland.com
