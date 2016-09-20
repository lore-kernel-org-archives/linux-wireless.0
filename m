Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53185 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752737AbcITU5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 16:57:08 -0400
From: Lior David <liord@codeaurora.org>
Subject: Re: nl80211 fine timing measurement support
To: Luca Coelho <luca@coelho.fi>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
 <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
 <1474353599.5664.125.camel@coelho.fi>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
Message-ID: <b7022d3c-51ff-96eb-f6f0-319eb5ea66b0@codeaurora.org> (sfid-20160920_225712_279999_3318C694)
Date: Tue, 20 Sep 2016 23:57:02 +0300
MIME-Version: 1.0
In-Reply-To: <1474353599.5664.125.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/20/2016 9:39 AM, Luca Coelho wrote:
> On Mon, 2016-09-19 at 20:42 +0200, Arend Van Spriel wrote:
>>
>> On 19-9-2016 19:31, Lior David wrote:
>>>
>>> Hi Johannes,
>>>
>>> We are working on adding indoor location support to the wil6210
>>> 11ad driver. This includes fine timing measurement (FTM) as well as
>>> something we call angle of arrival (AOA) which measures azimuth and
>>> elevation.
>>> Initially we implemented it internally using vendor commands but we
>>> would like to upstream it using standard nl80211 API.
>>> I noticed a patch you sent some time ago (https://patchwork.kernel.
>>> org/patch/7790701/) for adding fine timing measurement support to
>>> nl80211, it looks like a good baseline though we do have few issues
>>> with it... However I did not see any comments or response on this
>>> patch. Can you please update if you plan on eventually submitting
>>> this patch?
>>
>> You can find several FTM related patches in backport-iwlwifi repo on
>> kernel.org. See link to git log of nl80211.h there [1].
> 
> We have a full FTM implementation in our internal tree (which is
> published in the URL Arend provided) and we are currently working on
> cleaning it up for upstream submission.  You should see patches from us
> this week.
>
That's great to hear, thanks :-)
I reviewed your FTM nl80211 API and have some comments. I can send these
comments once you send the cleaned up patch (most are small issues), but there
is one issue I would like to raise in advance:
In the measurement response you report the final calculated RTT (is this
for each burst or calculated from all bursts?). Our implementation
reports the raw measurement results (t1, t2, t3, t4 for each measurement
as well as TOD and TOA errors at responder and initiator as defined in IEEE
P802.11-REVmc/D7.0, 9.6.8.33). Reporting the final RTT does have benefits, so I
checked with our location framework developers. The general consensus is they
prefer to get the raw results, mainly because there are some useful analysis
algorithms they can run, and in addition the firmware may not be strong enough
to perform the calculations for deriving the final RTT (it could be done in the
driver but I don't think this is a proper place for it). Maybe we should
provide option for reporting both raw and RTT results where drivers can
support either or both?
For reference, we have also implemented FTM internally using vendor
commands. The vendor commands API that we defined can be seen at [1],
the actual implementation is still under internal review so not yet
published.

Thanks,
Lior

[1] http://w1.fi/cgit/hostap/commit/?id=fcd85d9a3f2d9d63d0fa57e93446ad467db75b23


> --
> Cheers,
> Luca.
> 
