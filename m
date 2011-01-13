Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53161 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972Ab1AMLd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 06:33:26 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0DBXQTM001142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Jan 2011 05:33:26 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0DBXPpf001784
	for <linux-wireless@vger.kernel.org>; Thu, 13 Jan 2011 05:33:25 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0DBXPFZ000438
	for <linux-wireless@vger.kernel.org>; Thu, 13 Jan 2011 05:33:25 -0600 (CST)
Subject: Re: [PATCH] wl12xx: lock the RCU when accessing sta via
 ieee80211_find_sta()
From: Luciano Coelho <coelho@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "DE CESCO, Jonathan" <jonathanc@ti.com>
In-Reply-To: <1294769241-3118-1-git-send-email-coelho@ti.com>
References: <1294769241-3118-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:33:45 +0200
Message-ID: <1294918425.2064.21.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 19:07 +0100, coelho@ti.com wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> We were calling ieee80211_find_sta() and the sta returned by it
> without locking the RCU, which is required by mac80211.
> 
> Fix this and reorganize slightly the area of the code where the sta is
> used.
> 
> Reported-by: Jonathan DE CESCO <jonathanc@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied and pushed to wl12xx.

-- 
Cheers,
Luca.

