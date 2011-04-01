Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47652 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab1DAHxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 03:53:24 -0400
Received: by mail-wy0-f169.google.com with SMTP id 19so3196476wyf.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 00:53:22 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: rearrange some ELP wake_up/sleep calls
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300911735-27655-1-git-send-email-eliad@wizery.com>
References: <1300911735-27655-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 10:53:59 +0300
Message-ID: <1301644439.1988.412.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-23 at 22:22 +0200, Eliad Peller wrote:
> ELP (Extremely/Enhanced Low Power, or something like that ;)) refers to
> the powerstate of the 12xx chip, in which very low power is consumed,
> and no commands (from the host) can be issued until the chip is woken up.
> 
> Wakeup/sleep commands must be protected by a wl->mutex, so it's generally
> a good idea to call wakeup/sleep along with the mutex lock/unlock (where
> needed). However, in some places the wl12xx driver calls wakeup/sleep in
> some "inner" functions. This result in some "nested" wakeup/sleep calls
> which might end up letting the chip go to sleep prematurely (e.g. during
> event handling).
> 
> Fix it by rearranging the elp calls to come along with mutex_lock/unlock.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

