Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46520 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbCARaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 12:30:24 -0500
Received: by igbhl2 with SMTP id hl2so11837902igb.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2015 09:30:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150301171252.GA18568@w1.fi>
References: <54784001.7020706@broadcom.com>
	<20150301171252.GA18568@w1.fi>
Date: Sun, 1 Mar 2015 18:30:23 +0100
Message-ID: <CACna6rx+wjmcWrg_ddfPwJWF-MJmd52KqLQgdAA79LR30mshng@mail.gmail.com> (sfid-20150301_183027_692948_616BC517)
Subject: Re: Multiple-BSSID issues with hostapd
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 March 2015 at 18:12, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Nov 28, 2014 at 10:27:29AM +0100, Arend van Spriel wrote:
>> For the brcmfmac we started working on Multiple-BSSID support and came
>> across some issues with hostapd that are listed listed below.
>
> Did you get test these with a more recent hostapd version (ideally,
> hostap.git master branch snapshot)? I was unable to reproduce either
> issue..

Could this be something similar to the problem handled in:
nl80211: report new station / assoc event for the correct BSS
http://patchwork.ozlabs.org/patch/418401/
http://w1.fi/cgit/hostap/commit/?id=7c4027f60411aca6e90a0074499c5427c8268baa

NL80211_CMD_GET_STATION is not handled in driver_nl80211_event.c, but
maybe there is similar place somewhere else?
