Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41408 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZHaSAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 14:00:23 -0400
Date: Mon, 31 Aug 2009 13:59:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [RFC v2 0/5] orinoco: use cfg80211 for key manipulation
Message-ID: <20090831175932.GC5631@tuxdriver.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 01:04:08AM +0100, David Kilroy wrote:
> This series basically works (at least after the last patch is applied)
> with wpa_supplicant in wext mode.
> 
> I had tested with wpa_supplicant in nl80211 mode, but hadn't realised
> it wasn't using connect - I'll need to pick up Zhu Yis' patch and redo
> some testing.
> 
> Anyway, the nl80211 interface has a small hole which patch 5 partially
> papers over. I'm not that happy with the way it hijacks the AUTH/ASSOC
> state machine, but it works.
> 
> Other outstanding issues:
>  - It looks like I haven't quite got the connect_roamed callback right:
>    I've got a WARNING I need to investigate in my logs
>  - On disconnecting and reconnecting the card I have to restart
>    wpa_supplicant for things to work. I'm guessing I have to look at
>    driver shutdown, and ensure we send a disconnected event.
> 
> Dave.

Any word on this series?  Time is short for 2.6.32...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
