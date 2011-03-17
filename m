Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60888 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1CQFif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 01:38:35 -0400
Subject: Re: [PATCH] wl12xx: set the actual tid instead of the ac
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1300309434-15491-1-git-send-email-eliad@wizery.com>
References: <1300309434-15491-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 07:38:26 +0200
Message-ID: <1300340306.11073.5784.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 23:03 +0200, ext Eliad Peller wrote:
> When passing a tx frame, the driver incorrectly set desc->tid
> with the ac instead of the actual tid.
> 
> It has some serious implications when using 802.11n + QoS,
> as the fw starts a BlockAck with the wrong tid (which finally
> cause beacon loss and disconnection / some fw crash)
> 
> Fix it by using the actual tid stored in skb->priority.

How will the firmware handle the TIDs larger than 3, as currently to the
firmware it appears only TID's 0-3 are configured, and the rest are
whatever values happen to be there default?

-Juuso



