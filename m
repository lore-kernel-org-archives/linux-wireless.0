Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:47843 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYFUMYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 08:24:53 -0400
Received: by an-out-0708.google.com with SMTP id d40so383588and.103
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2008 05:24:52 -0700 (PDT)
Message-ID: <43e72e890806210524j73068c15qf8694bed8a6ecbc9@mail.gmail.com> (sfid-20080621_142455_834134_42FA70FB)
Date: Sat, 21 Jun 2008 17:54:52 +0530
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Let drivers have access to TKIP key offets for TX and RX MIC
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214049613.8967.243.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080621115133.GI17936@ruslug.rutgers.edu>
	 <1214049613.8967.243.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 21, 2008 at 5:30 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-06-21 at 07:51 -0400, Luis R. Rodriguez wrote:
>> Some drivers may want to to use the TKIP key offsets for TX and RX
>> MIC so lets move this out.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  include/net/cfg80211.h |    5 +++++
>>  net/mac80211/key.h     |   37 ++++++++++++-------------------------
>>  2 files changed, 17 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index e007508..6cb8b02 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -12,6 +12,11 @@
>>   * Copyright 2006, 2007      Johannes Berg <johannes@sipsolutions.net>
>>   */
>>
>> +/* Starting offsets for each key for TKIP */
>> +#define ALG_TKIP_TEMP_ENCR_KEY               0
>> +#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY        16
>> +#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY        24
>
> put it into nl80211 and give it proper namespace prefixes, please.

OK

>> -/* ALG_TKIP
>> - * struct ieee80211_key::key is encoded as a 256-bit (32 byte) data block:
>> - * Temporal Encryption Key (128 bits)
>> - * Temporal Authenticator Tx MIC Key (64 bits)
>> - * Temporal Authenticator Rx MIC Key (64 bits)
>> - */
>
> and why remove the comment? There's a small comment in nl80211.h but it
> could be described in more detail.

ieee80211_key::key is wrong, it should be ieee80211_key_conf::key,
I'll try to clear this up in a few places and how we follow this to
keep the same format as that received by nl80211.

  Luis
