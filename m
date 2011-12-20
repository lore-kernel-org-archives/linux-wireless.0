Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39722 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab1LTUvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:51:23 -0500
Received: by mail-lpp01m010-f54.google.com with SMTP id l5so5006004lah.27
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 12:51:22 -0800 (PST)
Subject: Re: [PATCH] wl12xx: mark no sched scan only after FW event
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324385738-3132-1-git-send-email-eyal@wizery.com>
References: <1324385738-3132-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 22:51:18 +0200
Message-ID: <1324414278.2182.76.camel@cumari> (sfid-20111220_215126_775361_8E145C1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 14:55 +0200, Eyal Shapira wrote: 
> stop sched scan isn't an immediate operation
> and we need to wait for PERIODIC_SCAN_COMPLETE_EVENT_ID
> after sending a stop before changing internal state
> and notifying upper layers.
> Not doing this caused problems when canceling an existing sched
> scan and immediately requesting to start a new one
> with a different configuration as the FW was still
> in the middle of the previous sched scan.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

