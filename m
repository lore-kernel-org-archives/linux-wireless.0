Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48385 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbZELQ4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 12:56:03 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
Date: Tue, 12 May 2009 18:56:02 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200905120109.09906.chunkeey@web.de> <1242142227.4331.7.camel@johannes.local> <20090512154116.M40327@bobcopeland.com>
In-Reply-To: <20090512154116.M40327@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200905121856.02714.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 May 2009 17:56:10 Bob Copeland wrote:
> On Tue, 12 May 2009 17:30:27 +0200, Johannes Berg wrote
> > On Tue, 2009-05-12 at 11:29 -0400, Bob Copeland wrote:
> > > Will pre-scan be called once per scan or once for every channel switch?
> > > If the former, I think it's not the right place to flush.
> > 
> > The former.
> 
> Hmm, nevermind, it should work.  I was thinking of queued tx status 
> work not being on the right channel, but I guess we don't do that for probe
> requests.
Ermm? wait... what do we do when the userspace does channel switch & scans?
I think, some aircrack tools actually do this. Will they also call pre_scan?

> And for ar9170 RX is processed synchronously as far as I can tell.
most of the time yes... unless we have to _reconstruct_ a stream, because
the hw/fw clipped a few byte from a frame.

Regards,
	Chr
