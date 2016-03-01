Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36779 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbcCAOFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 09:05:24 -0500
Received: by mail-wm0-f42.google.com with SMTP id n186so38503487wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 06:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456784940-32328-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456784940-32328-1-git-send-email-jouni@qca.qualcomm.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 1 Mar 2016 16:05:08 +0200
Message-ID: <CA+XVXferUH=Pa83-BoxC=b9grjpuYOgjXXzndxp1xELRzC-J-g@mail.gmail.com> (sfid-20160301_150530_602981_620445AD)
Subject: Re: [PATCH] mac80211: Fix Public Action frame RX in AP mode
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 1, 2016 at 12:29 AM, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> Public Action frames use special rules for how the BSSID field (Address
> 3) is set. A wildcard BSSID is used in cases where the transmitter and
> recipient are not members of the same BSS. As such, we need to accept
> Public Action frames with wildcard BSSID.
>
> Commit db8e17324553 ("mac80211: ignore frames between TDLS peers when
> operating as AP") added a rule that drops Action frames to TDLS-peers
> based on an Action frame having different DA (Address 1) and BSSID
> (Address 3) values. This is not correct since it misses the possibility
> of BSSID being a wildcard BSSID in which case the Address 1 would not
> necessarily match.
>
> Fix this by allowing mac80211 to accept wildcard BSSID in an Action
> frame when in AP mode.
>
> Fixes: db8e17324553 ("mac80211: ignore frames between TDLS peers when operating as AP")

Fix looks good (I'm the author of the bug) :)

Arik
