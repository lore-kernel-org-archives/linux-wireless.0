Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12951 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3FEJ5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 05:57:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <ordex@autistici.org>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl_mgmt_tx with NULL chan
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
	<1370271547.8227.16.camel@jlt4.sipsolutions.net>
	<51ACB068.8070006@lri.fr> <20130603171430.GE1226@ritirata.org>
Date: Wed, 5 Jun 2013 12:57:07 +0300
In-Reply-To: <20130603171430.GE1226@ritirata.org> (Antonio Quartulli's message
	of "Mon, 3 Jun 2013 19:14:30 +0200")
Message-ID: <8738swkhho.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_115717_115828_234029C1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <ordex@autistici.org> writes:

> On Mon, Jun 03, 2013 at 05:04:08PM +0200, Nicolas Cavallari wrote:
>> On 03/06/2013 16:59, Johannes Berg wrote:
>> > On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
>> >> From: Antonio Quartulli <antonio@open-mesh.com>
>> >>
>> >> Users may want to send a frame on the current channel
>> >> without specifying it.
>> >>
>> >> Make mgmt_tx pass a NULL channel to mac80211 if none has
>> >> been specified by the user.
>> > 
>> > cfg80211 isn't just a mac80211 frontend ... ;-)
>> > 
>> > Also, as Nicolas said, ath6kl_mgmt_tx() will crash after this patch if
>> > it's called in AP mode w/o a channel, so you need to think about that.
>> 
>> It will crash unconditionally. All ath6kl_mgmt_tx()'s code paths access
>> chan->center_freq at some point.
>
> Hello Nicolas,
> I'm also CCing Kalle Valo since get_maintainer.pl told me he is the guy for
> these kind of questions :-)
>
> I'm looking at ath6kl_mgmt_tx() in ath6kl/cfg80211.c and I've seen that the
> currently "configured" frequency can be obtained by reading the
> ath6kl_vif->ch_hint field.
>
> But, is this correct?

I did a quick look. To me using ch_hint looks correct.

> I couldn't see any real relation between the ch_hint field and the
> real frequency (probably because a lot of logic is hidden to the
> driver). I could only understand that the ch_hint field stores the
> frequency passed as parameter during the connection, but I have found
> no guarantee that this is the really used one.

Can you be more specific, please?

To me it looks that ch_hint is used both with ath6kl_wmi_reconnect_cmd()
and ath6kl_wmi_connect_cmd() commands, which both are used to connect to
a network. I don't see any other variables used for specifying the
frequency to the firmware. But I could just be blind...

-- 
Kalle Valo
