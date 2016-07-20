Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33386 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbcGTHLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 03:11:36 -0400
Received: by mail-pf0-f175.google.com with SMTP id y134so16163442pfg.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 00:11:36 -0700 (PDT)
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
To: Bob Copeland <me@bobcopeland.com>
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
 <20160713135021.GE7819@localhost>
 <3ad771da-f4db-e29d-7b44-7e8a0865e3da@gmail.com>
 <20160719104034.GB11996@localhost>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <1a324d4c-9a6b-1c0d-c18d-2df207de708c@gmail.com> (sfid-20160720_091139_615426_3783B856)
Date: Wed, 20 Jul 2016 16:11:33 +0900
MIME-Version: 1.0
In-Reply-To: <20160719104034.GB11996@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年07月19日 19:40, Bob Copeland wrote:
>
> OK, do we need to also clear WLAN_STA_PS_STA flag for the peer in
> ieee80211_mps_sta_status_update(), or does the node completely repeer?
>
> ISTR running into a problem where rebooted peer (previously in power-save)
> would send popen but we would buffer the response due to stale PS sta
> flag.
>
Thanks. I have tried your scenario.

I have disconnected remote peer by accidental shutdown.
(This means local peer does not recognize remote peer left.)

Then remote peer restarted and started to send Mesh Peering Open frames.

Local peer receives these frames but does not respond to these
because peer_lid mismatch.

After 3 times retrial, remote peer sent Mesh Peering Close frame
with reason code = 56(MESH-MAX-RETRIES).

And then, struct sta_info is freed and allocated.

So looks no problem.

