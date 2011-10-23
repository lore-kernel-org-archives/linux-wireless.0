Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38125 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1JWPM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 11:12:56 -0400
Received: by bkbzt19 with SMTP id zt19so7067243bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 08:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffT6pq0bKZrVmrYDqustkTFt_ot99BPK_Q5JmXU3wE0iQ@mail.gmail.com>
References: <CA+XVXffT6pq0bKZrVmrYDqustkTFt_ot99BPK_Q5JmXU3wE0iQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 23 Oct 2011 17:12:40 +0200
Message-ID: <CA+XVXfcavXZPcz=DpAmHYbUcHbBZ1YuHehn96fs=ssjJh7pR-A@mail.gmail.com> (sfid-20111023_171300_122651_C7329BEA)
Subject: Re: lockdep in mac80211
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 19, 2011 at 00:12, Arik Nemtsov <arik@wizery.com> wrote:
> http://pastebin.com/qX3SLy2H
>
> This appears to be a legitimate lockdep (when trying to re-connect to
> an AP whose password I just changed).
> These take the locks in reverse order:
>
> ieee80211_work_work() -> ieee80211_authenticate() (Inlined in the
> lockdep print).
> ieee80211_sta_rx_queued_mgmt() -> ieee80211_rx_mgmt_disassoc()
>

Please disregard this one. The problem was with an internal patch I
was using for testing (as can be seen in the stack trace as well).

Arik
