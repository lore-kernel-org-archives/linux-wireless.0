Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48127 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaFKLFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 07:05:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 132FA280896
	for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 12:57:34 +0200 (CEST)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com [209.85.216.54])
	by arrakis.dune.hu (Postfix) with ESMTPSA id F1DED286F2B
	for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 12:57:31 +0200 (CEST)
Received: by mail-qa0-f54.google.com with SMTP id v10so1104271qac.27
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 03:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U-CaXEh7Mtd+BCNwY8QUGz2Ahc=-+_Zet9aoWDdNpevQ@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
 <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com>
 <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com>
 <CABPxzYJud-nmSp3gOxA+cPrZpv2Xgo_B9WeVcAnfkY1DSO_q_Q@mail.gmail.com> <CAB=NE6U-CaXEh7Mtd+BCNwY8QUGz2Ahc=-+_Zet9aoWDdNpevQ@mail.gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 11 Jun 2014 12:58:50 +0200
Message-ID: <CAOiHx==mZ9ezmMQfRTiJ9EmCH4utqgDWW8_=1rvMDiFK1Sj3PQ@mail.gmail.com> (sfid-20140611_130526_989622_F4CA5F3A)
Subject: Re: max_erip/tx_power not being set correctly
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	John Walker <john@x109.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 10:54 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 10:05 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Wed, Jun 11, 2014 at 3:28 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> On Sun, May 25, 2014 at 10:55 AM, Krishna Chaitanya
>>> <chaitanya.mgit@gmail.com> wrote:
>>>> https://dev.openwrt.org/browser/trunk/package/kernel/mac80211/patches/005-make-genregdb.awk-skip-antenna-gain.patch?rev=40296
>>>
>>> This just ignores antenna gain as it was useless.
>> That actually fixes the issue of setting tx power :-). In the new
>> db.txt format there
>> is tx power is not present, so the awk script parses the tx power as
>> antenna gain.
>
> Is this patch not upstream?

This patch is not upstream. You only posted it as an RFC, not a PATCH,
so it was likely never applied for that reason. Note that this patch
is from you ;-)

 Or do you mean that the db.txt format
> causes an issue for 3.10 kernels which do not have this patch when the
> internal regdb is used? If so that's a good corner case that I had not
> considered -- the removal of the antenna gain for future releases of
> db.txt obviously would have had an impact on older kernels with an awk
> script expecting something different.

AFAICT, this has been an issue for any kernel (even current linus'
master) using the internal regdb since antenna gain was dropped from
regdb.txt.


Regards
Jonas
