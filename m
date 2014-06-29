Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49818 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaF2PXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 11:23:17 -0400
Received: by mail-pd0-f169.google.com with SMTP id g10so6848377pdj.14
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 08:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140629104318.GA32230@w1.fi>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
 <1402496307-32522-5-git-send-email-arik@wizery.com> <20140629104318.GA32230@w1.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 29 Jun 2014 18:23:01 +0300
Message-ID: <CA+XVXfeZNbTiMwid4bBX5Ft4Pz-FjDz7jwLkJqsf2FSY8YkvgQ@mail.gmail.com> (sfid-20140629_172437_485969_DE28942D)
Subject: Re: [PATCH 05/10] mac80211: use TDLS initiator in tdls_mgmt operations
To: Jouni Malinen <j@w1.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 29, 2014 at 1:43 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Jun 11, 2014 at 05:18:22PM +0300, Arik Nemtsov wrote:
>> The TDLS initiator is set once during link setup. If determines the
>> address ordering in the link identifier IE.
>> Use the value from userspace in order to have a correct teardown packet.
>> With the current code, a teardown from the responder side fails the TDLS
>> MIC check because of a bad link identifier IE.
>
> This series, and in particular, this patch, seems to break number of
> TDLS use cases (well, almost all use of TDLS) with "old" user space
> tools. This should be fixed or reverted until the changes are in state
> that avoid such breaking of the old user interface. We cannot assume
> that everyone will be updating kernel and wpa_supplicant in sync.
>
> I would recommend running through full mac80211_hwsim test cases from
> hostap.git when doing any changes to existing nl80211
> commands/attributes or how they are used.

Well I have to say I didn't really consider mac80211 TDLS
functionality "ready for prime time" when I've discovered this bug.
It's something pretty basic.
The breakage of older userspace was semi-deliberate here.

But your logic is sound. If you consider this important, we can fix this.

>
>> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
>> @@ -242,27 +243,42 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
>> -     /* the TDLS link IE is always added last */
>> +     /* sanity check for initiator */
>
> These sanity checks do not work with old user space since initiator will
> be hardcoded to false for those cases.
>
>>       switch (action_code) {
>>       case WLAN_TDLS_SETUP_REQUEST:
>>       case WLAN_TDLS_SETUP_CONFIRM:
>> -     case WLAN_TDLS_TEARDOWN:
>>       case WLAN_TDLS_DISCOVERY_REQUEST:
>> -             /* we are the initiator */
>> -             ieee80211_tdls_add_link_ie(skb, sdata->vif.addr, peer,
>> -                                        sdata->u.mgd.bssid);
>> +             if (!initiator) {
>> +                     ret = -EINVAL;
>> +                     goto fail;
>> +             }
>
> This will reject all new request frames unless user space tools are
> modified to add NL80211_ATTR_TDLS_INITIATOR.
>
> For most of these, it should be possible to set initiator based on
> action_code if the attribute had been designed to support backwards
> compatibility, but it wasn't, i.e., there is no way of knowing whether
> the user space is aware of this new attribute since it is a flag
> attribute. For example, an u32 encoding an enum that indicates whether
> the device is the initiator would have allowed cfg80211 to figure out on
> its own which role the device is in if the new attribute is not
> included.
>
> Is it already too late to change the nl80211 attribute since this hit
> wireless-testing.git? I was about to commit wpa_supplicant changes to
> start using this new attribute, but I don't think I'll do it now to
> avoid getting any actual users added for this until the kernel side
> design gets fixed to address existing user space behavior.

We can just put a patch on top of mac80211 to remove the sanity
testing of "initiator" and just act as if it's false when we can't
infer the value (as before). That would leave the wpa_s patch as is.
I don't see any value in changing the nl80211 to something other than
a flag, if you don't want old userspace to fail anyway..

>
>
> PS.
>
> This location and patch is not the only one that breaks TDLS tests.
> 'mac80211: make sure TDLS peer STA exists during setup' is also breaking
> things at least for special test functionality (e.g.,
> ap_wpa2_tdls_bssid_mismatch and ap_wpa2_tdls_concurrent_init). I'm not
> sure what to do about those, though.

Actually Johannes asked for that one :) But I'm not sure this patch is
the culprit, makes more sense for this:
17e6a59 mac80211: cleanup TDLS state during failed setup

I'll take a look.

Arik
