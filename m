Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2K1NIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:08:09 -0500
Message-ID: <1354108113.9345.23.camel@jlt4.sipsolutions.net> (sfid-20121128_140813_228134_854E0011)
Subject: Re: [PATCH] mac80211: fix for mesh sync to indicate TBTT adjustment
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com, ashok@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 14:08:33 +0100
In-Reply-To: <1353702198-12865-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353702198-12865-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:23 -0800, Marco Porsch wrote:
> Currently the mesh sync code checks, whether peers indicate TBTT adjustment,
> but it never sets the corresponding flag itself.
> 
> By setting ifmsh->tbtt_adjusting to true, it will set the corresponding field
> in the mesh configuration IE of own beacons.
> This indication will be set in the current beacon. The TBTT adjustment will be
> performed afterwards, affecting the next beacon. Thus, the first beacon with
> stable TBTT will not indicate adjustment anymore and peers will continue
> tracking the new offset.

Ping mesh folks, does this look sane?

johannes

