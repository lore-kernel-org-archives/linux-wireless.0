Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:47115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIZXZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 19:25:44 -0400
Received: by fg-out-1718.google.com with SMTP id 19so792722fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 16:25:42 -0700 (PDT)
Message-ID: <1ba2fa240809261625g1f403c4fxaadb4887d642ae90@mail.gmail.com> (sfid-20080927_012549_738879_E33F79E6)
Date: Sat, 27 Sep 2008 02:25:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com, hmh@hmh.eng.br,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <200809262018.40777.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com>
	 <1222426905.10563.100.camel@johannes.berg>
	 <200809262018.40777.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > That's definitely other option we wanted to suggest that mac80211
>> > would register itself to rfkill subsystem and will provide to driver
>> > appropriate callbacks.  The question is how  drivers vary in the rfkil
>> > implementation and whether it wouldn't be more complex, in that case
>> > the notification is quite clean solution.
>>
>> How complex does it have to be?

> Not really, probably it only needs to be a wrapper around rfkill_force_state
> where we can use the RFKILL_ defines to indicate the BLOCKED status.

Implementation wise it's more complicated since you have to teach each
driver under mac80211, this mean more
code and more bugs but I'm not sure this is the objective on this list
:) As opposite to just notifying mac about a rfkill
event so it's not trying to configure to access device, etc.

>> > > That means that the only change needed in ieee80211_ioctl_siwtxpower() is
>> > > only allowing the enabling of the radio when RFKILL is not set to BLOCKED.
>> >
>> > That's just complicates everything and moving the policy  decisions to
>> > the driver after all even
>> > form txpower off you implement it as soft rfkill.
>
> Why does it complicate things? It means that mac80211 doesn't use
> rfkill_force_state() when the user triggers a radio state change using
> iw/iwconfig/ifconfig or whatever userspace tool.

I'm not sure I understand your intention, how do you plane to kill
radio then in this case, you are still to obliged to do so.

> mac80211 doesn't generate rfkill events because it isn't tied to any device
> keys/buttons/sliders. That is what the drivers do. And they should only listen
> to that key/button/slider.

writing 0 to sysfs file is not a button either it sill should soft
kill the radio. The sw switch is here to enable
killing and enabling radio from software. All the buttons stuff should
go under hard switches.


>
> Come to think of it, there is a bug in the previous patch since it doesn't handle
> the case when the interface is brought up during a BLOCKED state.
>

what is the p previous patch?  If you mean the one I've sent, then
it's known to be incomplete, it was produced to invoke this
conversation.

> So all that has to be done is:
>        * rfkill BLOCK event received in mac80211
>        * set flag to indicate the BLOCKED state
>        * disable radio

In case of notification chain you don't disable radio from mac80211

>        * prevent radio being enabled through ifup
>        * prevent radio being enabled through iwconfig txpower on
>
>        * rfkill UNBLOCK event received from mac80211
>        * clear flag to indicate UNBLOCKED state
>        * restore radio to the by iwconfig/ifup configured state
Same here.
Tomas
