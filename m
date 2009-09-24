Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47893 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZIXTNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:13:36 -0400
Received: by bwz6 with SMTP id 6so1557379bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 12:13:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253779538.3868.14.camel@johannes.local>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
Date: Thu, 24 Sep 2009 20:13:39 +0100
Message-ID: <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 9:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-09-21 at 18:11 +0200, Albert Herranz wrote:
>
>> Adding back "cfg80211: fix SME connect" and applying "cfg80211: don't
>> overwrite privacy setting" fixes the connection issue, but with a
>> introduces a small difference vs the previous working version.
>> There is now an extra "deauthenticating by local choice (reason=3)"
>> message in the logs.
>
>> [   13.969153] b43-phy0 debug: Adding Interface type 2
>> [   16.679249] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
>
>> * master-20090916 + "cfg80211: don't overwrite privacy setting"
>
>> [   13.218613] b43-phy0 debug: Adding Interface type 2
>> [   15.832582] wlan1: deauthenticating by local choice (reason=3)
>> [   16.131599] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
>
> Very odd. Can you edit the deauthenticating message to show the
> BSSID/MAC address?
>
> johannes
>

This seems to look like/relate to a little problem I have for the last
few days - lately I have authentication failure on first try and have
to click on NM a 2nd time for it to go through; blow away
compat-wireless & revert to as-shipped distro modules gives me the
older/smooth behavior  of NM just associating without me
clicking/asking.

v2.6.31-38294-ged3ac87 + 'cfg80211: don't set privacy w/o key' doesn't
improve my situation.

wpa_supplicant log:
--------- distro modules:
Trying to associate with <id> (SSID='ID' freq=2437 MHz)
Associated with <id>
CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

-------- compat-wireless
Trying to associate with <id> (SSID='ID' freq=2437 MHz)
Authentication with 00:00:00:00:00:00 timed out.
Trying to associate with <id> (SSID='ID' freq=2437 MHz)
Associated with <id>
CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]

------ dmesg distro modules
wlan2: direct probe to AP <id> try 1
wlan2 direct probe responded
wlan2: authenticate with AP <id>
wlan2: authenticated
wlan2: associate with AP <id>
wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
wlan2: associated

------ compat-wireless, note the extra deauth at the beginning, and
all those 'try 1''s.
wlan2: deauthenticating by local choice (reason=3)
wlan2: direct probe to AP <id> (try 1)
wlan2 direct probe responded
wlan2: authenticate with AP <id> (try 1)
wlan2: authenticated
wlan2: associate with AP <id> (try 1)
wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
wlan2: associated

my wpa_supplicant config has two configurations, one (the usual) wep,
and a catch-all generic open network, if that matters.

Most of the instances in wpa log are extra authentication timeouts
with 00:00:00:00:00:00 , but occasionally it is my AP's address.
