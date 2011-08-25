Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53832 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1HYKFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 06:05:30 -0400
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/6] wl12xx: AP mode - don't regulate FW blocks for non-active STAs
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
	<1314265397-19873-2-git-send-email-arik@wizery.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 25 Aug 2011 13:05:28 +0300
In-Reply-To: <1314265397-19873-2-git-send-email-arik@wizery.com> (Arik Nemtsov's message of "Thu\, 25 Aug 2011 12\:43\:13 +0300")
Message-ID: <871uw9olg7.fsf@purkki.adurom.net> (sfid-20110825_120532_561945_306FE085)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> +	if (!wl1271_is_active_sta(wl, hlid)) {
> +		WARN_ON(1);
> +		return;
> +	}

I think this is neater:

if (WARN_ON(!wl1271_is_active_sta(wl, hlid))
        return;

-- 
Kalle Valo
