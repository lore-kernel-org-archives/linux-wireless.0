Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35483 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaFLGV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 02:21:56 -0400
Received: by mail-ob0-f171.google.com with SMTP id nu7so843326obb.30
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 23:21:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwaxzyY+vqQa+vJETA_g+8zLmwWQb9uYhFOvTy57A15rw@mail.gmail.com>
References: <20140611230513.GC913@drone.musicnaut.iki.fi>
	<CACna6rwaxzyY+vqQa+vJETA_g+8zLmwWQb9uYhFOvTy57A15rw@mail.gmail.com>
Date: Thu, 12 Jun 2014 08:21:55 +0200
Message-ID: <CACna6rwjyiz0c791G4sJRGZoDLPTijfQeCeuD0PVgL0fvLtYBQ@mail.gmail.com> (sfid-20140612_082201_862479_7F59592E)
Subject: Re: Linux 3.15: WLAN regression on WRL54GL/B43?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2014 07:44, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 12 June 2014 01:05, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>> While testing the final 3.15, I noticed that "iwlist wlan0 scanning"
>> cannot find anything on my WRT54GL router anymore:
>
> I believe it's BCM5352E SoC wth G-PHY rev 7 and radio 0x2050 rev 2. Is
> that correct? Provide us a boot log.

I've reproduced this on my G-PHY rev 8. This is a bug caused by the:
status.freq = chanid + 2400;

It results in the:
[ 1500.651877] Got chanid:3 set freq:2403
[ 1500.719688] Got chanid:4 set freq:2404
[ 1500.788645] Got chanid:5 set freq:2405
[ 1500.857630] Got chanid:6 set freq:2406
[ 1500.936061] Got chanid:7 set freq:2407
[ 1500.973772] Got chanid:8 set freq:2408
[ 1501.084351] Got chanid:9 set freq:2409

I'll submit a fix.

-- 
Rafał
