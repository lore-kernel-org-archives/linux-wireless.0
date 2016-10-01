Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36250 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcJAJ4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Oct 2016 05:56:54 -0400
Received: by mail-wm0-f51.google.com with SMTP id k125so67124759wma.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2016 02:56:53 -0700 (PDT)
Subject: Re: nl80211 fine timing measurement support
To: Lior David <liord@codeaurora.org>, Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes@sipsolutions.net>
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
 <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
 <1474353599.5664.125.camel@coelho.fi>
 <b7022d3c-51ff-96eb-f6f0-319eb5ea66b0@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6b1f015b-2796-9821-25c6-d4d5070939c9@broadcom.com> (sfid-20161001_115736_696489_7E145B2D)
Date: Sat, 1 Oct 2016 11:56:51 +0200
MIME-Version: 1.0
In-Reply-To: <b7022d3c-51ff-96eb-f6f0-319eb5ea66b0@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-09-16 22:57, Lior David wrote:
> On 9/20/2016 9:39 AM, Luca Coelho wrote:
>> On Mon, 2016-09-19 at 20:42 +0200, Arend Van Spriel wrote:
>>>
>>> On 19-9-2016 19:31, Lior David wrote:
>>>>
>>>> Hi Johannes,
>>>>
>>>> We are working on adding indoor location support to the wil6210
>>>> 11ad driver. This includes fine timing measurement (FTM) as well as
>>>> something we call angle of arrival (AOA) which measures azimuth and
>>>> elevation.
>>>> Initially we implemented it internally using vendor commands but we
>>>> would like to upstream it using standard nl80211 API.
>>>> I noticed a patch you sent some time ago (https://patchwork.kernel.
>>>> org/patch/7790701/) for adding fine timing measurement support to
>>>> nl80211, it looks like a good baseline though we do have few issues
>>>> with it... However I did not see any comments or response on this
>>>> patch. Can you please update if you plan on eventually submitting
>>>> this patch?
>>>
>>> You can find several FTM related patches in backport-iwlwifi repo on
>>> kernel.org. See link to git log of nl80211.h there [1].
>>
>> We have a full FTM implementation in our internal tree (which is
>> published in the URL Arend provided) and we are currently working on
>> cleaning it up for upstream submission.  You should see patches from us
>> this week.
>>
> That's great to hear, thanks :-)
> I reviewed your FTM nl80211 API and have some comments. I can send these
> comments once you send the cleaned up patch (most are small issues), but there
> is one issue I would like to raise in advance:
> In the measurement response you report the final calculated RTT (is this
> for each burst or calculated from all bursts?). Our implementation
> reports the raw measurement results (t1, t2, t3, t4 for each measurement
> as well as TOD and TOA errors at responder and initiator as defined in IEEE
> P802.11-REVmc/D7.0, 9.6.8.33). Reporting the final RTT does have benefits, so I
> checked with our location framework developers. The general consensus is they
> prefer to get the raw results, mainly because there are some useful analysis
> algorithms they can run, and in addition the firmware may not be strong enough
> to perform the calculations for deriving the final RTT (it could be done in the
> driver but I don't think this is a proper place for it). Maybe we should
> provide option for reporting both raw and RTT results where drivers can
> support either or both?

If raw results are mainly used for analysis algorithms how about
providing raw measurement data through debugfs. May even consider adding
rtt calculation in cfg80211/mac80211 for drivers that choose to provide
raw measurement data and still only report final RTT in nl80211 api.

Regards,
Arend

> For reference, we have also implemented FTM internally using vendor
> commands. The vendor commands API that we defined can be seen at [1],
> the actual implementation is still under internal review so not yet
> published.
> 
> Thanks,
> Lior
> 
> [1] http://w1.fi/cgit/hostap/commit/?id=fcd85d9a3f2d9d63d0fa57e93446ad467db75b23
> 
> 
>> --
>> Cheers,
>> Luca.
>>
