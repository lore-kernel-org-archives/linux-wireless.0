Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2J0ITB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2012 04:19:01 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3250065pbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2012 01:19:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50888021.4050300@candelatech.com>
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
	<50880BD0.6080603@candelatech.com>
	<1351093332.10709.5.camel@jlt4.sipsolutions.net>
	<5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net>
	<50888021.4050300@candelatech.com>
Date: Sat, 27 Oct 2012 01:19:00 -0700
Message-ID: <CAJ-Vmo=eP8EC2760A_0Ydy3bvG93bhVXfHS9TS3VpAf2vejJ=g@mail.gmail.com> (sfid-20121027_101918_633814_D4C7D4DE)
Subject: Re: Is Multi-Vif (vaps) Different Channel Operation Supported?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Kelly Hogan <kshogan@bluemesh.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah, how's hostap mode supposed to work in that case? The hostap
interface doesn't go into and out of power save like stations can. It
has to be ready to receive anything from any STA, at any point in
time.




Adrian

On 24 October 2012 16:56, Ben Greear <greearb@candelatech.com> wrote:
> On 10/24/2012 04:05 PM, Kelly Hogan wrote:
>>
>> Hi All,
>>
>> We are utilizing current ath9k and mac80211 and are trying to discern if
>> multi-channel support is possible on different Vifs, on the same phy.
>>
>> Example:
>>
>> Two Vifs running as masters, controlled via hostapd
>> One Vif running as a Station, controlled by wpa_supplicant
>> One Vif running as a mesh vap
>>
>> We can run all the Vifs fine, but it appears that with shared
>> hostapd/wpa_supplicant control files, that the master Vifs always have to
>> follow the channel that the station is connected to.  The mesh vap also
>> seems to require being on the same channel of the station.
>>
>> Any info on if this is supported, or what order to process creation,
>> channel setting, etc to get them to simultaneously allow different channel
>> support would be helpful, or save us the time of assuming that it can be
>> done if it in fact can't.
>
>
> It cannot work as far as I know.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
