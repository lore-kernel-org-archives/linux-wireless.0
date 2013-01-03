Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:51975 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3ACVF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 16:05:59 -0500
Message-ID: <50E5F2A4.9080108@opentechinstitute.org> (sfid-20130103_220603_559177_634228DA)
Date: Thu, 03 Jan 2013 16:05:40 -0500
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com> <1355146824-25012-2-git-send-email-antonio@open-mesh.com> <1356706268.9922.23.camel@jlt4.sipsolutions.net> <20130102063255.GA27676@open-mesh.com>
In-Reply-To: <20130102063255.GA27676@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry for the delay responding!

On 01/02/2013 01:32 AM, Antonio Quartulli wrote:
> Hi Johannes,
> 
> On Fri, Dec 28, 2012 at 03:51:08 +0100, Johannes Berg wrote:
>> Anyway this part is really confusing. If userspace is handling
>> auth frames, should the kernel really mark the station as
>> authenticated? What then is the point in handling auth frames in
>> userspace??
>> 
>> Will?
> 
> Actually I don't know. Maybe Will can help us in understanding how
> to handle this point. I simply kept the same behaviour: before this
> (my) patch a station was marked as AUTHenticated in by the kernel,
> even if userspace registered for AUTH frames, and the same I'm
> doing here.

It does *not* appear that Antonio's patch changes the logic that I put
in place with my earlier patch. For me, the userspace application
*authorizes* the station rather than *authenticates*. In other words,
no matter whether or not the userspace application is registered for
AUTH frames, the new station is assumed to be authenticated. Once the
two stations are authenticated the key exchange begins (over AUTH
frames) to determine if the stations are authorized.

Johannes, what are your thoughts on the differences between the
semantics of authenticated and authorized. I am definitely in over my
head so please correct me where I've gone wrong. :-)

> 
> 
>> 
>> Any chance we could converge on a single implementation here?
>> 
> 
> Maybe yes :)
> 
> I think that leaving the station not AUTHenticated and let
> userspace do so would be the best approach..but then we need a way
> to enable userspace to do it :)

I would be okay with this approach. I think that it would be fairly
easy to essentially move the logic up a level and protect the
transition to AUTH rather than AUTHORIZED.
> 
> 
>>> +static void ieee80211_ibss_auth_sta(struct sta_info *sta) +{ +
>>> if (sta->sta_state > IEEE80211_STA_NONE) +		return; + +
>>> sta_info_move_state(sta, IEEE80211_STA_AUTH); +
>>> sta_info_move_state(sta, IEEE80211_STA_ASSOC); +	/* authorize
>>> the station only if the network is not RSN protected. If +	 *
>>> not wait for the userspace to authorize it +	 */
>> 
>> technically, control_port != RSN protected, but I guess for IBSS
>> ... who's going to do WAPI? ;-)
> 
> This is a behaviour I introduced some time ago:
> 
> 1153         sdata->u.ibss.control_port = params->control_port;
> 
> which is set based on NL80211_ATTR_CONTROL_PORT and at the moment,
> in IBSS, I think it is only set by wpa_supplicant when using
> IBSS/RSN..you told me to use control_port instead of creating
> another member..but maybe it is general and could be used for
> something else?

The userspace application that I am writing does use the control port
in IBSS. My goal is to integrate my userspace application with
wpa_supplicant so eventually there will be convergence. In fact,
Antonio's new message is critical to this integration. :-)

> 
>> 
>>> +	cfg80211_ibss_sta(sta->sdata->dev, sta->sta.addr,
>>> GFP_KERNEL);
>> 
>> I'm not really convinced that this event is the right thing to
>> do.
>> 
>> If userspace is handing the auth frame, it already has the event
>> right there, no? It can even reply, even if for some reason it
>> can't send a negative reply because the kernel has already marked
>> the station as authenticated (see above).
>> 
> 
> Here I am missing something. To the best of knowledge,
> wpa_supplicant (which is the only userspace tool providing IBSS/RSN
> and it is not handling AUTH frames. Therefore it will not have any
> event for authentication..
> 

See above.

Thanks for everyone's great work! Happy New Year!

Will

>> If there's no userspace, then RSN can't work anyway, so maybe
>> this isn't really needed?
> 
> what we could do is to "move" the NEW_STA event and use it in this
> point. But I preferred to create a new event type in order to
> distinguish between the case of detecting a new station from the
> case of having a new station ready for key exchange.
> 
>> 
>> Also, a more generic event would make more sense I think?
>> 
> 
> You mean a generic event to be triggered on state change? Yes sure,
> but at the moment it was much more important to reshape the
> interaction between US and KS when using IBSS/RSN.
> 
>>> +	ieee80211_ibss_auth_expire(sdata);
>> 
>> It seems you should have something to trigger the timer too?
>> 
> 
> uhm? I don't understand. This function is invoked in
> ieee80211_sta_merge_ibss() which should be periodically called (if
> I got it correctly...the timer stuff in ibss is not really clear to
> me)
> 
> Thank you very much for your feedbacks! Happy new year :)
> 
> Cheers,
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ5fKkAAoJEIN2rhPI25sW4YsH/1xcWuX3u/6WV2tR1Ke/JfOn
bV1swDRU5F5MioBWTAQw2J6l7efogIIRAvaFC50HzU2P4hbEaCZclF0SQX9AcnjT
vDto/MXrRMfkUtzWAMZbjsa5sZzHQNXbh+fiLr/c1Exg99/2NPNRHSf5MNKhb1ck
iMsna5aJLNyR2Ey0Z7RcfL/U4eQv8JbVubpuTgmZZIH6BRV1t7+nS1b4lxs0yw7e
+JwLOpb9NnyA9+Wk2HSpfHNv5+6Nfeq6Ftj+ANqMLRUuryS+5+ujneE3pg609OEc
3LVdl0jUZ1OE2HjF5LcCzNwJLb3tPr/dfL0z5XyG6L2YFtWyYnycO+ixKOHczKw=
=b3Ot
-----END PGP SIGNATURE-----
