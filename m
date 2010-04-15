Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0DOOAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 10:00:13 -0400
Date: Thu, 15 Apr 2010 09:53:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wey-yi.w.guy@intel.com
Subject: Re: [PATCH v2 resend 1/3] mac80211: explicitly disable/enable QoS
Message-ID: <20100415135323.GB3020@tuxdriver.com>
References: <1271338982-3157-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271338982-3157-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 15, 2010 at 03:43:00PM +0200, Stanislaw Gruszka wrote:
> Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
> enable it explicitly when ->conf_tx method is called, and newer disable.
> Disabling is needed for some APs, which do not support QoS, such
> we should send QoS frames to them.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Sorry, I know I'm bad about not sending 'applied' messages.  But this
series is already in wireless-next-2.6 and wireless-testing...

commit 0af26b278bc1d747370b451595b7586cb7b3455c
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Mon Mar 29 12:18:36 2010 +0200

    mac80211: enable QoS explicitly in AP mode
    
    Enable QoS explicitly, when user space AP program will setup a QoS
    queues. Currently this is not needed as iwlwifi not work in AP mode
    and no other driver implement enable/disable QoS.
    
    Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit e61146e36b40fd9d346118c40285913236c329f3
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Mon Mar 29 12:18:35 2010 +0200

    iwlwifi: manage QoS by mac stack
    
    We activate/deactivate QoS and setup default queue parameters in iwlwifi
    driver. Mac stack do the same, so we do not need repeat that work here.
    Stack also will tell when disable QoS, this will fix driver when working
    with older APs, that do not have QoS implemented.
    
    Patch make "force = true" in iwl_active_qos() assuming we always want
    to do with QoS what mac stack wish.
    
    Patch also remove unused qos_cap bits, do not initialize qos_active = 0,
    as we have it initialized to zero by kzalloc.
    
    Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Mon Mar 29 12:18:34 2010 +0200

    mac80211: explicitly disable/enable QoS
    
    Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
    enable it explicitly when ->conf_tx method is called, and newer disable.
    Disabling is needed for some APs, which do not support QoS, such
    we should send QoS frames to them.
    
    Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
