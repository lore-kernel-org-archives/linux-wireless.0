Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22019 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYG2JnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 05:43:22 -0400
To: "ext Hin-Tak Leung" <hintak.leung@gmail.com>
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@openedhand.com>
Subject: Re: mac80211 power management breakage?(was Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187)
References: <3ace41890807260626x925b6b8h90f85dd91b24b4d5@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 29 Jul 2008 12:42:13 +0300
In-Reply-To: <3ace41890807260626x925b6b8h90f85dd91b24b4d5@mail.gmail.com> (ext Hin-Tak Leung's message of "Sat\, 26 Jul 2008 14\:26\:48 +0100")
Message-ID: <874p69m3gq.fsf@nokia.com> (sfid-20080729_114325_890956_0B1C195B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext Hin-Tak Leung" <hintak.leung@gmail.com> writes:

> On Fri, Jul 25, 2008 at 5:36 PM, Herton Ronaldo Krzesinski
>
>> So it seems there is a bug when trying to do a "power on" after "essid <key>"
>> command, are you able to reproduce this too?
>
> - I have added linux-wireless back to CC:, since I have reproduced
> the problem you saw, exactly as you described. (you mean "power on
> after essid <any>" is problematic, I think)
>
> I have also had a look at the code and while I don't understand most
> of it, I thought maybe I have a guess of how adding power management
> wext hooks can break association.

Do you mean this patch from Samuel which is in wireless-testing:

commit 8f87dd7e540d455f8e7f11478133b85edc969c67
Author: Samuel Ortiz <samuel@sortiz.org>
Date:   Fri Jul 4 10:49:31 2008 +0200

    mac80211: power management wext hooks
    
    This patch implements the power management routines wireless extensions
    for mac80211.
    For now we only support switching PS mode between on and off.

> What the power management hooks + enabling power management does, is
> to buffer for up to STA_MAX_TX_BUFFER frames of certain types; also,
> if a iwconfig essid <any> is issued before iwconfig essid <some_ap>,
> the <any> result is cached for look-up, I think.

No, the only thing Samuel's patch adds is support for SIOCSIWPOWER and
SIOCGIWPOWER ioctls. It also adds IEEE80211_CONF_PS flag which
mac80211 driver's can use to check if Power Save Mode is enabled by
the user. But currently there are no drivers using it.

Of course this patch may very well break something, but it's related
to something else than Power Save Mode itself. It's not obvious how
this patch can break rtl18187. For me iwl3945 has worked perfectly,
with which patch included.

The only thing which might break it is an extra call to
ieee80211_hw_config() when issueing 'iwconfig wlan0 power on', but
that might be a bit far fetched. If you have the time, please try to
debug this more. For example you could try reverting the patch with
'git revert --no-commit 8f87dd7e54' and see if it really makes a
difference.

> so the 3 situations you out-lined are this:
>
> -use a lot of frames to find any APs, (power saving on, start
> buffering)  send a small number of frames to
> associate with one among the known APs but these frames are buffered,
> so no association
>
> - (power saving on, start buffering), use a lot of frames to find any
> APs, a few more to associate to one.
>
> - (power saving on, start buffering), doesn't know any APs, so use a
> lot of frames to find a particular one.
>
> Does this make sense, or am I talking nonsense? In any case, there is
> a MAC80211_VERBOSE_PS_DEBUG
> in net/mac80211/tx.c,  which should be relevant.

You are confusing AP and client mode PSM here,
MAC80211_VERBOSE_PS_DEBUG is used for debugging PSM support in AP
mode. Client mode PSM support is usually implemented in the driver or
the firmware. We are planning to add some PSM support to mac80211, but
it's still in the works.

-- 
Kalle Valo
