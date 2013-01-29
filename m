Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:65275 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2VzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:55:04 -0500
Message-ID: <51084528.2060502@opentechinstitute.org> (sfid-20130129_225507_510076_E6A6BA62)
Date: Tue, 29 Jan 2013 16:54:48 -0500
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>  <1355146824-25012-2-git-send-email-antonio@open-mesh.com>  <1356706268.9922.23.camel@jlt4.sipsolutions.net>  <20130102063255.GA27676@open-mesh.com>  <50E5F2A4.9080108@opentechinstitute.org> <1359150352.4655.29.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359150352.4655.29.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/25/2013 04:45 PM, Johannes Berg wrote:
> On Thu, 2013-01-03 at 16:05 -0500, Will Hawkins wrote:
>> Sorry for the delay responding!
> 
> Haha, 1.5 days. I win at delaying ;-(
> 
>>>> Anyway this part is really confusing. If userspace is handling
>>>> auth frames, should the kernel really mark the station as
>>>> authenticated? What then is the point in handling auth frames in
>>>> userspace??
>>>>
>>>> Will?
>>>
>>> Actually I don't know. Maybe Will can help us in understanding how
>>> to handle this point. I simply kept the same behaviour: before this
>>> (my) patch a station was marked as AUTHenticated in by the kernel,
>>> even if userspace registered for AUTH frames, and the same I'm
>>> doing here.
>>
>> It does *not* appear that Antonio's patch changes the logic that I put
>> in place with my earlier patch. For me, the userspace application
>> *authorizes* the station rather than *authenticates*. In other words,
>> no matter whether or not the userspace application is registered for
>> AUTH frames, the new station is assumed to be authenticated. Once the
>> two stations are authenticated the key exchange begins (over AUTH
>> frames) to determine if the stations are authorized.
>>
>> Johannes, what are your thoughts on the differences between the
>> semantics of authenticated and authorized. I am definitely in over my
>> head so please correct me where I've gone wrong. :-)
> 
> That makes sense, you handle the SAE authentication and then mark the
> station as authorized, which is perfectly fine. But that really mostly
> means you don't care about the authenticated state at all, and there's
> no real associated state anyway ...
> 
>> I would be okay with this approach. I think that it would be fairly
>> easy to essentially move the logic up a level and protect the
>> transition to AUTH rather than AUTHORIZED.
> 
> Well, you'd have to do both, and we also can't break the userspace API
> now.
> 
>>> This is a behaviour I introduced some time ago:
>>>
>>> 1153         sdata->u.ibss.control_port = params->control_port;
>>>
>>> which is set based on NL80211_ATTR_CONTROL_PORT and at the moment,
>>> in IBSS, I think it is only set by wpa_supplicant when using
>>> IBSS/RSN..you told me to use control_port instead of creating
>>> another member..but maybe it is general and could be used for
>>> something else?
> 
> It could be used for something else.
> 
>> The userspace application that I am writing does use the control port
>> in IBSS. My goal is to integrate my userspace application with
>> wpa_supplicant so eventually there will be convergence. In fact,
>> Antonio's new message is critical to this integration. :-)
> 
> That I don't understand? Why does it need the new event? Wouldn't
> completing the SAE handshake be sufficient information?

It does not need the new event, necessarily. I was just hoping to use
that event to know when to kick off the SAE handshake with a new node.
Something along the lines of NL80211_CMD_NEW_PEER_CANDIDATE in the world
of 802.11s.

With the code as it stands, I plan on using the NEW_STA event to start
that process, but I was hoping for something that would indicate the
station was authenticated (in case there was ever a time that we wanted
to layer SAE on top of explicit authentication).

Will

> 
> johannes
> 
> 
