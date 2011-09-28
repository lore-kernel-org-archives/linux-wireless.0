Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50277 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1I1FMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 01:12:25 -0400
Received: by yib18 with SMTP id 18so5990762yib.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 22:12:24 -0700 (PDT)
Message-ID: <4E82ACB5.3000301@lwfinger.net> (sfid-20110928_071228_576163_BF24E7A2)
Date: Wed, 28 Sep 2011 00:12:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 24/26] staging: brcm80211: declared global vars in
 softmac phy as const
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com> <1317145530-18839-25-git-send-email-frankyl@broadcom.com> <4E82175A.7020504@lwfinger.net> <4E823BB5.6070206@broadcom.com>
In-Reply-To: <4E823BB5.6070206@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 04:10 PM, Arend van Spriel wrote:
> On 09/27/2011 08:35 PM, Larry Finger wrote:
>> On 09/27/2011 12:45 PM, Franky Lin wrote:
>>> From: Roland Vossen<rvossen@broadcom.com>
>>>
>>> Global variables are undesirable unless they are read only.
>>>
>>> Reported-by: Johannes Berg<johannes@sipsolutions.net>
>>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>>> Signed-off-by: Franky Lin<frankyl@broadcom.com>
>>> ---
>>> drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c | 16 +-----
>>> drivers/staging/brcm80211/brcmsmac/phy/phy_int.h | 23 --------
>>> drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c | 6 +-
>>> drivers/staging/brcm80211/brcmsmac/phy/phy_n.c | 60 ++++++++++----------
>>> .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c | 2 +-
>>> 5 files changed, 36 insertions(+), 71 deletions(-)
>>>
>>> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>>> b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>>> index f9702c0..5b81480 100644
>>> --- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>>> +++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>>> @@ -52,7 +52,7 @@ struct chan_info_basic {
>>> u16 freq;
>>> };
>>>
>>> -static struct chan_info_basic chan_info_all[] = {
>>> +static const struct chan_info_basic chan_info_all[] = {
>>> {1, 2412},
>>> {2, 2417},
>>> {3, 2422},
>> What are you doing? You make this change here in patch 24, then undo it in #25,
>> and redo it in #26! Are you guys actually thinking about what you are doing?
>
> We reordered the patches a little to move the ones we got feedback about at the
> end for rework. My bet is that you see rebase at work although I agree this is
> pretty tricky. I am glad the net result is that the const qualifier is added.
> There was some thinking involved in what we did today ;-)
>
>> This needs to be fixed. In addition, the next time you submit this patch bomb,
>> change from V2 to V3. That is the standard way to handle resubmissions that are
>> addressing comments, not by increasing some extra counter in the 00/XX cover
>> patch. The VX notation helps the maintainer keep track of the patches as he
>> knows to drop all the V2 ones when V3 arrives. Maintainers are precious and must
>> be treated very carefully.
>
> And here we were thinking we would have learned all tricks about submitting
> patches in our staging year ;-)
>
> So to be sure I have it right: Only the cover letter should say: [PATCH v2
> 00/20] with the same headline as the orignal. Or should each patch say [PATCH v2
> xx/20] even when there are 26 patches?

No, the number of patches should always be correct, but I would go to V2 even if 
there are a different number of patches in the series than there were with V1.

There are as many ways to do it as there are kernel hackers - perhaps more. The 
main thing is to make is absolutely clear to the maintainer and any possible 
reviewers what is happening. Make certain that the patch subject is unique and 
have the cover patch spell out what is happening in great detail. That material 
is never included with the git commit, so you can say anything.

It would be best if your brcmsmac and brcmfmac patches are clearly distinguished 
in the subject line. That was what tripped me. I saw V2 for soft mac and thought 
I had seen V2 already. I had, but it was for full mac.

> It would not have hurt if the cover letter of this series would indicate it
> replaces the previous series by refering to its message-id. Would that be an
> alternative approach or just a good addition.

That would be a good addition, but I would still keep the other description as well.

Larry
