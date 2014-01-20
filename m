Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34127 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaATVlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 16:41:24 -0500
Message-ID: <1390254081.13064.2.camel@porter.coelho.fi> (sfid-20140120_224127_293387_886AE0F6)
Subject: Re: [PATCH 6/7] mac80211: deny attempts at using chanctx during CSA
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 20 Jan 2014 23:41:21 +0200
In-Reply-To: <1390227670-19030-7-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-7-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> It was possible to connect STA when AP CSA was in
> progress which clearly was a bug.

I understand that preventing this simplifies things, but I don't think
it's a bug.  If the CSA process takes a long time (ie. several TBTTs),
why not let a new STA associate meanwhile? The new STA knows when to
switch, since it can see the count in the beacons (and probe_responses).

--
Luca.

