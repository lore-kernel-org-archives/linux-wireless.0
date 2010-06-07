Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0FGQwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 12:52:24 -0400
Subject: Re: [PATCH] mac80211: Add netif state checking to
 ieee80211_ifa_changed
From: reinette chatre <reinette.chatre@intel.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275897132-10932-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1275897132-10932-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 09:52:23 -0700
Message-ID: <1275929543.1835.8674.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

On Mon, 2010-06-07 at 00:52 -0700, Juuso Oikarinen wrote:
> There's a window for ieee80211_ifa_changed() to get called whilst the
> managed mode mutex has not been initialized when opening and stopping the
> interface. Currently this causes a kernel BUG like the following:
> 
> [  132.460013] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:380!
> [  132.460013] invalid opcode: 0000 [#1] SMP
> 
> The mutex is initialized during open(), hence once netif_running() is true,
> the mutex should be valid. Fix by adding a netif_running() check to the
> function.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Thank you very much. I've been running with this patch for more than ten
iterations of my testing and I have not encountered this issue again.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


