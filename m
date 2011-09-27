Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1154 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1I0VK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 17:10:26 -0400
Message-ID: <4E823BB5.6070206@broadcom.com> (sfid-20110927_231029_717762_8B40653C)
Date: Tue, 27 Sep 2011 23:10:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 24/26] staging: brcm80211: declared global vars
 in softmac phy as const
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317145530-18839-25-git-send-email-frankyl@broadcom.com>
 <4E82175A.7020504@lwfinger.net>
In-Reply-To: <4E82175A.7020504@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 08:35 PM, Larry Finger wrote:
> On 09/27/2011 12:45 PM, Franky Lin wrote:
>> From: Roland Vossen<rvossen@broadcom.com>
>>
>> Global variables are undesirable unless they are read only.
>>
>> Reported-by: Johannes Berg<johannes@sipsolutions.net>
>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>> Signed-off-by: Franky Lin<frankyl@broadcom.com>
>> ---
>>    drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   16 +-----
>>    drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   23 --------
>>    drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    6 +-
>>    drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   60 ++++++++++----------
>>    .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    2 +-
>>    5 files changed, 36 insertions(+), 71 deletions(-)
>>
>> diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>> index f9702c0..5b81480 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>> +++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
>> @@ -52,7 +52,7 @@ struct chan_info_basic {
>>    	u16 freq;
>>    };
>>
>> -static struct chan_info_basic chan_info_all[] = {
>> +static const struct chan_info_basic chan_info_all[] = {
>>    	{1, 2412},
>>    	{2, 2417},
>>    	{3, 2422},
> What are you doing?  You make this change here in patch 24, then undo it in #25,
> and redo it in #26! Are you guys actually thinking about what you are doing?

We reordered the patches a little to move the ones we got feedback about 
at the end for rework. My bet is that you see rebase at work although I 
agree this is pretty tricky. I am glad the net result is that the const 
qualifier is added. There was some thinking involved in what we did 
today ;-)

> This needs to be fixed. In addition, the next time you submit this patch bomb,
> change from V2 to V3. That is the standard way to handle resubmissions that are
> addressing comments, not by increasing some extra counter in the 00/XX cover
> patch. The VX notation helps the maintainer keep track of the patches as he
> knows to drop all the V2 ones when V3 arrives. Maintainers are precious and must
> be treated very carefully.

And here we were thinking we would have learned all tricks about 
submitting patches in our staging year ;-)

So to be sure I have it right: Only the cover letter should say: [PATCH 
v2 00/20] with the same headline as the orignal. Or should each patch 
say [PATCH v2 xx/20] even when there are 26 patches?

> Larry

It would not have hurt if the cover letter of this series would indicate 
it replaces the previous series by refering to its message-id. Would 
that be an alternative approach or just a good addition.

Gr. AvS

