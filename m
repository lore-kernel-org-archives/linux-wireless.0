Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46116 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbAMKl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 05:41:28 -0500
Received: by mail-qc0-f182.google.com with SMTP id r5so1495727qcx.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 02:41:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfe1te8k1Em5_z5uO92EHj5jE8EGrQn8N7DyieVt33pq6g@mail.gmail.com>
References: <1420642040-4530-1-git-send-email-arik@wizery.com>
 <1420642040-4530-2-git-send-email-arik@wizery.com> <CAGRGNgV1EeZ9Qz995wTqs6CnKmbhu1OTob3_k1h4mKYW1Oh7tw@mail.gmail.com>
 <CA+XVXfdyxCm2-2rfPCmye7AF5VxHeWzWLPKHi3jej23rAHCb2A@mail.gmail.com>
 <CAGRGNgVb2Roq51dooFeboha_UxOHx4+hGJypyxuvRb_8ka-ZfA@mail.gmail.com> <CA+XVXfe1te8k1Em5_z5uO92EHj5jE8EGrQn8N7DyieVt33pq6g@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Jan 2015 21:41:07 +1100
Message-ID: <CAGRGNgX+O0aYAgWEQfxwkGo=-xobSEPJrgtKJM71JDWWG54rRg@mail.gmail.com> (sfid-20150113_114131_858743_D51CBD29)
Subject: Re: [PATCH v2 2/2] cfg80211: avoid reg-hints in self-managed only systems
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

On Tue, Jan 13, 2015 at 9:35 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Jan 13, 2015 at 12:30 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Arik,
>>
>> On Tue, Jan 13, 2015 at 9:11 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> On Tue, Jan 13, 2015 at 6:26 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>>> Hi Arik,
>>>>
>>>> On Thu, Jan 8, 2015 at 1:47 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>>>> When a system contains only self-managed regulatory devices all hints
>>>>> from the regulatory core are ignored. Stop hint processing early in this
>>>>> case. These systems usually don't have CRDA deployed, which results in
>>>>> endless (irrelevent) logs of the form:
>>>>> cfg80211: Calling CRDA to update world regulatory domain
>>>>>
>>>>> Make sure there's at least one self-managed device before discarding a
>>>>> hint, in order to prevent initial hints from disappearing on CRDA
>>>>> managed systems.
>>>>>
>>>>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>>>>> ---
>>>>>  net/wireless/reg.c | 25 +++++++++++++++++++++++++
>>>>>  1 file changed, 25 insertions(+)
>>>>>
>>>>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>>>>> index 521f3a4..588e45f 100644
>>>>> --- a/net/wireless/reg.c
>>>>> +++ b/net/wireless/reg.c
>>>>> @@ -2120,6 +2120,26 @@ out_free:
>>>>>         reg_free_request(reg_request);
>>>>>  }
>>>>>
>>>>> +static bool reg_only_self_managed_wiphys(void)
>>>>> +{
>>>>> +       struct cfg80211_registered_device *rdev;
>>>>> +       struct wiphy *wiphy;
>>>>> +       bool self_managed_found = false;
>>>>> +
>>>>> +       ASSERT_RTNL();
>>>>
>>>> Would it make sense to quickly return false here if the list is empty
>>>> rather than the whole mess with the new variable?
>>>
>>> I'm thinking the "mess" isn't really such a mess - are you expecting a
>>> real performance hit?
>>
>> Personally, purely for readability, I prefer the style of checking and
>> returning as early as possible.
>
> Actually I thought readability was on my side - wanted to point out
> the shorter version of the code is more legible.
> I guess it's a matter of personal taste :)

Indeed it is.

In terms of length, your version is a variable definition and two
lines in the internal if statement. Mine is a blank line and two lines
in a separate if statement. (Assuming the condition doesn't run over
80 chars)

>> Arguably doing it my way trades speed for memory efficiency and your
>> way trades memory efficiency for speed, but it's so small (and this is
>> so far from a hot path) that there's no real argument either way
>> whatsoever.
>
> Agree it doesn't matter for these reasons.

At the end of the day, it's a stalemate for a lot of reasons. You
prefer this way, it's your code, so leave it as it is. I apologise for
the noise =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
