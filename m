Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:5842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab1FHLsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:48:54 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p58BmqGn001219
	for <linux-wireless@vger.kernel.org>; Wed, 8 Jun 2011 04:48:52 -0700
Received: from yxd5 (yxd5.prod.google.com [10.190.1.197])
	by wpaz37.hot.corp.google.com with ESMTP id p58BmI0S018394
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 8 Jun 2011 04:48:51 -0700
Received: by yxd5 with SMTP id 5so188717yxd.21
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 04:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307533479.3961.13.camel@jlt3.sipsolutions.net>
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	<1307530922.3961.4.camel@jlt3.sipsolutions.net>
	<BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com>
	<1307533479.3961.13.camel@jlt3.sipsolutions.net>
Date: Wed, 8 Jun 2011 04:48:51 -0700
Message-ID: <BANLkTikc-6hwZwT4Qt-dB-qBkwxEWLwrkg@mail.gmail.com> (sfid-20110608_134857_853461_6D682793)
Subject: Re: [RFC] cfg80211: Fix handling of previous_auth deauth
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 8, 2011 at 4:44 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> [you should send as text, the list won't accept html]
>
>>         Maybe I'm confused -- what's "this issue"?
>
>> Sorry.  I covered the issue in a previous post but it wasn't threaded
>> in.   Here's a summary:
>>
>>
>> If you read the IEEE docs just right, they say that if an AP believes
>> a STA is authenticated, but it receives an AUTH request, it should
>> send a DEAUTH downstream with PREV_AUTH_NOT_VALID.  Some APs actually
>> do this.  The STA and AP can fall out of sync, eg, if the STA reboots
>> unexpectedly.  What happens then is that the a mac80211 STA will send
>> an AUTH, and get a DEAUTH  which will clear authtry_bssess[].
>>  mac80211 keeps retrying, though, and the second time the AP sends a
>> successful AUTH response and marks the STA authenticated again.
>>  Meanwhile cfg80211 doesn't have any state in authtry_bsses[] for the
>> AP so it drops the successful reply on the floor.  Thus the state
>> mismatch perpetuates.
>
>
> Right, makes sense.
>
>>         It seems mac80211 shouldn't pass such up since it isn't
>>         actually
>>         connected. But then we just pass them up and rely on cfg80211
>>         to sort it
>>         out. Why do we even attempt to remove something from
>>         authtry_bsses when
>>         receiving a deauth frame? This only makes sense when we sent
>>         it
>>         ourselves and want to abort the authentication that way I
>>         guess?
>>
>> It's a little confusing to me that the same function is in charge of
>> outgoing and incoming packets, but yes, I see no point in removing
>> anything from authtry_bsses[] for a received DEAUTH since it is not
>> applicable.
>
> Yeah, indeed. Would not modifying authtry_bsses for a _received_ DEAUTH
> fix it?

Sure, it would.  How do I differentiate between received and
transmitted DEAUTH?  They seem to go through the same function, or
maybe I'm wrong.  Do I check the MAC in the mgmt header? :-)


> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
