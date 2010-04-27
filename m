Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45387 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0D0Fkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 01:40:46 -0400
Received: by pwj9 with SMTP id 9so9056565pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 22:40:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <l2v8e92b4101004262232n344621f3ufcd861290d40157d@mail.gmail.com>
References: <1272007564-6265-1-git-send-email-vnatarajan@atheros.com>
	<4BD2696D.9030509@openwrt.org> <l2v8e92b4101004262232n344621f3ufcd861290d40157d@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Apr 2010 22:40:26 -0700
Message-ID: <j2g43e72e891004262240j71e773c7o41c26687337ed18@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Avoid corrupt frames being forwarded to mac80211.
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 10:32 PM, Vivek Natarajan
<vivek.natraj@gmail.com> wrote:
> On Sat, Apr 24, 2010 at 9:15 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-04-23 9:26 AM, Vivek Natarajan wrote:
>>> If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
>>> with WEP or TKIP, eventhough the received frame may be a CRC failed
>>> corrupted frame.
>>> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>>> index cd953f6..025c31a 100644
>>> --- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>>> +++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>>> @@ -249,7 +249,7 @@ static const u32 ar5416Common[][2] = {
>>>      { 0x00008258, 0x00000000 },
>>>      { 0x0000825c, 0x400000ff },
>>>      { 0x00008260, 0x00080922 },
>>> -    { 0x00008264, 0xa8000010 },
>>> +    { 0x00008264, 0x88000010 },
>> I don't think this is enough. This register is called
>> AR_MAC_PCU_LOGIC_ANALYZER and the field you're modifying
>> (AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768) is being touched by the function
>> ar9002_hw_enable_async_fifo() in ar9002_hw.c.
>> So unless this AR9287 v1.2 or later is unaffected by this issue, the
>> REG_SET_BIT call should be removed as well.
>> By the way, is this change in the other Atheros codebases as well?
>
> Yes. This change is present in other Atheros codebases as well and the
> REG_SET_BIT call is also present for AR9287. This is the feedback that
> I got from the Systems team regarding this register.
> "How H/W works is, if bit 29 is set, H/W obeys key type in keycache.
> If bit 29 is not set and if key type in keycache is neither open nor
> AES, H/W forces key type to be open. Since AsyncFIFO feature wants to
> encrypt/decrypt aggregate with WEP or TKIP, bit 29 should have been
> set to 1 after populating keycache with WEP or TKIP key type."

This would make that commit log entry for this patch actually a good
one. Would you mind massaging that a little and resending with some of
that added?

> Hence I suppose the REG_SET_BIT call needs to be there while enabling
> AsyncFIFO for AR9287.
>
> Vivek.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
