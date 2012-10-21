Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:60978 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab2JUClS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 22:41:18 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so822601dak.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2012 19:41:18 -0700 (PDT)
Date: Sat, 20 Oct 2012 19:41:14 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath9k_htc and reported mactime
Message-ID: <20121021024114.GA9558@shredder> (sfid-20121021_044121_866069_84D89759)
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

re-sending non-HTML to l-w.

Hi list,
 
We're seeing some issue with reported mactime by the ath9k_htc (AR9271)
card. Here is a mesh node sampling peer beacons:
 
[  327.928774] got beacon from 00:03:7f:10:4e:1a at 80969926, now is: 80940131. offset == 29795
[  329.716530] got beacon from 64:70:02:0a:4e:a8 at 82824946, now is: 82727604. offset == 97342
[  329.974276] got beacon from 00:03:7f:10:4d:f7 at 83082820, now is: 82985314. offset == 97506
[  329.977528] got beacon from 00:03:7f:10:4e:1a at 83084622, now is: 82988562. offset == 96060
[  331.764782] got beacon from 64:70:02:0a:4e:a8 at 84774638, now is: 84775531. offset == -893
[  332.022278] got beacon from 00:03:7f:10:4e:1a at 85064980, now is: 85033000. offset == 31980
[  332.025529] got beacon from 00:03:7f:10:4d:f7 at 85033451, now is: 85036249. offset == -2798
[  333.814536] got beacon from 64:70:02:0a:4e:a8 at 86824159, now is: 86824975. offset == -816
[  334.260908] got beacon from 00:03:7f:10:4e:11 at 87270487, now is: 87271277. offset == -790
[  335.861412] got beacon from 64:70:02:0a:4e:a8 at 89100008, now is: 88871534. offset == 228474
[  336.119176] got beacon from 00:03:7f:10:4d:f7 at 89128456, now is: 89129238. offset == -782
[  336.308535] got beacon from 00:03:7f:10:4e:11 at 89317801, now is: 89318590. offset == -789
[  337.909662] got beacon from 64:70:02:0a:4e:a8 at 90951396, now is: 90919468. offset == 31928
[  338.168034] got beacon from 00:03:7f:10:4e:1a at 91209720, now is: 91177797. offset == 31923
[  338.171285] got beacon from 00:03:7f:10:4d:f7 at 91211047, now is: 91181053. offset == 29994
[  338.356286] got beacon from 00:03:7f:10:4e:11 at 91463481, now is: 91366022. offset == 97459
[  338.734784] got beacon from f8:d1:11:65:92:e4 at 91743653, now is: 91744461. offset == -808
[  339.958041] got beacon from 64:70:02:0a:4e:a8 at 92966623, now is: 92967531. offset == -908
[  340.217914] got beacon from 00:03:7f:10:4d:f7 at 93226490, now is: 93227356. offset == -866
[  340.408290] got beacon from 00:03:7f:10:4e:11 at 93449578, now is: 93417704. offset == 31874
[  342.006291] got beacon from 64:70:02:0a:4e:a8 at 95014620, now is: 95015461. offset == -841
[  342.264413] got beacon from 00:03:7f:10:4e:1a at 95272637, now is: 95273538. offset == -901
[  342.453286] got beacon from 00:03:7f:10:4e:11 at 95461607, now is: 95462386. offset == -779
[  342.833168] got beacon from f8:d1:11:65:92:e4 at 95939657, now is: 95842204. offset == 97453

The number after "at" is rx_status->mactime, "now" is drv_get_tsf(), and
offset (ie. stack delay) is mactime - tsf. RX_FLAG_MACTIME_MPDU is on for
all frames, and mesh sync is not adjusting the TSF.

How can we possibly receive frames from the future!?

Thanks in advance,
Thomas
