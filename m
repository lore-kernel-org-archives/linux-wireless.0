Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757277AbcK2Pcz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:32:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: wait for clear rxq when stopping mac
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161125111334.31085-1-anthony.romano@coreos.com>
References: <20161125111334.31085-1-anthony.romano@coreos.com>
To: Anthony Romano <anthony.romano@coreos.com>
Cc: linux-wireless@vger.kernel.org, kubakici@wp.pl
Message-Id: <20161129153254.A82C8612E7@smtp.codeaurora.org> (sfid-20161129_163258_286741_2636FDF4)
Date: Tue, 29 Nov 2016 15:32:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anthony Romano <anthony.romano@coreos.com> wrote:
> mt7601u_mac_stop_hw should stop polling the rxq once it remains empty
> but instead continues polling after the rxq status stays clear; bringing
> down the interface takes about six seconds from this alone.
> 
> Speed up path by exiting rxq loop once status repeatedly polls empty.
> 
> Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
> Reviewed-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

05db221e30a9 mt7601u: wait for clear rxq when stopping mac

-- 
https://patchwork.kernel.org/patch/9447371/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
