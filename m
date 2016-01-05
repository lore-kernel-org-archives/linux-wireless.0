Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35652 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbcAEPn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:43:56 -0500
Received: by mail-io0-f175.google.com with SMTP id 77so159396947ioc.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 07:43:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452008139.12357.32.camel@sipsolutions.net>
References: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
	<1452008139.12357.32.camel@sipsolutions.net>
Date: Tue, 5 Jan 2016 16:43:56 +0100
Message-ID: <CAGXE3d9TZbUF0k0moa_hzOUip9q5PgDSe0kDbiD1KCH7mjX+Ng@mail.gmail.com> (sfid-20160105_164400_287348_6CF8D4AE)
Subject: Re: [PATCH] mac80211: Don't buffer non-bufferable MMPDUs
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 5, 2016 at 4:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-01-05 at 15:37 +0100, Helmut Schaa wrote:
>> Non-bufferable MMPDUs are sent out to STAs even while in PS mode
>> (for example probe responses). Applying filtered frame handling for
>> these doesn't seem to make much sense and will only create more
>> air utilization when the STA wakes up. Hence, apply filtered frame
>> handling only for bufferable MMPDUs.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>  net/mac80211/status.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index 5bad05e..14bd53b 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -51,6 +51,12 @@ static void ieee80211_handle_filtered_frame(struct
>> ieee80211_local *local,
>>       struct ieee80211_hdr *hdr = (void *)skb->data;
>>       int ac;
>>
>> +     if (ieee80211_is_mgmt(hdr->frame_control) &&
>> +         !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
>> +             ieee80211_free_txskb(&local->hw, skb);
>> +             return;
>> +     }
>>
> I don't really see a problem per se with this patch, but it seems that
> we could just check the flags instead? Perhaps we simply shouldn't
> apply buffering filtered frames here to frames that were already marked
> with IEEE80211_TX_CTL_NO_PS_BUFFER, since those frames shouldn't be
> filtered by the driver to start with.

Good point, that should make the check a bit nicer. I'll change that.

> That said, it obviously also points to a driver bug not treating these
> frames correctly, so you might want to investigate why you got here to
> start with!

It was not the driver marking the frame as filtered but mac80211
itself in status.c:

                acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
                if (!acked && test_sta_flag(sta, WLAN_STA_PS_STA)) {
                        /*
                         * The STA is in power save mode, so assume
                         * that this TX packet failed because of that.
                         */
                        ieee80211_handle_filtered_frame(local, sta, skb);
                        rcu_read_unlock();
                        return;
                }

However, I've put the code into ieee80211_handle_filtered_frame to
not grow ieee80211_tx_status even more :)

If you prefer to add it here directly I'm fine to change it.

Helmut
