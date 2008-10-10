Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:37760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYJJMpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 08:45:40 -0400
Received: by fg-out-1718.google.com with SMTP id 19so330145fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 05:45:38 -0700 (PDT)
Message-ID: <1ba2fa240810100545o79b70feay9c2da4fa6aa48a6b@mail.gmail.com> (sfid-20081010_144553_062453_E5F7D36E)
Date: Fri, 10 Oct 2008 14:45:38 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi TX reply bug
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223629897.3930.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223629897.3930.69.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>        sta_id = iwl_get_ra_sta_id(priv, hdr);
>        if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
>                IWL_ERROR("Station not known\n");
>                return;
>        }
>
>        if (txq->sched_retry) {
> [...]
>        } else {
> [...]
>                if (index != -1) {
>                    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
>                    if (tid != MAX_TID_COUNT)
>                        priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
> [...]
>
>
> priv->stations has 32 entries, IWL_INVALID_STATION is 255.

Don't see a problem this is what iwl_find_station returns if it cannot find
Anyhow I've rewritten the whole code, the patch is on the way.
Tomas
