Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:43651 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753566Ab2DJKPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:15:48 -0400
Received: by lbao2 with SMTP id o2so2773371lba.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 03:15:45 -0700 (PDT)
Message-ID: <1334052882.10268.2.camel@cumari> (sfid-20120410_121552_229397_1C68F9D4)
Subject: Re: [PATCH] wl12xx: fix race between suspend/resume and recovery
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 13:14:42 +0300
In-Reply-To: <1331661801-17000-1-git-send-email-eyal@wizery.com>
References: <1331661801-17000-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-13 at 20:03 +0200, Eyal Shapira wrote: 
> The iteration on the wlvif list in wl1271_op_resume/suspend was
> perfomed before locking wl->mutex which would lead to a kernel
> panic in case a recovery was queued at the same time
> and would delete the wlvifs from the list.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Applied and pushed, thanks Eyal!

-- 
Cheers,
Luca.

