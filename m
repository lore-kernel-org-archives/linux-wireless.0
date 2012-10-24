Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62688 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2JXWEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 18:04:48 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so666076pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 15:04:48 -0700 (PDT)
Date: Wed, 24 Oct 2012 15:04:43 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
Message-ID: <20121024220443.GA6723@shredder> (sfid-20121025_000452_890024_5E63B3DD)
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
 <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
 <20121024194547.GA19060@shredder>
 <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 24, 2012 at 02:22:51PM -0700, Adrian Chadd wrote:
> Hi,
> 
> can you please repeat this experiment but dump the TSF32/TSF64 fields
> there as hexadecimal, rather than decimal?

Sure.

> I'd like to see if this is an example of "bad TSF32->TSF64 promotion".

Doesn't look like it:

[  147.074120] got beacon with ts         8CA003E9 from 00:03:7f:10:4e:1a at          477E063, now:          4746393. offset == 228560
[  147.086876] got beacon with ts          4A381D8 from 00:03:7f:10:4e:24 at          477E5D6, now:          474956B. offset == 217195
[  147.124375] got beacon with ts          4A38B4C from 00:03:7f:10:4d:d7 at          475A460, now:          47527D4. offset == 31884
[  148.122624] got beacon with ts          4B32FAB from 00:03:7f:10:4e:0c at          487DF1F, now:          48462A1. offset == 228478
[  148.152501] got beacon with ts          4B321F4 from 00:03:7f:10:4e:19 at          484D3A3, now:          484D750. offset == -941
[  149.003626] got beacon with ts          4556180 from 64:70:02:0a:4e:a8 at          491CF79, now:          491D38B. offset == -1042
[  150.159007] got beacon with ts          4D26D99 from 00:03:7f:10:4e:09 at          4A3EE9A, now:          4A37231. offset == 31849
[  150.480503] got beacon with ts         8D1D045B from 00:03:7f:10:4e:11 at          4AFD5EC, now:          4A859D7. offset == 490517
[  151.053502] got beacon with ts          474A653 from 64:70:02:0a:4e:a8 at          4B19427, now:          4B117C9. offset == 31838
[  151.171133] got beacon with ts         8CDE845F from 00:03:7f:10:4e:1a at          4B2DFC6, now:          4B2E32B. offset == -869
[  151.183751] got beacon with ts          4E20D1E from 00:03:7f:10:4e:24 at          4B2EF59, now:          4B3147D. offset == -9508
[  151.224256] got beacon with ts          4E217D8 from 00:03:7f:10:4d:d7 at          4B3AF3C, now:          4B3B2A9. offset == -877
[  151.248882] got beacon with ts          4E22473 from 00:03:7f:10:4e:2a at          4B78FA7, now:          4B412D9. offset == 228558
[  152.216627] got beacon with ts          4F1A579 from 00:03:7f:10:4e:0c at          4C2D336, now:          4C2D685. offset == -847
[  152.250129] got beacon with ts          4F1A5DE from 00:03:7f:10:4e:19 at          4C3D5DB, now:          4C3595D. offset == 31870
[  152.528127] got beacon with ts         8D3C41C7 from 00:03:7f:10:4e:11 at          4C793B6, now:          4C7971C. offset == -870
[  153.134004] got beacon with ts          6978669 from 00:03:7f:10:4d:f7 at          4D0D1EF, now:          4D0D575. offset == -902
[  153.220143] got beacon with ts         8CFDC6F1 from 00:03:7f:10:4e:1a at          4D3A2B7, now:          4D225DB. offset == 97500
[  154.256008] got beacon with ts          510EF18 from 00:03:7f:10:4e:09 at          4E1EE8D, now:          4E1F1E2. offset == -853
[  154.582264] got beacon with ts         8D5B9700 from 00:03:7f:10:4e:11 at          4E6E883, now:          4E6EC38. offset == -949
[  155.149631] got beacon with ts          4B32180 from 64:70:02:0a:4e:a8 at          4EF909C, now:          4EF9410. offset == -884
[  155.253254] got beacon with ts          5208441 from 00:03:7f:10:4d:e7 at          4F1A58F, now:          4F128C8. offset == 31943
[  155.267500] got beacon with ts         8D1D01C4 from 00:03:7f:10:4e:1a at          4F1D980, now:          4F15DC5. offset == 31675
[  155.280261] got beacon with ts          52082F1 from 00:03:7f:10:4e:24 at          4F1E0E7, now:          4F18FA5. offset == 20802

The TSF counter hasn't even wrapped 32 bits yet.

Thomas
