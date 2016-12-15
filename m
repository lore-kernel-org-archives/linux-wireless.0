Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36591 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756810AbcLORY3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 12:24:29 -0500
Received: by mail-wm0-f65.google.com with SMTP id m203so7850997wma.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 09:24:16 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: add accounting for the extended peer statistics
Date: Thu, 15 Dec 2016 18:24:13 +0100
Message-ID: <2970240.ih558OrmaK@debian64> (sfid-20161215_182725_116913_1E110BB6)
In-Reply-To: <20161215164338.GB8030@atheros-ThinkPad-T61>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com> <20161215162659.GA8030@atheros-ThinkPad-T61> <20161215164338.GB8030@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Shafi,

On Thursday, December 15, 2016 10:13:39 PM CET Mohammed Shafi Shajakhan wrote:
> I am also thinking, as of now there is not much use in appending
> the extended peer stats (which gets periodically ) to the linked list
> '&ar->debug.fw_stats.peers_extd)'  and should we get rid of the below
> (and the required cleanup as well) 
> 
> list_splice_tail_init(&stats.peers_extd,
> 		&ar->debug.fw_stats.peers_extd);
> 
> 
> since rx_duration is getting updated periodically to the per sta
> information. Kindly let me know your thoughts about this.

Yes, of course. I see what your are trying to do and I think it's much better
to get rid of peers_extd and ath10k_fw_extd_stats_peers_free.

Regards,
Christian
