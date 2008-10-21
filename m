Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59352 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYJUBmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 21:42:01 -0400
Received: by gxk9 with SMTP id 9so4793802gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 18:42:00 -0700 (PDT)
Message-ID: <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com> (sfid-20081021_034215_336649_A7EBD29E)
Date: Mon, 20 Oct 2008 18:42:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224552899.24677.245.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
	 <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 6:34 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-10-20 at 10:43 -0600, Marcel Holtmann wrote:
>> I do wanna keep it as simple as possible, but on the other hand we
>> should do a pretty decent job with picking a regulatory domain when no
>> userspace is present (old or CRDA missing).
>>
>> So my current thinking is that the regulatory hint for a card is limited
>> to the frequencies the card actually registers with mac80211. If the
>> internal card is 2.4 GHz, then we limit the hint to this. So the 5 GHz
>> band is still a virgin. If a 5 GHz card comes along and it is the first
>> in its band, then we take its regulatory hint for that band, but for the
>> 2.4 GHz band it has to follow the first cards hint.
>>
>> As I mentioned before, first card wins is a perfect solution from my
>> point of view, but we should not punish a second card in a different
>> band if the first card is not touching this band at all. And I can see
>> these user scenarios happening and in some cases they might be done on
>> purpose to serve every band with a different piece of hardware.
>>
>> And for the cases where new bands might be used in the future. In that
>> case we do have to do this right since userspace might be outdated. Lets
>> face it, we should always support a new kernel with an old userspace.
>> That is how the Linux kernel is suppose to work. That is probably the
>> only reason why wireless extensions are still around ;)
>>
>> The idea of having a 2.4 GHz only card provide a hint for 5 GHz is just
>> plain wrong. If the hardware is designed for 2.4 GHz it should not mess
>> with other frequencies.
>>
>> So my solution would be first regulatory hint in each band wins.
>>
>> Also we should have printk that shows up in dmesg in cases where neither
>> crda or iw modified the regulatory domain and we have clash with the
>> hints provided by two or more cards.
>
> I totally agree with you. IIRC, the current situation is nobody is
> willing to implement the per-band regulatory hints for such a rare but
> valid case. Luis, will you accept patches if somebody else write it?

What are you talking about? I wrote a patch for you. I just do not
agree with the approach anymore, you are trying to resolve an issue by
not fixing the real source to the problem.

  Luis
