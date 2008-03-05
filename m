Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:35229 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbYCEW2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 17:28:53 -0500
Received: by rn-out-0910.google.com with SMTP id v46so511399rnb.15
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 14:28:52 -0800 (PST)
Message-ID: <1ba2fa240803051428s4465e245m70c904ddb0189c5e@mail.gmail.com> (sfid-20080305_222900_299863_AA8CC29E)
Date: Thu, 6 Mar 2008 00:28:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Joonwoo Park" <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204752181.17696.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <1204710843.25502.50.camel@johannes.berg>
	 <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com>
	 <1204715825.25502.69.camel@johannes.berg>
	 <1204741740.9378.19.camel@localhost.localdomain>
	 <1ba2fa240803051053j961bf68m605ca3b72cbf1b7b@mail.gmail.com>
	 <1204744764.9378.49.camel@localhost.localdomain>
	 <1ba2fa240803051250g344977f3l6126a179d4504268@mail.gmail.com>
	 <1204752181.17696.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 5, 2008 at 11:23 PM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Wed, 2008-03-05 at 22:50 +0200, Tomas Winkler wrote:
>  > On Wed, Mar 5, 2008 at 9:19 PM, Dan Williams <dcbw@redhat.com> wrote:
>  > >
>  > > On Wed, 2008-03-05 at 20:53 +0200, Tomas Winkler wrote:
>  > >  > On Wed, Mar 5, 2008 at 8:29 PM, Dan Williams <dcbw@redhat.com> wrote:
>  > >  > > On Wed, 2008-03-05 at 12:17 +0100, Johannes Berg wrote:
>  > >  > >  > > > This looks wrong. You could restart association when a key is set but
>  > >  > >  > > > really the race is by design in WEXT so the only way to fix it is to set
>  > >  > >  > > > the key first.
>  > >  > >  > > >
>  > >  > >  > >
>  > >  > >  > > Do you mean fix iwconfig to always do set key before set essid?
>  > >  > >  >
>  > >  > >  > Well, no, I think it's more of a user error, I always do
>  > >  > >  >    iwconfig enc ENC; iwconfig essid SSID
>  > >  > >  > in that order.
>  > >  > >  >
>  > >  > >  > > But, doing It cannot solve a race from two seperated iwconfig process, I think.
>  > >  > >  > > (eg: iwconfig essid ESSID; iwconfig enc ENC)
>  > >  > >  >
>  > >  > >  > Yeah, that's pretty ugly to start with.
>  > >  > >
>  > >  > >  See below for a partial solution; but even with nl80211/cfg80211, if you
>  > >  > >  have more than one process trying to control the wireless card
>  > >  > >  concurrently you have already lost.  Don't Do That.
>  > >  > >
>  > >  > >
>  > >  > >  > > Moreover, now we just wake auth request task up and return when setting essid.
>  > >  > >  > > Don't we need to wait a moment until the task is scheduled to be
>  > >  > >  > > polite to iwconifg? :)
>  > >  > >  >
>  > >  > >  > I think the only way to properly handle it is to reset the association
>  > >  > >  > state machine when a key is added. Dan, what's the expected behaviour?
>  > >  > >
>  > >  > >  The best way to implement the WEXT stuff is to have a timeout of about
>  > >  > >  500ms - 700ms or so to batch WEXT stuff together.  Each new WEXT command
>  > >  > >  that comes in before the timeout pushes the timeout back.  When the
>  > >  > >  timeout triggers, all the new commands are executed in the driver in the
>  > >  > >  order the driver expects.  That fixes most issues with chaining WEXT
>  > >  > >  commands and makes all of these Just Work:
>  > >  > >
>  > >  > >  iwconfig wlan0 essid foo key 253325353 open channel 11
>  > >  > >  iwconfig wlan0 key 253325353 open essid foo channel 11
>  > >  > >  iwconfig wlan0 channel 11 key 253325353 open essid foo
>  > >  > >
>  > >  > >  Later on if you issue just 'iwconfig wlan0 channel 6' the driver waits
>  > >  > >  500ms, the timeout triggers, and the driver changes to channel 6 and
>  > >  > >  starts the association process all over with the current settings (keys,
>  > >  > >  BSSID/SSID, bitrate, etc), and issues the SIOCGIWBSSID association event
>  > >  > >  on both success and failure.
>  > >  > >
>  > >  > >  If you just do 'iwconfig wlan0 rate 11' then of course the driver
>  > >  > >  doesn't need to trigger reassociation after the WEXT command timeout, it
>  > >  > >  just needs to lock the bitrate.
>  > >  > >
>  > >  > >  The _explicit_ triggers for association/reassociation are setting the
>  > >  > >  BSSID or the SSID.
>  > >  >
>  > >  > Currently there is a quite a mess that both BSSID and SSID triggers
>  > >  > association.
>  > >  > iwconfig essid AP1
>  > >  > iwconfig ap "00:....." - (bssid of myap)
>  > >  > iwconfig essid AP2
>  > >  >
>  > >  > what will be result of this? will it try to associate with AP1:BSSID
>  > >  > but AP2 SSID
>  > >
>  > >  In the current, not-timeout situation, the driver would probably attempt
>  > >  to associate to AP1/any, and be interrupted by the BSSID lock of the
>  > >  second command, and then try to associate to AP1/00:..., then be
>  > >  interrupted by the third command.
>  > >
>  > >  Then, it should fail if there is no BSSID "00:..." with an SSID of
>  > >  "AP2".  The user must clear the BSSID lock by doing 'iwconfig ap any'
>  > >  and then the driver is free to use any BSSID in it's scan list that
>  > >  matches SSID AP2 and security settings currently configured in the
>  > >  driver.
>  > >
>  > >  Remember, WEXT commands are _cumulative_ unless cleared by the user.
>  >
>  > It's mac80211 decision when to start association. I suggest to
>
>  Ultimately, yes the driver controls association, but in WEXT association
>  is triggered by setting the SSID or the BSSID.  Outside of SSID/BSSID,
>  the driver should trigger reassociation when it needs to.  But BSSID and
>  SSID MUST always trigger a new association.
>
>
>  > associate only on SSID command
>  > if someone wants to trigger BSSID association it would call SSID ANY
>  > call explicitly. This will definitely reduce the mess
>  > I'm seeing now.
>
>  No, that's not enough for implementing WEXT.  I don't really see what
>  the problem is here?  Why is it currently a mess (other than that WEXT
>  is a mess)?  It's pretty clear to me; if you ever execute an 'iwconfig'
>  call that is not 'any' or '0', that attribute is locked in the driver
>  until you unlock it.  End of story.
>
>  That's the conformant case; not all drivers implement it that way.

I'm not talking about any driver I'm specific of mac80211

>  If you do:
>
>  iwconfig wlan0 essid "foobar"
>  iwconfig wlan0 bssid 12:34:56:78:90:12
>  iwconfig wlan0 essid "baz"
>
>  and there is no AP of SSID=baz and BSSID=12:34:56:78:90:12, then the
>  association MUST fail because both the SSID and BSSID attributes are
>  locked in the driver.  They MUST be locked in the driver until one or
>  more of them is cleared or changed, at which point another association
>  must occur.

wireless-tools also provide 'commit' command for these cases so you
know when you are done with configuration.
It is mac80211 current choice not to implemented it that way.

Currently either there is some problem in mac80211 auto selection and
different SSID from bss list from what it
was configured. or some service I don't know about is trying also
configure the device to SSID any.
What I see that association frame has different SSID set then what was
configured usually it's first SSID
in BSS list so association is failing.



>  > I'm using Fedora 8 for development and I'm still cannot figure what
>  > services are trying to access wireless
>  > devices but association is always failing because SSID is switched
>  > between authentication and association frames.
>  > It started to work a bit when I've disabled avahi and disabled dhcp on
>  > the device. (dhcp running after association is fine)
>
>  How about:
>
>  /sbin/service NetworkManager stop
>
>  and:
>
>  killall -TERM wpa_supplicant
>
>  If either NM or wpa_supplicant are running, commands from iwconfig will
>  likely fail because there are two things trying to drive the wireless
>  device.  Just don't do that; because during driver development you need
>  to control the environment obviously.
>

Those are not running for sure in my setup.

>  another problem is drivers that do autoassociation; like ipw2200's
>  'associate=x' parameter.  That allows the driver to automatically
>  associate to anything it can find, which causes no end of problems.
>  That's wrong.
>
ipw2200 doesn't run under mac80211.

Tomas

>
>
