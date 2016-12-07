Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33532 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbcLGGsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:48:09 -0500
Message-ID: <1481093287.4092.20.camel@sipsolutions.net> (sfid-20161207_074812_965924_E4D7B609)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 07:48:07 +0100
In-Reply-To: <5847AEF9.90409@gmail.com> (sfid-20161207_074059_163818_6A66D9AB)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
         <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
         <1481091301.4092.5.camel@sipsolutions.net> <5847AEF9.90409@gmail.com>
         (sfid-20161207_074059_163818_6A66D9AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-07 at 00:40 -0600, Denis Kenzior wrote:
> 
> > No, this is the part you didn't understand. Simply authenticating
> > doesn't actually create anything like a "link" to the AP. The only
> 
> Okay, but it is then a bit misleading that iw link reports us being 
> 'connected' during this time for example.

It doesn't!

# iw wlan0 auth <ssid> <bssid> open 2462

-> iw event reporting
wlan0 (phy #0): auth <localMAC> -> <bssid> status: 0: Successful

# iw wlan0 link
Not connected.


> Fair enough.  I think we can live with that since we're not using 
> CMD_AUTHENTICATE unless we need to roam using FT.

That seems like a very strange decision, but it's obviously up to you
:)

johannes
