Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:24242 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYKZNrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 08:47:43 -0500
Received: by rv-out-0506.google.com with SMTP id k40so474891rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 05:47:42 -0800 (PST)
Message-ID: <dac45060811260547w2c9d7a7dg839792f5c98011d1@mail.gmail.com> (sfid-20081126_144749_724757_8BE79103)
Date: Wed, 26 Nov 2008 15:47:42 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: AP (Master Mode) of wireless drivers
Cc: "Vladimir Koutny" <vlado@work.ksp.sk>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1227693793.4613.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
	 <1227633414.15224.6.camel@dv> <492D0A26.9090801@work.ksp.sk>
	 <1227693793.4613.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Probing the code, it seems to me that the wiki is not accurate when
specifying which drivers support Access Point mode, when you think of
doing multicast buffering correctly

The wiki says:

"For AP mode, it must
honour IEEE80211_TX_CTL_SEND_AFTER_DTIM or set
		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and use the
ieee80211_get_buffered_bc() function"
		
see:
 http://wireless.kernel.org/en/developers/Documentation/mac80211/API

However, I found out that in wireless-testing, this is the situation:

	
IEEE80211_TX_CTL_SEND_AFTER_DTIM appears only in rt2x00mac.c

There is a call to ieee80211_get_buffered_bc() only in:
1) drivers/net/wireless/ath9k/beacon.c
2) wireless-testing/drivers/net/wireless/libertas_tf/main.c

According to this , b43/b43legacy (Broadcom chips), Intel ipw2200, and
and p54 (Intersil chips) should not appear to support masted mode in
the wiki, in the following URL:

http://www.linuxwireless.org/en/users/Drivers
Am I right ?
Mark




On Wed, Nov 26, 2008 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-26 at 09:34 +0100, Vladimir Koutny wrote:
>> >> More specifically, I am particularly interested to know whether Intel
>> >> iwl3945 and Intel iwl4965 support AP (Master Mode), and in case they
>> >> do not (as I am afraid is the situation)
>> >> - is there any intention to add AP (masted mode) support to these drivers
>> >> in the near future ?
>> >
>> > The driver announces AP mode support (look for NL80211_IFTYPE_AP and
>> > hw->wiphy->interface_modes in iwl-core.c and iwl3945-base.c), so it
>> > might work, or at least the intention is to make it work.  By the way,
>> > rt2x00 announces AP mode support too (in some conditions).
>>
>> I've tested AP mode on iwl4965 about 2 weeks ago and a very quick test did
>> work (no encryption, just connected a win notebook to it and did some
>> browsing). Just be sure to fetch correct (=recent) versions of hostapd and
>> libnl..
>
> I don't think it'll do mcast buffering correctly.
>
> johannes
>
