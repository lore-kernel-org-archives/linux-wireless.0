Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2GXOxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:53:14 -0400
Message-ID: <1343141586.4415.40.camel@jlt3.sipsolutions.net> (sfid-20120724_165318_068930_CF7E7928)
Subject: Re: [PATCH] wireless: reg: restore previous behaviour of
 chan->max_power calculations
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Hong Wu <Hong.Wu@dspg.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 24 Jul 2012 16:53:06 +0200
In-Reply-To: <20120724063538.GB2265@redhat.com> (sfid-20120724_083604_696318_C141BD9E)
References: <20120724063538.GB2265@redhat.com>
	 (sfid-20120724_083604_696318_C141BD9E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 08:35 +0200, Stanislaw Gruszka wrote:
> commit eccc068e8e84c8fe997115629925e0422a98e4de
> Author: Hong Wu <Hong.Wu@dspg.com>
> Date:   Wed Jan 11 20:33:39 2012 +0200
> 
>     wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit pow
> 
> changed the way we calculate chan->max_power as min(chan->max_power,
> chan->max_reg_power). That broke rt2x00 (and perhaps some other
> drivers) that do not set chan->max_power. It is not so easy to fix this
> problem correctly in rt2x00.
> 
> According to commit eccc068e8 changelog, change claim only to save
> maximum regulatory power - changing setting of chan->max_power was side
> effect. This patch restore previous calculations of chan->max_power and
> do not touch chan->max_reg_power.

Applied, but I'll wait for Luis's comments before I push it out.

johannes

