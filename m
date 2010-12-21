Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47632 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0LUMn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 07:43:59 -0500
Received: by iwn9 with SMTP id 9so4149234iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 04:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292928823.3563.4.camel@jlt3.sipsolutions.net>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <1292864555-28661-4-git-send-email-lrodriguez@atheros.com> <1292928823.3563.4.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 21 Dec 2010 07:43:39 -0500
Message-ID: <AANLkTinAp-w4ywaVqTBrkLDfjBSAgnw1OK21_TNVqDP2@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfg80211: pass DFS region to drivers through reg_notifier()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 21, 2010 at 5:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:
>> This grants drivers access to the DFS region that a
>> regulatory domain belongs to.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  include/net/regulatory.h |    5 +++++
>>  net/wireless/reg.c       |    4 ++++
>>  2 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
>> index 9fcb603..3ed16c5 100644
>> --- a/include/net/regulatory.h
>> +++ b/include/net/regulatory.h
>> @@ -40,6 +40,10 @@ enum environment_cap {
>>   *   99 - built by driver but a specific alpha2 cannot be determined
>>   *   98 - result of an intersection between two regulatory domains
>>   *   97 - regulatory domain has not yet been configured
>> + * @dfs_region: If CRDA responded with a regulatory domain that requires
>> + *   DFS master operation on a known DFS region (NL80211_CFLAG_DFS_*),
>> + *   dfs_region represents that region. Drivers can use this and the
>> + *   @alpha2 to adjust their device's DFS parameters as they wish.
>
> The alpha2 is pretty useless -- I don't think you should advocate using
> it. I think it can even be "99" or something at this point.

The alpha2 here is for the request, not what is set though.

  Luis
