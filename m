Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54701 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2EIPCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 11:02:33 -0400
Received: by bkcji2 with SMTP id ji2so371953bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 08:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FAA7CE4.1060609@candelatech.com>
References: <1336506821-23709-1-git-send-email-arik@wizery.com>
 <1336506821-23709-2-git-send-email-arik@wizery.com> <1336543867.4323.1.camel@jlt3.sipsolutions.net>
 <4FAA7CE4.1060609@candelatech.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 May 2012 18:02:16 +0300
Message-ID: <CA+XVXfcL=CgMZmtT=BqKBC7NHNkL9aE2EXmvtWK-yEfJojyTbg@mail.gmail.com> (sfid-20120509_170237_066084_957D446E)
Subject: Re: [PATCH 2/2] mac80211: allow low-level drivers to set netdev
 feature bits
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 9, 2012 at 5:19 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/08/2012 11:11 PM, Johannes Berg wrote:
>>
>> On Tue, 2012-05-08 at 22:53 +0300, Arik Nemtsov wrote:
>>>
>>> Allow low-level drivers to change the feature bit for a vif's underlying
>>> net_device struct.
>>
>>
>> What are you planning to use this for? I'm not really sure I see the
>> need for an exported function? Is it not going to just be set the same
>> for all interfaces?
>>
>> Out of the many netdev feature bits, we can handle maybe a handful in
>> mac80211, so I'm worried this API will suggest to people they can look
>> at netdev_features.h...
>
>
> If the regular ethtool api is implemented, we might could support
> some of the features like 'rx-all' that instruct the driver to
> pass (more) errored frames up the stack...
>
> But, I have no idea what the original poster was trying to accomplish.
>

We're trying to add support for HW checksum for a mac80211 based
driver. Johannes suggested to instead implement this as a field in
mac80211 that will be filled out by the lower driver. This values will
be checked against a white list and then propagated to all netdevs
belonging to this HW.

Arik
