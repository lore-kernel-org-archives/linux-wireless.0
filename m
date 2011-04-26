Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1DZWDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 18:03:23 -0400
Received: by iyb14 with SMTP id 14so886006iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 15:03:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim45NHT3o2mB7Ofb9KvqBDrGjJcaw@mail.gmail.com>
References: <1303849642-9014-1-git-send-email-arik@wizery.com> <BANLkTim45NHT3o2mB7Ofb9KvqBDrGjJcaw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 27 Apr 2011 01:03:08 +0300
Message-ID: <BANLkTikMMMck78MhFuFNqc+CrUBGpG+TxQ@mail.gmail.com> (sfid-20110427_000326_678090_8D674A16)
Subject: Re: [PATCH] mac80211: report MIC failure for truncated packets in AP mode
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 23:55, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tue, Apr 26, 2011 at 10:27 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> MIC failure notifications for packets too short to contain a key index
>> are currently ignored in AP-mode. Fix the check to only ignore packets
>> with an existing non-zero key index.
>>
>> The wl12xx chip always truncates packets with a failed MIC and requires
>> this change to operate correctly in AP-mode.
>>
>> No such check is made in STA mode. Therefore its relatively safe to assume
>> there's no other HW that relies on the current code to avoid spurious
>> MIC failures with correct yet truncated packets.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>>  net/mac80211/rx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index a864890..875fc3c 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -2391,7 +2391,7 @@ static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
>>        if (!ieee80211_has_protected(hdr->frame_control))
>>                return;
>>
>> -       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
>> +       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx > 0) {
>>                /*
>>                 * APs with pairwise keys should never receive Michael MIC
>>                 * errors for non-zero keyidx because these are reserved for
>> --
> wait! Since you seem able to trigger MIC events frequently, could you
> please test if the following patch:
>
> <http://www.spinics.net/lists/linux-wireless/msg67571.html>
>
> <a little more info:http://www.spinics.net/lists/linux-wireless/msg67461.html>
>
> would help in your case as well?
>

I seem to have missed this thread entirely :)
The patch you mentioned does indeed help. I tested in STA and AP mode.

This bit is important for wl12xx:

+       /*
+        * No way to verify the MIC if the hardware stripped it or
+        * the IV with the key index. In this case we have solely rely
+        * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
+        * MIC failure report.
+        */
+       if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
+               if (status->flag & RX_FLAG_MMIC_ERROR)
+                       goto mic_fail;

This prevents us from getting to the problematic check that I tried to
remove with my patch.

Just for the record - generating a MIC failure is pretty easy. I'm
using the (very cool) mac80211 debugfs feature that allows simulating
a MIC failure (see ieee80211_if_parse_tkip_mic_test()).
It works well with a rt2x00 based card and the latest compat. I'm
simulating it from AP as well as STA.

To summarize - either patch will work for us.

Regards,
Arik
