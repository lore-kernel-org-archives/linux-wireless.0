Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48587 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1I2RsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 13:48:08 -0400
Received: by vcbfk10 with SMTP id fk10so664459vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 10:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8468AF.8000006@neratec.com>
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>
 <1125417094.1836.1317285426615.JavaMail.root@idefix> <CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com>
 <4E8468AF.8000006@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 29 Sep 2011 10:47:48 -0700
Message-ID: <CAB=NE6UQpv1bvsni=rDP=3OKM=oN14g0xJtVN+evvm=47nZu_Q@mail.gmail.com> (sfid-20110929_194834_156833_2C76F6FF)
Subject: Re: Regulatory revamp status
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 5:46 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 09/29/2011 01:45 PM, Adrian Chadd wrote:
>> On 29 September 2011 16:37, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>> Thanks for the update.
>>>
>>> To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.
>>
>> There's some funny stuff in there.
>>
>> For example, some of the DFS bands have different CAC/NOL timing. :-)
>>
>>
>>
>> Adrian
>
> Really? Where would be 'there' countrycode-wise?
>
> That would definitely break today's CRDA capabilities :-\

Well, CRDA has no DFS support yet ;) and hence the regulatory revamp
work, to accommodate as much as possible for both future technologies
and capture all these gotchas on existing technologies. If DFS varies
so much then using one u8 for a country may not be enough, and we may
want to add a whole section for DFS with the u8 being an optional
minimum and with a DFS section for overrides on values. Thoughts?

That is -- if your country varies per band or CAC / NOL timings we can
address these countries only with the future revamp work. This would
allow us to move forward with DFS support only for those countries
where a unified DFS mapping applies.

  Luis
