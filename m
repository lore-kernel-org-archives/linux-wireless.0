Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36330 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1J1J2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 05:28:04 -0400
Received: by ggnb1 with SMTP id b1so3502453ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 02:28:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0E37541B@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
	<1319788880.3914.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E37541B@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Fri, 28 Oct 2011 11:28:03 +0200
Message-ID: <CAGXE3d9NiHgmE_ABc_red7MeNnhUGG+fOgbL19B9U3e9Fx9Vxw@mail.gmail.com> (sfid-20111028_112808_866754_277D78B4)
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 28, 2011 at 11:10 AM, Arend Van Spriel <arend@broadcom.com> wrote:
>> > I would expect this to affect the duration field in the
>> > 802.11 header to indicate the shorter use of the medium.
>> > Going through your patch I am not sure this is done.
>>
>> Hmmm. You're right, but that's something we already need to fix in many
>> cases -- as the duration field is overwritten by most hardware these
>> days, we haven't always maintained it very well.
>
> If the station still does the ACK we should not touch the duration field
> in this case (see my reply to Helmut).

The reason is the following: if you're running a mac80211 AP with multiple
bssids, hostapd will answer to broadcast probe requests sent by STAs with
one probe response per bssid (unicast of course). And since some clients
stay only for a short amount of time on the scan-channel (a few ms) under
some circumstances the probe responses aren't sent out yet before the
scanning STA leaves the channel and thus retried till the maximum retry
limit is reached. And these retries consume quite a lot of airtime. And to
avoid this we just don't want to retry the probe responses in that case.

Helmut
