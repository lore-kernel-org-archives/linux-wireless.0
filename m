Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:57758 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZIIREF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 13:04:05 -0400
Received: by yxe5 with SMTP id 5so7597020yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 10:04:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252512190.25355.15.camel@darkslate>
References: <1252512190.25355.15.camel@darkslate>
Date: Wed, 9 Sep 2009 13:04:06 -0400
Message-ID: <b6c5339f0909091004hd4d3a24mdb83dd82f5f9c9e3@mail.gmail.com>
Subject: Re: wireless/sme.c:617 __cfg80211_disconnected I still get these
	daily
From: Bob Copeland <me@bobcopeland.com>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 9, 2009 at 12:03 PM, ASIC Felix <ic.felix@gmail.com> wrote:
> Hi,
>
> I still get these daily.
>
> Thinkpad T43,
> phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xfa360000, irq=21
>
> kernel: linville master-2009-09-08 2.6.31-rc9-wl-36500-g918dc92

Same here...

[ 4692.369907] wlan0: associated
[ 4692.369921] phy0: Allocated STA 00:23:ab:26:4d:80
[ 4692.371064] phy0: Inserted STA 00:23:ab:26:4d:80
[ 4800.046263] wlan0: deauthenticating by local choice (reason=3)
[ 4800.046329] phy0: Removed STA 00:23:ab:26:4d:80
[ 4800.051446] phy0: device now idle
[ 4800.053456] phy0: Destroyed STA 00:23:ab:26:4d:80
[ 4800.053550] wlan0: deauthenticating by local choice (reason=3)
[ 4800.053556] ------------[ cut here ]------------
[ 4800.053573] WARNING: at net/wireless/sme.c:617
__cfg80211_disconnected+0x1c9/0x210 [cfg80211]()
[ 4800.053576] Hardware name: MacBook1,1
[ 4800.053579] deauth failed: -67

Looks like we deauthed twice in a row (no idea why the second one happened)
and that made the sme code unhappy:

		for (i = 0; i < MAX_AUTH_BSSES; i++) {
			if (!wdev->auth_bsses[i])
				continue;
			bssid = wdev->auth_bsses[i]->pub.bssid;
			ret = __cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
						WLAN_REASON_DEAUTH_LEAVING);
			WARN(ret, "deauth failed: %d\n", ret);
		}

iw event output (this is wext)... connect failed, then we did deauth
anyway?

1252515598.767300: wlan0 (phy #0): deauth 00:17:f2:43:be:3a ->
00:23:ab:26:4d:80 reason 3: Deauthenticated because sending station is
leaving (or has left) the IBSS or ESS
1252515598.767545: wlan0 (phy #0): disconnected (local request)
1252515598.767663: wlan0 (phy #0): deauth 00:17:f2:43:be:3a ->
00:23:ab:26:4d:80 reason 3: Deauthenticated because sending station is
leaving (or has left) the IBSS or ESS
1252515598.767821: wlan0 (phy #0): failed to connect to
00:23:ab:26:4d:80, status: 1: Unspecified failure
1252515598.770943: wlan0 (phy #0): scan started
1252515598.965265: wlan0 (phy #0): failed to connect, status: 1:
Unspecified failure
1252515598.965425: wlan0 (phy #0): scan finished: 2462,
"\x02\xf4\xb2\xedr\x16\xec\xf3\x01M\xf0\x00\x10\x8bg\xcf\x99P[\x17\x9f\x8e\xd4\x98\x0aa\x03\xd1\xbc\xa7\x0d\xbe"
1252515598.965736: wlan0 (phy #0): scan started
1252515598.965882: wlan0 (phy #0): deauth 00:17:f2:43:be:3a ->
00:23:ab:26:4d:80 reason 3: Deauthenticated because sending station is
leaving (or has left) the IBSS or ESS
1252515598.966042: wlan0 (phy #0): failed to connect to
00:23:ab:26:4d:80, status: 1: Unspecified failure
1252515599.161286: wlan0 (phy #0): scan finished: 2462,
"\x02\xf4\xb2\xedr\x16\xec\xf3\x01M\xf0\x00\x10\x8bg\xcf\x99P[\x17\x9f\x8e\xd4\x98\x0aa\x03\xd1\xbc\xa7\x0d\xbe"
1252515599.167130: wlan0 (phy #0): auth 00:23:ab:26:4d:80 ->
00:17:f2:43:be:3a status: 0: Successful
1252515599.171144: wlan0 (phy #0): assoc 00:23:ab:26:4d:80 ->
00:17:f2:43:be:3a status: 0: Successful
1252515599.171283: wlan0 (phy #0): connected to 00:23:ab:26:4d:80

-- 
Bob Copeland %% www.bobcopeland.com
