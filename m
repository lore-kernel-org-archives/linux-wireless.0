Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FTN2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 09:28:46 -0400
Message-ID: <1340198923.4655.64.camel@jlt3.sipsolutions.net> (sfid-20120620_152849_306411_D1EC7FFC)
Subject: Re: [PATCH v4] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 15:28:43 +0200
In-Reply-To: <CAK80WHYa566m+K8TtRo6nvDQHd4J-1A5MD5y_N6_OJMVVnVMgA@mail.gmail.com>
References: <1340173975-13609-1-git-send-email-victorg@ti.com>
	 <1340180149.4655.23.camel@jlt3.sipsolutions.net>
	 <CAK80WHYa566m+K8TtRo6nvDQHd4J-1A5MD5y_N6_OJMVVnVMgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 16:22 +0300, Goldenshtein, Victor wrote:
> On Wed, Jun 20, 2012 at 11:15 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-06-20 at 09:32 +0300, Victor Goldenshtein wrote:
> >
> >> +     trace_drv_get_rssi(local, sdata);
> >> +     ret = local->ops->get_rssi(&local->hw, &sdata->vif, sta, rssi_dbm);
> >> +     trace_drv_return_int(local, ret);
> >
> > Where are you tracing the sta?
> >
> 
> We talked about print sta address with "local_sdata_addr_evt" event
> macro, the output looks like this:
> 
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |                     ||||       |         |
>               iw-1394  [000]        ...1  1083.713867: drv_get_rssi:
> phy0 vif:wlan0(2) addr:08:00:28:cc:65:43
>               iw-1394  [000]        ...1  1083.729736: drv_return_int: phy0 - 0

That's not the STA address, that's the VIF address.


> > And why not trace the value returned in *rssi_dbm?
> >
> 
> Is it really required ? there are various driver-ops which are "get
> stuff" without printing them in the tracer.

It'd be nice to fix all the ones, but I can't make you do that :-)

johannes


