Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:40046 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLPx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 10:53:59 -0500
Received: by yw-out-2324.google.com with SMTP id 5so394564ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 07:53:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <17a838c40902120456wb862200y8717a0d6a061b057@mail.gmail.com>
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
	 <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
	 <17a838c40902120456wb862200y8717a0d6a061b057@mail.gmail.com>
Date: Thu, 12 Feb 2009 07:53:57 -0800
Message-ID: <43e72e890902120753w44cab825i861d5c92c4816c61@mail.gmail.com> (sfid-20090212_165403_667927_4703D2D6)
Subject: Re: [ath9k-devel] Radar Detection and DFS status
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Alberto Pollastro <a.pollastro@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 4:56 AM, Alberto Pollastro
<a.pollastro@gmail.com> wrote:
> On Wed, Feb 11, 2009 at 10:41 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> mac80211 or ath9k does not yet have radar detection support so
>> therefore no mac80211 driver will allow you to use any beaconing mode
>> (AP | IBSS | Mesh) mode on DFS channels yet.
>>
>> Note that not all 5 GHz channels require radar detection though so you
>> could try using one of the non-DFS channels. Check 'iw list' for that.
>
> I've checked in regdb (2009.01.30) an it reports that I can use these
> frequencies (in Italy):
>
> country IT:
>    (2402 - 2482 @ 40), (N/A, 20)
>    (5170 - 5250 @ 40), (N/A, 20)
>    (5250 - 5330 @ 40), (N/A, 20), DFS
>    (5490 - 5710 @ 40), (N/A, 27), DFS
>
> I'm not sure, but in Italy the range 5170 - 5250 can be used only
> indoor. Are indoor/outdoor channels treated differently by mac80211
> and/or ath9k?

Yes, we have indoor and outdoor channel flags. You can supply a patch
or provide a reference to the regulatory information you are reading
to determine this and we can patch it up.

> Regarding 802.11h, is its development for beaconing modes scheduled?

I believe this will be worked on but we have no exact schedule.

  Luis
