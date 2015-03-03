Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54675 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbCCJIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:08:52 -0500
Message-ID: <1425373729.2450.14.camel@sipsolutions.net> (sfid-20150303_100856_573282_3FF5644A)
Subject: Re: [PATCH v2 1/2] cfg80211: add bss_type and privacy arguments in
 cfg80211_get_bss()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 03 Mar 2015 10:08:49 +0100
In-Reply-To: <1423403524-22540-2-git-send-email-dlansky@codeaurora.org>
References: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
	 <1423403524-22540-2-git-send-email-dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-02-08 at 15:52 +0200, Dedy Lansky wrote:
> Background: 802.11ad adds new network type (PBSS) and changes "capability"
> field interpretation for the DMG (60G) band.
> Same 2 bits that was interpreted as "ESS" and "IBSS", are re-used as
> 2-bit field with 3 valid values (and 1 reserved). Valid values are:
> "IBSS", "PBSS" (new) and "AP".
> 
> New enum added into cfg80211.h - ieee80211_bss_type with valid network types.
> When searching for particular network type in cfg80211_get_bss,
> "capa_mask" and "capa_val" would not work due to difference described above.
> Thus, need to decouple network type (bss_type) and handle it separately.
> 
> Remaining bits in "capa_mask" and "capa_val" are used only for PRIVACY matching
> so replace those two with privacy enum.

Applied, with minor changes.

johannes

