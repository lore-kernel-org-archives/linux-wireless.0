Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33753 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbeBPACc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 19:02:32 -0500
Received: by mail-io0-f176.google.com with SMTP id n7so2561327iob.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2018 16:02:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180215151445.52e08b03@cakuba.netronome.com>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
 <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
 <20180215151445.52e08b03@cakuba.netronome.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Fri, 16 Feb 2018 01:02:31 +0100
Message-ID: <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com> (sfid-20180216_010236_289401_497E8EB7)
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 15 Feb 2018 23:59:24 +0100, Lorenzo Bianconi wrote:
>> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
>> to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
>> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
>> with a different write operation on the same register.
>> Moreover move write trace point in __mt7601u_vendor_single_wr
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> Could you provide an example of which accesses make it problematic?
> Is this fixing an actual bug?

Hi Jakub,

it is not an issue I had experimented, I noticed a theoretical race
reviewing the code.
AFAIU, based on the current implementation it is possible that mt7601u_rmw
(with mt7601u_rr) loads data from given register but its store access
(mt7601u_wr) is
preceded by another mt7601u_wr on the same register. In this case the
value configured by
the first mt7601u_wr executed is overwritten by the second one (the
store from mt7601u_rmw)
even if the first write is setting a different subfield respect to mt7601u_rmw.

Regards,
Lorenzo
