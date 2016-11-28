Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42240 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933063AbcK1OeO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:34:14 -0500
Message-ID: <1480343646.29540.20.camel@coelho.fi> (sfid-20161128_153433_680136_480B27DB)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Mon, 28 Nov 2016 16:34:06 +0200
In-Reply-To: <1480342821.8107.44.camel@sipsolutions.net>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
         <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
         <ee0072cd-83b8-1264-d792-bcf4ce1a8940@broadcom.com>
         (sfid-20161127_215109_122180_ADB0DD12) <1480342821.8107.44.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] cfg80211: Add support to sched scan to report
 better BSSs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-28 at 15:20 +0100, Johannes Berg wrote:
> > It seems there has already
> > been taken a shot at this which may be used/extended [1].
> > 
> 
> That's a good point - it's somewhat similar.
> 
> This is obviously a different context - offloaded BSS selection vs.
> scheduled scan (for host BSS selection), but perhaps the attribute &
> definitions could be reused?

Yes, similar but not quite the same.  The existing case is for finding
BSSs that are worth waking the host up for (while disconnected), so it
needs to be better than the RSSI passed (absolute number).  Now this is
about relative RSSI as compared to the current connection, so
RELATIVE_RSSI is different than RSSI and I think the same attribute
should not be used, to avoid confusion.

--
Luca.
