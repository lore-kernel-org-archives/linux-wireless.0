Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48639 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1F2OGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 10:06:48 -0400
Received: by fxd18 with SMTP id 18so1268134fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 07:06:46 -0700 (PDT)
Message-ID: <4E0B3174.10100@fedoraproject.org> (sfid-20110629_160651_817814_1A1685D4)
Date: Wed, 29 Jun 2011 16:06:44 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org> <20110628215757.GA14975@jm.kir.nu> <4E0AE8C1.9090809@fedoraproject.org> <20110629130910.GA2688@jm.kir.nu> <4E0B2BF8.6090300@fedoraproject.org> <20110629135536.GB3259@jm.kir.nu>
In-Reply-To: <20110629135536.GB3259@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 03:55 PM, Jouni Malinen wrote:
> On Wed, Jun 29, 2011 at 03:43:20PM +0200, Michel Alexandre Salim wrote:
>> My first attempt to solve this was to use 'iwconfig wlan0 set rate
>> 54M' -- but this yields "Operation not supported". How about making
>> a request for a rate of 54M or below switch the device to 802.11g
>> mode (and optionally, a rate of 11M or below =>  802.11b mode)? That
>> way we don't need to invent a new interface at all. How would I go
>> about adding support for rate setting requests to the driver?
>
> I would first move from WEXT to nl80211 in order to get any chance of
> getting the change accepted.. We have a somewhat similar mechanism in
> NL80211_CMD_SET_TX_BITRATE_MASK, but it does not address HT rates at
> all, so some additions would be needed. For example, a new attribute to
> the command could be used to set TX mask for MCS indexes and if none are
> allowed, HT could be disabled. Though, a cleaner mechanism would likely
> be to just provide an explicit attribute to disable 802.11n. If that is
> done outside the scope of a single connection, that would be available
> as a manual workaround even without modifications to
> wpa_supplicant/NM/ConnMan.
>
Thanks for the pointers -- I'll take a look at it and get back when I 
have working code.

-- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
             http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
