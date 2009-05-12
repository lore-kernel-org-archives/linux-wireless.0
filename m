Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4995 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZELP6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 11:58:55 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
Date: Tue, 12 May 2009 11:56:10 -0400
Message-Id: <20090512154116.M40327@bobcopeland.com>
In-Reply-To: <1242142227.4331.7.camel@johannes.local>
References: <200905120109.09906.chunkeey@web.de> <1242110389.3873.53.camel@johannes.local> <b6c5339f0905120829l4e78f71ep73e28d0e9118ed2e@mail.gmail.com> <1242142227.4331.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 12 May 2009 17:30:27 +0200, Johannes Berg wrote
> On Tue, 2009-05-12 at 11:29 -0400, Bob Copeland wrote:
> > Will pre-scan be called once per scan or once for every channel switch?
> > If the former, I think it's not the right place to flush.
> 
> The former.

Hmm, nevermind, it should work.  I was thinking of queued tx status 
work not being on the right channel, but I guess we don't do that for probe
requests.  And for ar9170 RX is processed synchronously as far as I can
tell.

-- 
Bob Copeland %% www.bobcopeland.com

