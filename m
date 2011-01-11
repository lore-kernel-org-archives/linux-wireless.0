Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49469 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1AKNQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:16:17 -0500
Received: by qyk12 with SMTP id 12so23183364qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 05:16:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294748329.3611.8.camel@jlt3.sipsolutions.net>
References: <20110107052600.18730.98168.stgit@localhost6.localdomain6>
	<201101081243.56629.br1@einfach.org>
	<AANLkTimYjvJbm9DPPDWWCsD76_DnFcBG3a2Z_B8Mhpzm@mail.gmail.com>
	<201101111817.40309.br1@einfach.org>
	<1294748329.3611.8.camel@jlt3.sipsolutions.net>
Date: Tue, 11 Jan 2011 08:16:16 -0500
Message-ID: <AANLkTimg_udpa78Fbq+-48rOC38_jg_afaME=PYCsChr@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Extend channel to frequency mapping for 802.11j
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 11, 2011 at 7:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-01-11 at 18:17 +0900, Bruno Randolf wrote:
>
>> > compat-wireless-2011-01-07.orig/drivers/net/wireless/libertas/cfg.c 2011-0
>> > 1-07 15:03:59.000000000 -0500
>> > +++
>> > compat-wireless-2011-01-07/drivers/net/wireless/libertas/cfg.c      2011-01-08
>> > 07:51:23.947290769 -0500
>> > @@ -607,7 +607,8 @@
>> >             /* No channel, no luck */
>> >             if (chan_no != -1) {
>> >                     struct wiphy *wiphy = priv->wdev->wiphy;
>> > -                   int freq = ieee80211_channel_to_frequency(chan_no);
>> > +                   int freq = ieee80211_channel_to_frequency(chan_no,
>> > +                                   chan_no <= 14 ? IEEE80211_BAND_2GHZ :
>> IEEE80211_BAND_5GHZ);
>>
>> The whole point of having the band argument is to avoid this. We now have
>> overlapping channel numbers: channel 8 and 12 are defined in 5GHz as well as
>> in 2.4GHz (that is for 20MHz channel width, there are more for 10 and 5MHz
>> width, but we don't support that yet). The band has to come from the hardware
>> or driver configuration.
>
> I don't think libertas (or orinoco) support the frequencies that
> overlap, and they use the channel number in HW config, so it should be
> fine.
>
> johannes

That's what it looked like to me, as well, for libertas.  For rt2x00,
with it's dependence on binary firmwares from Ralink, extending the
channel set seems very far from trivial.  Ralink advertises compliance
with 802.11j (http://web.ralinktech.com/ralink/data/RT2800.pdf).  A
year and a half ago I asked them directly what that compliance means
(4.9GHz channels?  10MHz channel width?  misprint?) and didn't get a
response.  A way to pull the band for rt2x00 didn't pop out at me, but
if the maintainers have suggestions, that'll be great.  Also, if they
have some idea what the level of 802.11j compliance is, I'd love to
know!

-Brian
