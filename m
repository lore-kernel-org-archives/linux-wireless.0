Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFB0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 14:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155FF2087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 14:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfCLOIN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfCLOIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 10:08:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E88ED307D874;
        Tue, 12 Mar 2019 14:08:12 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC0127C44;
        Tue, 12 Mar 2019 14:08:12 +0000 (UTC)
Date:   Tue, 12 Mar 2019 15:03:40 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mt76: fix schedule while atomic in mt76x02_reset_state
Message-ID: <20190312140339.GA5881@redhat.com>
References: <cover.1552309862.git.lorenzo@kernel.org>
 <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 12 Mar 2019 14:08:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 02:24:35PM +0100, Lorenzo Bianconi wrote:
> Fix following schedule while atomic in mt76x02_reset_state
> since synchronize_rcu is run inside a RCU section
> 
> [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> [44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
> [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
> [44036.944287] INFO: lockdep is turned off.
> [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
> [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
> [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> [44036.944308] Call Trace:
> [44036.944317]  dump_stack+0x67/0x90
> [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> [44036.944330]  synchronize_rcu+0x17/0x80
> [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> [44036.944355]  process_one_work+0x2a5/0x620
> [44036.944361]  worker_thread+0x35/0x3e0
> [44036.944368]  kthread+0x11c/0x140
> [44036.944376]  ret_from_fork+0x3a/0x50
> [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
> [44036.944387] INFO: lockdep is turned off.
> [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi

Does the patch fix the issue for you ? For me on my MT7612E device it
make the BUG warning gone, but instead of that I have total system hung
without any error message except information about hw restart.

[  174.425507] mt76x2e 0000:04:00.0: mac specific condition occurred
[  176.590750] mt76x2e 0000:04:00.0: MCU message 31 (seq 13) timed out
[  176.861345] mt76x2e 0000:04:00.0: Firmware Version: 0.0.00
[  176.867214] mt76x2e 0000:04:00.0: Build: 1
[  176.876563] mt76x2e 0000:04:00.0: Build Time: 201507311614____
[  176.908095] mt76x2e 0000:04:00.0: Firmware running!
[  176.920030] ieee80211 phy0: Hardware restart was requested

... hung at this point.  

This is with this fix and Felix's
[PATCH] mac80211: do not call driver wake_tx_queue op during reconfig
on latest nbd/wireless tree.

Stanislaw

