Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36485 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbcGSCQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 22:16:27 -0400
Received: by mail-pf0-f174.google.com with SMTP id h186so1917967pfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 19:16:27 -0700 (PDT)
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
To: Bob Copeland <me@bobcopeland.com>
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
 <20160713135021.GE7819@localhost>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <3ad771da-f4db-e29d-7b44-7e8a0865e3da@gmail.com> (sfid-20160719_041634_161472_8E7F0E5F)
Date: Tue, 19 Jul 2016 11:16:24 +0900
MIME-Version: 1.0
In-Reply-To: <20160713135021.GE7819@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年07月13日 22:50, Bob Copeland wrote:
>
> Hmm, my recollection on this stuff is a little fuzzy.  So we only get
> here if the peer sta is in doze state, but it shouldn't do that if we
> are in an MPSP.
Yes. In the MPSP, local peer only transmits frame when opposite peer is in
AWAKE. This patch expects we lost opposite peer accidentally
(AC adapter unplugged).

>    So, is the real problem that we don't wait for an ack
> from the peer before marking ourselves in a MPSP?
>
This patch does not fix starting MPSP, this patch fixes ending of MPSP.
Without this patch, local peer continues MPSP even if we lost opposite peer
accidentally.

