Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57777 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab1BLBDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 20:03:11 -0500
Received: by iyj8 with SMTP id 8so2985239iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 17:03:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110212003420.GG1240@mail.wantstofly.org>
References: <1297469031-21004-1-git-send-email-thomas@cozybit.com>
	<1297469031-21004-2-git-send-email-thomas@cozybit.com>
	<20110212003420.GG1240@mail.wantstofly.org>
Date: Fri, 11 Feb 2011 17:03:10 -0800
Message-ID: <AANLkTinYHLBjrPL6NDLjy2pk-4iwxZbdj8-yKXUzf=x2@mail.gmail.com>
Subject: Re: [PATCH 2/2] mwl8k: Tell mac80211 we have rate adaptation in AP FW
From: Thomas Pedersen <thomas@cozybit.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org, Sandesh Goel <sgoel@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lennert,

We appreciate your feedback and are working on a correct solution,
thanks for the heads up.

Thomas

On Fri, Feb 11, 2011 at 4:34 PM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> [ adding Nishant Sarmukadam and Sandesh Goel to CC ]
>
>
> On Fri, Feb 11, 2011 at 04:03:51PM -0800, Thomas Pedersen wrote:
>
>> From: Nishant Sarmukadam <nishants@marvell.com>
>>
>> Minstrel rate control algorithm is enabled by default by mac80211.
>> This is not needed since the firmware does the rate control in our case.
>>
>> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  drivers/net/wireless/mwl8k.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
>> index f79da1b..840b9e4 100644
>> --- a/drivers/net/wireless/mwl8k.c
>> +++ b/drivers/net/wireless/mwl8k.c
>> @@ -4765,6 +4765,9 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
>>
>>       /* Set rssi values to dBm */
>>       hw->flags |= IEEE80211_HW_SIGNAL_DBM;
>> +     /* AP FW has rate control */
>> +     if (priv->ap_fw)
>> +             hw->flags |= IEEE80211_HW_HAS_RATE_CONTROL;
>>       hw->vif_data_size = sizeof(struct mwl8k_vif);
>>       hw->sta_data_size = sizeof(struct mwl8k_sta);
>
> I got this same patch (almost exactly the same -- STA firmware actually
> also has rate control so the added AP check in this version of the patch
> is bogus) sent to me a number of times now, the last time from Pradeep
> Nemavat <pnemavat@marvell.com> in private email on Feb 26 2010.  This
> is what I wrote back to him at the time:
>
> | mac80211.h says:
> |
> |  * @IEEE80211_HW_HAS_RATE_CONTROL:
> |  *      The hardware or firmware includes rate control, and cannot be
> |  *      controlled by the stack. As such, no rate control algorithm
> |  *      should be instantiated, and the TX rate reported to userspace
> |  *      will be taken from the TX status instead of the rate control
> |  *      algorithm.
> |  *      Note that this requires that the driver implement a number of
> |  *      callbacks so it has the correct information, it needs to have
> |  *      the @set_rts_threshold callback and must look at the BSS config
> |  *      @use_cts_prot for G/N protection, @use_short_slot for slot
> |  *      timing in 2.4 GHz and @use_short_preamble for preambles for
> |  *      CCK frames.
> |
> | In particular, the "need to report TX rate used in the TX status"
> | requirement is something that we don't do, which is why I didn't merge
> | the IEEE80211_HW_HAS_RATE_CONTROL change upstream yet.  (I know that
> | it improves performance, but performance is secondary to correctness.)
> |
> | One case where this is important is when you use tcpdump to look at
> | transmitted packets and at which rates they were transmitted for
> | debugging purposes -- tcpdump will report rates for each transmitted
> | packet just like for received packets, a la:
> |
> |         [...]
> |
> | In the situation before this patch, transmitted packets would be
> | reported at whatever rate minstrel chose for it (while the actual rate
> | on the air might be different), but after this patch, they will all
> | just be reported at 1 Mb/s, which is hardly better.
> |
> | If there is no way to find out what rate the firmware decided to
> | transmit at, what we should perhaps do is prevent a transmit rate from
> | being sent to userspace at all.  I.e. in the packet that tcpdump sniffs
> | from the packet socket, there should just not be a "Rate" field in the
> | Radiotap (www.radiotap.org) header at all.  We might be able to do this
> | by choosing a special value in the TX status indicating that we don't
> | know the TX rate, and then having mac80211 not generate a Rate field
> | when it encounters an invalid value -- at least that would be better
> | than reporting TX rates we know to be wrong.
>
> The general strategy of the s/w team on this project at the time
> appeared to be to send me patches, to totally ignore the feedback I
> would then provide on those patches, and then to submit the exact
> same patches again two months later in the hope that I would at some
> point just get tired of NAKing them and they would get merged by way
> of reviewer exhaustion.
>
> E.g. it's probably the 3th or 4th time that I get sent this patch now,
> and while I freely admit that my reasoning above for not having merged
> this patch yet may be faulty, noone has bothered to try to convince me
> that it is, all I get is just the exact same patch resubmitted every
> N months without any indication that the previous feedback has even
> registered.
>
> I have explained my objections against this patch in detail to Nishant
> in the past, and more than once.  Why has all that feedback just gone
> straight to /dev/null every single time?
>
>
> thanks,
> Lennert
>
