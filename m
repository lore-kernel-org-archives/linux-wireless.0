Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:63501 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaFKKYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:24:18 -0400
Received: by mail-qa0-f54.google.com with SMTP id v10so1062630qac.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 03:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VwBB-_G6JfLo81PYsjxBbw+C4Y40ZogNh4-eG910rXuw@mail.gmail.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com>
	<CALhHN=rzHzSr67W9KoC8u5cARrckOgQA-m26fmhXwX85aEcKoA@mail.gmail.com>
	<CAB=NE6VwBB-_G6JfLo81PYsjxBbw+C4Y40ZogNh4-eG910rXuw@mail.gmail.com>
Date: Wed, 11 Jun 2014 12:24:17 +0200
Message-ID: <CALhHN=pTSRC=k8-Rx3xFQT3b+tydnDMRiSHB4goC50KyZOxwbg@mail.gmail.com> (sfid-20140611_122421_905458_DCC8022C)
Subject: Re: [RFC 1/2] crda: simplify text parsing for country/rules
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2014 10:49, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 10:03 PM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> On 11 June 2014 00:09, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>>> On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
>>> <janusz.dziedzic@tieto.com> wrote:
>>>> Remove strange parsers.
>>>>
>>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>>
>>> Did you test this with the different types of accepted rules?
>>>
>>
>> Tested with current db.txt (+AUTO-BW in some cases).
>
> I was curious more about the different use cases of the output power,
> sometimes we use dBm, sometimes mW I think. I think I tried your
> approach and ended up getting inconsistent results for the different
> cases, so that's why all the parser junk got added. If you found a way
> to successfully get rid of it though that's awesome, just want to be
> sure we tested all cases. I purposely tried to upkeep the output to
> match the input preference, some folks are picky about mW and others
> like dB, this helps with regulatory rules as they vary depending on
> the country and the country typically uses one or the other for the
> definitions.
>

As a required I assume:
"\t(%f - %f @ %f), (%f mW)" or
"\t(%f - %f @ %f), (%f)"
Rest are optional.

This is the code for eirp:

       /* Next get eirp */
       strsep(&line_p, ",");
       if (!line_p) {
               fprintf(stderr, "not found eirp in line: %s\n", line);
               return -EINVAL;
        }

       if (strstr(line_p, "mW")) {
               hits = sscanf(line_p, " (%f mW)", &max_eirp);
               if (hits != 1)
                       return -EINVAL;
               reg_rule->power_rule.max_eirp =
                       REGLIB_MW_TO_MBM(max_eirp);
       } else {
               hits = sscanf(line_p, " (%f)", &max_eirp);
               if (hits != 1)
                       return -EINVAL;
               reg_rule->power_rule.max_eirp =
                       REGLIB_DBM_TO_MBM(max_eirp);
       }


I see DE have mW (input and db2rd output):

db.txt input
country DE: DFS-ETSI
        # entries 279004 and 280006
        (2400 - 2483.5 @ 40), (100 mW)
        # entry 303005, 304002 and 305002
        (5150 - 5350 @ 80), (100 mW), NO-OUTDOOR
        # entries 308002, 309001 and 310003
        (5470 - 5725 @ 80), (500 mW), DFS
        # 60 gHz band channels 1-4, ref: Etsi En 302 567
        (57240 - 65880 @ 2160), (40), NO-OUTDOOR

db2rd < db.txt output
country DE: DFS-ETSI
        (2400.000 - 2483.500 @ 40.000), (20.00)
        (5150.000 - 5350.000 @ 80.000), (20.00), NO-OUTDOOR
        (5470.000 - 5725.000 @ 80.000), (26.98), DFS
        (57240.000 - 65880.000 @ 2160.000), (40.00), NO-OUTDOOR

Do you remember some cases where this couldn't work?

BR
Janusz
