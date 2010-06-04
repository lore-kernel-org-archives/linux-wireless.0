Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35634 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0FDVxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 17:53:46 -0400
Received: by vws5 with SMTP id 5so201648vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 14:53:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100604212145.GB4069@tux>
References: <20100519012528.22206.77550.stgit@tt-desk> <20100519013147.22206.71360.stgit@tt-desk>
	<20100604193009.GD2492@tuxdriver.com> <20100604212145.GB4069@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 4 Jun 2010 14:53:25 -0700
Message-ID: <AANLkTilWi9PKy7GGefRgUqAyzAWXa7pzyCIVInu1QLxs@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
	configuration
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>,
	Aeolus Yang <Aeolus.Yang@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 4, 2010 at 2:21 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Jun 04, 2010 at 12:30:09PM -0700, John W. Linville wrote:
>> On Wed, May 19, 2010 at 10:31:48AM +0900, Bruno Randolf wrote:
>> > Allow setting TX and RX antenna configuration via nl80211/cfg80211.
>> >
>> > The antenna configuration is defined as a bitmap of allowed antennas. This
>> > bitmap is 8 bit at the moment, each bit representing one antenna. If multiple
>> > antennas are selected, the driver may use diversity for receive and transmit.
>> > This allows for a simple, yet flexible configuration interface for antennas,
>> > while drivers may reject configurations they cannot support.
>> >
>> > Signed-off-by: Bruno Randolf <br1@einfach.org>
>>
>> This spawned a long thread, that isn't clearly resolved IMHO.  So, I
>> haven't merged it, or the other patches that follow it in this series.
>>
>> Am I mistaken?  Did this get resolved?  If not, are some of the later
>> patches still interesting?
>>
>> Unless I hear otherwise, I'll be dropping the rest of this series...
>
> I don't think the API is defined clean enough yet and can yield
> inconsistant interpretations. I'd like to see this clarified on
> the documentation for both legacy and 802.11n. If the plan is
> to support only legacy right now then I think the API can be
> simpler and clearer with only three options passed, Fixed_A
> Fixed_B and diversity.

Oh and the rest of the series should not be dropped but I did think it
would have been prudent for the patches to be separated and that this
particular set of patches for antenna API be separated out to another
series so that the other stuff can get merged.

  Luis
