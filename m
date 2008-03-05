Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:2331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYCESxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:53:24 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1820567wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 10:53:22 -0800 (PST)
Message-ID: <1ba2fa240803051053j961bf68m605ca3b72cbf1b7b@mail.gmail.com> (sfid-20080305_185328_820371_13B558C6)
Date: Wed, 5 Mar 2008 20:53:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Joonwoo Park" <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204741740.9378.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <1204710843.25502.50.camel@johannes.berg>
	 <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com>
	 <1204715825.25502.69.camel@johannes.berg>
	 <1204741740.9378.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 5, 2008 at 8:29 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2008-03-05 at 12:17 +0100, Johannes Berg wrote:
>  > > > This looks wrong. You could restart association when a key is set but
>  > > > really the race is by design in WEXT so the only way to fix it is to set
>  > > > the key first.
>  > > >
>  > >
>  > > Do you mean fix iwconfig to always do set key before set essid?
>  >
>  > Well, no, I think it's more of a user error, I always do
>  >    iwconfig enc ENC; iwconfig essid SSID
>  > in that order.
>  >
>  > > But, doing It cannot solve a race from two seperated iwconfig process, I think.
>  > > (eg: iwconfig essid ESSID; iwconfig enc ENC)
>  >
>  > Yeah, that's pretty ugly to start with.
>
>  See below for a partial solution; but even with nl80211/cfg80211, if you
>  have more than one process trying to control the wireless card
>  concurrently you have already lost.  Don't Do That.
>
>
>  > > Moreover, now we just wake auth request task up and return when setting essid.
>  > > Don't we need to wait a moment until the task is scheduled to be
>  > > polite to iwconifg? :)
>  >
>  > I think the only way to properly handle it is to reset the association
>  > state machine when a key is added. Dan, what's the expected behaviour?
>
>  The best way to implement the WEXT stuff is to have a timeout of about
>  500ms - 700ms or so to batch WEXT stuff together.  Each new WEXT command
>  that comes in before the timeout pushes the timeout back.  When the
>  timeout triggers, all the new commands are executed in the driver in the
>  order the driver expects.  That fixes most issues with chaining WEXT
>  commands and makes all of these Just Work:
>
>  iwconfig wlan0 essid foo key 253325353 open channel 11
>  iwconfig wlan0 key 253325353 open essid foo channel 11
>  iwconfig wlan0 channel 11 key 253325353 open essid foo
>
>  Later on if you issue just 'iwconfig wlan0 channel 6' the driver waits
>  500ms, the timeout triggers, and the driver changes to channel 6 and
>  starts the association process all over with the current settings (keys,
>  BSSID/SSID, bitrate, etc), and issues the SIOCGIWBSSID association event
>  on both success and failure.
>
>  If you just do 'iwconfig wlan0 rate 11' then of course the driver
>  doesn't need to trigger reassociation after the WEXT command timeout, it
>  just needs to lock the bitrate.
>
>  The _explicit_ triggers for association/reassociation are setting the
>  BSSID or the SSID.

Currently there is a quite a mess that both BSSID and SSID triggers
association.
iwconfig essid AP1
iwconfig ap "00:....." - (bssid of myap)
iwconfig essid AP2

what will be result of this? will it try to associate with AP1:BSSID
but AP2 SSID


Tomas

>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
