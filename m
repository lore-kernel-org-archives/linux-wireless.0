Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:14928 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZEKHlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 03:41:11 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2322379wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 00:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090511001749.efx510zpk404owww-cebfxv@webmail.spamcop.net>
References: <20090203173228.GB9713@tesla> <20090214230618.203560@gmx.net>
	<43e72e890902141718v544f5caejb71f53bdadbf8a8f@mail.gmail.com>
	<20090216205115.21860@gmx.net> <43e72e890902161342j23b68a4eoabddb047fb9d9084@mail.gmail.com>
	<20090508211237.316290@gmx.net> <1241818845.6240.4.camel@mj>
	<43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
	<43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<20090511001749.efx510zpk404owww-cebfxv@webmail.spamcop.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 May 2009 00:40:52 -0700
Message-ID: <43e72e890905110040o6a87d963mf0d5a5a08b22fbfd@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath comes
To: Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 10, 2009 at 9:17 PM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
>> I can reproduce, and I tried without the idle patches but I still se=
e
>> the issue. I see this issue only after suspend. Did you suspend and
>> get this as well? I see this using AR5416. If you are seeing this on
>> suspend can you try with the patch I posted to linux-wireless to see
>> if it helps a little?
>
> I saw this on AR9280 without any suspends. =C2=A0The card doesn't sup=
port the
> 802.11a range, so it's not a direct equivalent of the problem I bisec=
ted
> with ath5k (invalid rates when scanning and transmitting).

Thanks for the heads up Pavel. So can you guys test with this option
set as follows:

CONFIG_MAC80211_DEFAULT_PS_VALUE=3D0

If using compat-wireless just stuff it into config.mk.

This fixes my issues and points towards PS code. This could be how we
handle PS in ath9k (more likely) or mac80211. For now please disable
this if using ath9k until we figure out what causes this.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
