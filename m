Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39460 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab2AZPu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:50:56 -0500
Received: by mail-ww0-f41.google.com with SMTP id dt11so158958wgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 07:50:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201261510.18387.chunkeey@googlemail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-10-git-send-email-victorg@ti.com>
	<201201261510.18387.chunkeey@googlemail.com>
Date: Thu, 26 Jan 2012 17:50:54 +0200
Message-ID: <CAK80WHYT==LYjK+99eYVNzHx9c+sSw7BRULfj4pctLzawrhRug@mail.gmail.com> (sfid-20120126_165059_970666_2CBBE15A)
Subject: Re: [RFC 9/9] mac80211: add DFS support to monitor interface
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 4:10 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
>
> Hey, that's great!
>
> I have one question: Wasn't the monitor interface [for AP mode] being
> rendered obsolete by Johannes cfg80211-internal-ap-mlme work? If so,
> then we could save us the work here, right?

Yep, you're right.

> BTW, what about cfg80211_can_beacon_sec_chan in net/wireless/chan.c?
> I think it needs to be updated or else we can't have HT40 [secondary
> channels] on frequencies which require DFS.

DFS is not supported with HT40 in this initial release, updating the
cfg80211_can_beacon_sec_chan is not enough, we should also check that
there is no radar interference on the secondary channel (if it's a
radar channel).

-- 
Thanks,
Victor.
