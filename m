Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:51143 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMKLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 05:11:21 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so1737731lab.12
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 02:11:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgV1EeZ9Qz995wTqs6CnKmbhu1OTob3_k1h4mKYW1Oh7tw@mail.gmail.com>
References: <1420642040-4530-1-git-send-email-arik@wizery.com>
 <1420642040-4530-2-git-send-email-arik@wizery.com> <CAGRGNgV1EeZ9Qz995wTqs6CnKmbhu1OTob3_k1h4mKYW1Oh7tw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 13 Jan 2015 12:11:04 +0200
Message-ID: <CA+XVXfdyxCm2-2rfPCmye7AF5VxHeWzWLPKHi3jej23rAHCb2A@mail.gmail.com> (sfid-20150113_111126_477906_84646363)
Subject: Re: [PATCH v2 2/2] cfg80211: avoid reg-hints in self-managed only systems
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2015 at 6:26 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Arik,
>
> On Thu, Jan 8, 2015 at 1:47 AM, Arik Nemtsov <arik@wizery.com> wrote:
>> When a system contains only self-managed regulatory devices all hints
>> from the regulatory core are ignored. Stop hint processing early in this
>> case. These systems usually don't have CRDA deployed, which results in
>> endless (irrelevent) logs of the form:
>> cfg80211: Calling CRDA to update world regulatory domain
>>
>> Make sure there's at least one self-managed device before discarding a
>> hint, in order to prevent initial hints from disappearing on CRDA
>> managed systems.
>>
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> ---
>>  net/wireless/reg.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 521f3a4..588e45f 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -2120,6 +2120,26 @@ out_free:
>>         reg_free_request(reg_request);
>>  }
>>
>> +static bool reg_only_self_managed_wiphys(void)
>> +{
>> +       struct cfg80211_registered_device *rdev;
>> +       struct wiphy *wiphy;
>> +       bool self_managed_found = false;
>> +
>> +       ASSERT_RTNL();
>
> Would it make sense to quickly return false here if the list is empty
> rather than the whole mess with the new variable?

I'm thinking the "mess" isn't really such a mess - are you expecting a
real performance hit?

Also this is a corner case - you won't really get regulatory updates
when no network cards are presents. You only get a single update to
the core.

Arik
