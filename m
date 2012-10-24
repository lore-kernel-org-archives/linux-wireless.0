Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab2JXTpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 15:45:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1440818pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 12:45:52 -0700 (PDT)
Date: Wed, 24 Oct 2012 12:45:47 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
Message-ID: <20121024194547.GA19060@shredder> (sfid-20121024_214557_003453_E1E90070)
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
 <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

Thanks for your help.

On Mon, Oct 22, 2012 at 7:31 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> [snip]
>
>> The number after "at" is rx_status->mactime, "now" is drv_get_tsf(),
>> and offset (ie. stack delay) is mactime - tsf. RX_FLAG_MACTIME_MPDU
>> is on for all frames, and mesh sync is not adjusting the TSF.
>>
>> How can we possibly receive frames from the future!?
>>
>
> 1) Are you correctly merging the TSF32 values? Are you comparing TSF32
> to TSF64, are you converting 32->64, etc? TSF32 wraps pretty quickly
> and there's some kooky logic needed to make sure your TSF64 calculated
> value is correct.

It looks like the mactime reported by ath9k_htc already comes as a 64
bit value straight from the firmware in
(ath9k_htc_rx_status)->rs_timestamp. All variables involved are u64.

> 2) Are all your mesh nodes synchronised? Why don't you print out the
> timestamp inside the beacon frame as well, and compare whether they're
> all in reasonable sync?

I think the sync code currently just tries to account for clock drift.
Unfortunately this too is relying on an accurate mactime reading, so
bogus mactimes are interpreted as large clock drift :(

Some more output from a single peer:

[  721.451551] got beacon with ts 641025272 from 64:70:02:0a:4e:d1 at 651540784, now is: 651508959. offset == 31825
[  723.498926] got beacon with ts 643072384 from 64:70:02:0a:4e:d1 at 653784502, now is: 653556017. offset == 228485
[  725.547303] got beacon with ts 645120384 from 64:70:02:0a:4e:d1 at 655603123, now is: 655604082. offset == -959
[  731.692319] got beacon with ts 651264414 from 64:70:02:0a:4e:d1 at 661779913, now is: 661748125. offset == 31788
[  733.741433] got beacon with ts 653313270 from 64:70:02:0a:4e:d1 at 663795998, now is: 663796927. offset == -929
[  735.788803] got beacon with ts 655360384 from 64:70:02:0a:4e:d1 at 665843110, now is: 665843976. offset == -866
[  739.885435] got beacon with ts 659456384 from 64:70:02:0a:4e:d1 at 670037411, now is: 669939978. offset == 97433
[  741.933810] got beacon with ts 661504529 from 64:70:02:0a:4e:d1 at 671987247, now is: 671988032. offset == -785
[  746.030328] got beacon with ts 665600384 from 64:70:02:0a:4e:d1 at 676312473, now is: 676083906. offset == 228567
[  748.078714] got beacon with ts 667648384 from 64:70:02:0a:4e:d1 at 678163865, now is: 678131958. offset == 31907
[  752.187941] got beacon with ts 671756958 from 64:70:02:0a:4e:d1 at 682337969, now is: 682240565. offset == 97404
[  754.223820] got beacon with ts 673792384 from 64:70:02:0a:4e:d1 at 684307855, now is: 684276125. offset == 31730
[  756.271944] got beacon with ts 675840384 from 64:70:02:0a:4e:d1 at 686814606, now is: 686323937. offset == 490669
[  758.321077] got beacon with ts 677889131 from 64:70:02:0a:4e:d1 at 688371831, now is: 688372745. offset == -914
[  760.369198] got beacon with ts 679937030 from 64:70:02:0a:4e:d1 at 690419726, now is: 690420550. offset == -824
[  764.465200] got beacon with ts 684032384 from 64:70:02:0a:4e:d1 at 694547844, now is: 694515914. offset == 31930
[  766.513576] got beacon with ts 686080384 from 64:70:02:0a:4e:d1 at 696563073, now is: 696563975. offset == -902
[  768.561948] got beacon with ts 688128512 from 64:70:02:0a:4e:d1 at 698611198, now is: 698612029. offset == -831
[  772.658704] got beacon with ts 692224497 from 64:70:02:0a:4e:d1 at 702805482, now is: 702708141. offset == 97341

Again, offset here is "rx->mactime - drv_get_tsf()", which should never be
positive. Here are some interesting numbers:

[ 1234.229588] got beacon with ts 8429161802 from 00:03:7f:10:4d:d7 at 1164435178, now is: 1164207083. offset == 228095
[ 1234.247839] got beacon with ts 8429159489 from 00:03:7f:10:4e:2a at 1164224481, now is: 1164225454. offset == -973
[ 1234.556464] got beacon with ts 1181697231 from 00:03:7f:10:4d:f7 at 1164565957, now is: 1164534031. offset == 31926
[ 1234.587093] got beacon with ts 8429573388 from 00:03:7f:10:4e:24 at 1164563800, now is: 1164564649. offset == -849
[ 1234.637841] got beacon with ts 8429570178 from 00:03:7f:10:4d:d7 at 1164614178, now is: 1164615399. offset == -1221
[ 1234.962592] got beacon with ts 8429978558 from 00:03:7f:10:4e:31 at 1164939247, now is: 1164940096. offset == -849
[ 1234.992221] got beacon with ts 8429978502 from 00:03:7f:10:4e:24 at 1165984724, now is: 1164969719. offset == 1015005
[ 1235.046093] got beacon with ts 8429978601 from 00:03:7f:10:4d:d7 at 1165022604, now is: 1165023584. offset == -980

Notice rx->mactime is not always steadily increasing, but the "future" frames
have sudden jumps in time. Frames with more moderate offsets seem to follow a
regular pattern, though.

Thomas
