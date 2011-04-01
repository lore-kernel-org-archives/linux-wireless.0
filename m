Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:40550 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab1DAJIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 05:08:07 -0400
Received: by wyj26 with SMTP id 26so4098064wyj.39
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 02:08:03 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix roaming
From: Luciano Coelho <coelho@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301495759-22507-1-git-send-email-ohad@wizery.com>
References: <1301495759-22507-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 12:08:39 +0300
Message-ID: <1301648919.1988.446.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-30 at 16:35 +0200, Ohad Ben-Cohen wrote:
> The wl12xx device normally drops all frames coming from BSSID
> it is not joined with.
> 
> This behavior is configured today by the wl12xx driver in response
> to a handful of ieee80211_bss_change and ieee80211_conf_changed
> notification flags, such as BSS_CHANGED_ASSOC, BSS_CHANGED_BSSID,
> IEEE80211_CONF_CHANGE_IDLE, etc..
> 
> This breaks when we roam to a new BSSID, where authentication frames
> are sent before any BSS_CHANGED/CONF_CHANGED flags are received.
> When this happens the hardware silently drops the authentication
> responses, and the roaming fails.
> 
> Ideally this aggressive filtering behavior of the device should be disabled
> upon a notification from mac80211. Such notification will take place
> after multi-channel support will be added: mac80211 will likely send a
> remain-on-channel notification to drivers when entering sensitive
> states (like authentication), otherwise the firmware might jump to
> different channels (to serve a different role).
> 
> Until those notifications materialize, disable the hw BSSID filter
> when authentication requests are sent, so roaming would work.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Looks good!

Reviewed-by: Luciano Coelho <coelho@ti.com>

Applied to wl12xx.git.  Thanks!

-- 
Cheers,
Luca.

