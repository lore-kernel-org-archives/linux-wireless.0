Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51225 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaKZPGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 10:06:53 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so12810603wiw.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 07:06:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125193846.GJ25677@wotan.suse.de>
References: <1416754941-4439-1-git-send-email-arik@wizery.com> <20141125193846.GJ25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Nov 2014 17:06:37 +0200
Message-ID: <CA+XVXfdn52z88FZJdzE66-NKVUQ-vj1Wu0TGgq8FNjBVaYa9pA@mail.gmail.com> (sfid-20141126_160657_623426_A07A7B75)
Subject: Re: [PATCH v3 1/3] cfg80211: leave invalid channels on regdomain change
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 9:38 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Sun, Nov 23, 2014 at 05:02:19PM +0200, Arik Nemtsov wrote:
>> When the regulatory settings change, some channels might become invalid.
>> Disconnect interfaces acting on these channels, after giving userspace
>> code a grace period to leave them.
>>
>> This mode is currently opt-in, and not all interface operating modes are
>> supported for regulatory-enforcement checks. A wiphy that wishes to use
>> the new enforcement code must specify an appropriate regulatory flag,
>> and all its supported interface modes must be supported by the chekcing
>> code.
>
> This is all looking beter now, since I had a few requests for the last patch
> I'll ask for some other things here without asking  to negage the flag purpose
> as I originally wanted.
>
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> ---
>>  include/net/regulatory.h |   6 +++
>>  net/wireless/core.c      |  13 ++++++
>>  net/wireless/reg.c       | 106 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 124 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
>> index dad7ab2..701177c 100644
>> --- a/include/net/regulatory.h
>> +++ b/include/net/regulatory.h
>> @@ -136,6 +136,11 @@ struct regulatory_request {
>>   *      otherwise initiating radiation is not allowed. This will enable the
>>   *      relaxations enabled under the CFG80211_REG_RELAX_NO_IR configuration
>>   *      option
>> + * @REGULATORY_ENFORCE_CHANNELS: the regulatory core will make sure all
>> + *   interfaces on this wiphy reside on allowed channels. Upon a regdomain
>> + *   change, the interfaces are given a grace period to disconnect or move
>> + *   to an allowed channels. Interfaces on forbidden channels are forcibly
>> + *   disconnected.
>
> Please rename to REGULATORY_IGNORE_STALE_KICKOFF, also please add
> some information about the amount current of grace period used,
> and types of interfaces supported. Since this is a regulatory flag
> this information will help folks decide whether to enable or not.
> Also encourage its use, and mention that once all supported devices
> get support for this will be enabled by default. In the meantime
> I'd prefer if this feature was enabled by default if the supported
> interface types of a dveice match the white list of supported
> interfaces.

btw, I think you meant REGULATORY_STALE_KICKOFF, since it's an opt-in flag.

Arik
