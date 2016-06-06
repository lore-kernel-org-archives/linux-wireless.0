Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36357 "EHLO
	mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbcFFC0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 22:26:30 -0400
Received: by mail-it0-f46.google.com with SMTP id f67so31955792ith.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2016 19:26:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160603165144.17356-2-toke@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-2-toke@toke.dk>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 6 Jun 2016 12:26:09 +1000
Message-ID: <CAGRGNgUpVrfAhH18JUA4ON=zk=dJ1wQ0dcPcBZEyzJDQFAtTrw@mail.gmail.com> (sfid-20160606_042634_528871_58B15AF6)
Subject: Re: [RFC/RFT 1/5] mac80211: skip netdev queue control with software queuing
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,

On Sat, Jun 4, 2016 at 2:51 AM, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
>
> Qdiscs are designed with no regard to 802.11
> aggregation requirements and hand out
> packet-by-packet with no guarantee they are
> destined to the same tid. This does more bad than
> good no matter how fairly a given qdisc may behave
> on an ethernet interface.
>
> Software queuing used per-AC netdev subqueue
> congestion control whenever a global AC limit was
> hit. This meant in practice a single station or
> tid queue could starve others rather easily. This
> could resonate with qdiscs in a bad way or could
> just end up with poor aggregation performance.
> Increasing the AC limit would increase induced
> latency which is also bad.
>
> Disabling qdiscs by default and performing
> taildrop instead of netdev subqueue congestion
> control on the other hand makes it possible for
> tid queues to fill up "in the meantime" while
> preventing stations starving each other.
>
> This increases aggregation opportunities and
> should allow software queuing based drivers
> achieve better performance by utilizing airtime
> more efficiently with big aggregates.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

As this patch is passing through your hands, you need to add your
Signed-off-by too.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
