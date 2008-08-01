Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:28121 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYHAIBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 04:01:14 -0400
Received: by fg-out-1718.google.com with SMTP id 19so464338fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 01:01:12 -0700 (PDT)
Message-ID: <4892C2CA.7010003@gmail.com> (sfid-20080801_100130_061165_22ACC60D)
Date: Fri, 01 Aug 2008 10:01:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: johannes@sipsolutions.net, akpm@linux-foundation.org,
	penberg@cs.helsinki.fi, tomasw@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
References: <20080801074014.GA3341@darkstar>
In-Reply-To: <20080801074014.GA3341@darkstar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Young napsal(a):
> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of sc->lock
> This casue the kernel stuck
> 
> Bug report please see:
> http://lkml.org/lkml/2008/7/29/32
> 
> Fixed it by remove the lock in sub routine "ath5k_beacon_update",
> The ath5k_config_interface is the only caller to it.
> 
> [  171.430207] =============================================
> [  171.432140] [ INFO: possible recursive locking detected ]
> [  171.433113] 2.6.27-rc1-smp #4
> [  171.434079] ---------------------------------------------
> [  171.435039] ath5k_pci/2447 is trying to acquire lock:
> [  171.435990]  (&sc->lock){--..}, at: [<f89ee9b5>] ath5k_config_interface+0xd5/0x340 [ath5k]
> [  171.437046] 
> [  171.437048] but task is already holding lock:
> [  171.438903]  (&sc->lock){--..}, at: [<f89ee91d>] ath5k_config_interface+0x3d/0x340 [ath5k]
> [  171.439953] 
> [  171.439954] other info that might help us debug this:
> [  171.441795] 3 locks held by ath5k_pci/2447:
> [  171.442729]  #0:  ((name)){--..}, at: [<c013a122>] run_workqueue+0x102/0x1d0
> [  171.443800]  #1:  (&(&local->scan_work)->work){--..}, at: [<c013a122>] run_workqueue+0x102/0x1d0
> [  171.444859]  #2:  (&sc->lock){--..}, at: [<f89ee91d>] ath5k_config_interface+0x3d/0x340 [ath5k]

Should be fixed already:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
