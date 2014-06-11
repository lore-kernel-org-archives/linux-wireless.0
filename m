Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:65449 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFKIzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:55:15 -0400
Received: by mail-la0-f48.google.com with SMTP id mc6so4662701lab.35
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:55:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJud-nmSp3gOxA+cPrZpv2Xgo_B9WeVcAnfkY1DSO_q_Q@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
 <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com>
 <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com> <CABPxzYJud-nmSp3gOxA+cPrZpv2Xgo_B9WeVcAnfkY1DSO_q_Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 11 Jun 2014 01:54:51 -0700
Message-ID: <CAB=NE6U-CaXEh7Mtd+BCNwY8QUGz2Ahc=-+_Zet9aoWDdNpevQ@mail.gmail.com> (sfid-20140611_105523_784183_D60C8C82)
Subject: Re: max_erip/tx_power not being set correctly
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: John Walker <john@x109.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:05 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Wed, Jun 11, 2014 at 3:28 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Sun, May 25, 2014 at 10:55 AM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>>> https://dev.openwrt.org/browser/trunk/package/kernel/mac80211/patches/005-make-genregdb.awk-skip-antenna-gain.patch?rev=40296
>>
>> This just ignores antenna gain as it was useless.
> That actually fixes the issue of setting tx power :-). In the new
> db.txt format there
> is tx power is not present, so the awk script parses the tx power as
> antenna gain.

Is this patch not upstream? Or do you mean that the db.txt format
causes an issue for 3.10 kernels which do not have this patch when the
internal regdb is used? If so that's a good corner case that I had not
considered -- the removal of the antenna gain for future releases of
db.txt obviously would have had an impact on older kernels with an awk
script expecting something different.

We need a solution for this and thanks for reporting this. Since we
have to support both for older kernels I think we will need to modify
the awk script to pick up on the differences... that's the only thing
I can think of. That or break the db.txt to not work with older
kernels, but we don't want that... Can you hack up a solution now that
I've identified the issue? Otherwise I can look at it soon.

 Luis
