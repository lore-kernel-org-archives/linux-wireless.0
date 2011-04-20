Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56701 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab1DTRlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 13:41:47 -0400
Received: by mail-ew0-f44.google.com with SMTP id 19so453704ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 10:41:46 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: avoid premature elp entrance
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301785319-18777-1-git-send-email-eliad@wizery.com>
References: <1301785319-18777-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 20:44:13 +0300
Message-ID: <1303321453.1988.737.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-03 at 02:01 +0300, Eliad Peller wrote:
> The elp_work is being enqueued on wl1271_ps_elp_sleep, but doesn't get
> cancelled on wl1271_ps_elp_wakeup. This might cause immediate entrance
> to elp when the wl->mutex is being released, rather than using the delayed
> enqueueing optimization.
> 
> Cancel elp_work on wakeup request, and add a new WL1271_FLAG_ELP_REQUESTED
> flag to further synchronize the elp actions.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied with a couple of changes in some comments.  Thanks, Eliad, the
ELP man! :)

-- 
Cheers,
Luca.

