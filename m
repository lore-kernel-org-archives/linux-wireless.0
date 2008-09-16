Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:9086 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYIPAEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 20:04:24 -0400
Received: by yw-out-2324.google.com with SMTP id 9so733583ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 17:04:22 -0700 (PDT)
Message-ID: <43e72e890809151704s252f6189tf711c700ee829760@mail.gmail.com> (sfid-20080916_020427_404323_A62D7D99)
Date: Mon, 15 Sep 2008 17:04:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: Re: [RFC] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809151624g3540f308r90808e281b22314e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
	 <43e72e890809151555u3a79bd89h763fa0a6ba07e752@mail.gmail.com>
	 <43e72e890809151624g3540f308r90808e281b22314e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 4:24 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

So the problem with ath9k is we report only 1 ampdu queue and when we
try to map tid 6 to a queue we cannot do it as we already have one for
tid 0 with the ap.

[ 9653.596135] Open BA session requested for 00:03:7f:0c:e0:bc tid 6
[ 9653.596146] BA request denied - queue unavailable for tid 6
[ 9653.688091] Open BA session requested for 00:03:7f:0c:e0:bc tid 6
[ 9653.688095] BA request denied - queue unavailable for tid 6

If I up the "ampdu" queues to >= 2 on ath9k I then am able to allocate
more TID sessions to more "ampdu queues". But my results are pretty
horrible:

[  5] local 192.168.1.5 port 5001 connected with 192.168.1.11 port 52651
[  5]  0.0- 1.0 sec  1.99 MBytes  16.7 Mbits/sec
[  5]  1.0- 2.0 sec  2.63 MBytes  22.0 Mbits/sec
[  5]  2.0- 3.0 sec  1.26 MBytes  10.6 Mbits/sec
[  5]  3.0- 4.0 sec    740 KBytes  6.06 Mbits/sec
[  5]  4.0- 5.0 sec  1.48 MBytes  12.4 Mbits/sec
[  5]  5.0- 6.0 sec  1.57 MBytes  13.2 Mbits/sec
[  5]  6.0- 7.0 sec  2.78 MBytes  23.3 Mbits/sec
[  5]  7.0- 8.0 sec    250 KBytes  2.05 Mbits/sec
[  5]  8.0- 9.0 sec  2.00 MBytes  16.8 Mbits/sec
[  5]  9.0-10.0 sec  1.80 MBytes  15.1 Mbits/sec
[  5]  0.0-10.4 sec  16.7 MBytes  13.5 Mbits/sec

Something is up...

  Luis
