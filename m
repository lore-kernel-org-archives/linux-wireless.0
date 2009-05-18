Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59283 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbZERPxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:53:14 -0400
Received: by gxk10 with SMTP id 10so6403869gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 08:53:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905141928.11794.onelektra@gmx.net>
References: <200905141928.11794.onelektra@gmx.net>
Date: Mon, 18 May 2009 11:53:15 -0400
Message-ID: <b6c5339f0905180853l695c0fa1o6560077d73988291@mail.gmail.com>
Subject: Re: ath5k from compat-wireless-2009-05-14 fails to perform IBSS merge
From: Bob Copeland <me@bobcopeland.com>
To: elektra <onelektra@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 1:28 PM, elektra <onelektra@gmx.net> wrote:
> Hi!

Thanks for the report -- I can replicate this here.  Usually IBSS
merge happens on second or third try.

> May 14 18:35:46 901 kernel:  [<f85baa2b>]
> ath5k_beacon_update_timers+0x30b/0x360 [ath5k]

This must be WARN_ON(!intval), for some reason beacon interval
is zero in this path.

-- 
Bob Copeland %% www.bobcopeland.com
