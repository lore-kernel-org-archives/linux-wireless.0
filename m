Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2BCOok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 09:44:40 -0500
Received: by wgbdt10 with SMTP id dt10so3919924wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 06:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2A8173.7050603@openwrt.org>
References: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com>
	<CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com>
	<CAD2nsn0c=cUdD8kQWNprGr7GJ6t1Y+c=LA2KZ+sSVgrsb3oedQ@mail.gmail.com>
	<20120201162730.GA29685@tuxdriver.com>
	<4F2970B3.4090203@openwrt.org>
	<CAD2nsn14odYg7AL1CD4KFymTAdC=h2YeM-WOok40ZNPnvVLD=w@mail.gmail.com>
	<4F2A8173.7050603@openwrt.org>
Date: Fri, 3 Feb 2012 15:44:38 +0100
Message-ID: <CAAJ3AHees2kDcZMBwTa22g2eFg9Aaz=tT+MTjkqwp0AZrzgOrQ@mail.gmail.com> (sfid-20120203_154443_688313_0C41DA2C)
Subject: Re:
From: Laurent Bonnans <bonnans.l@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It works for me too.

On Thu, Feb 2, 2012 at 1:28 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-02-02 6:37 AM, Mohammed Shafi wrote:
>> Hi Felix,
>>
>> On Wed, Feb 1, 2012 at 10:34 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2012-02-01 5:27 PM, John W. Linville wrote:
>>>> On Wed, Feb 01, 2012 at 04:44:08PM +0530, Mohammed Shafi wrote:
>>>>> On Tue, Jan 31, 2012 at 11:28 AM, Mohammed Shafi
>>>>> <shafi.wireless@gmail.com> wrote:
>>>>> > On Tue, Jan 31, 2012 at 1:13 AM, Laurent Bonnans <bonnans.l@gmail.com> wrote:
>>>>> >> Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
>>>>> >> some APs on my laptop with an AR9285 Wireless card.
>>>>> >>
>>>>> >> dhcp works fine on an open wifi network but receives no response on a
>>>>> >> wep network I use. I haven't been able to test it on a third network
>>>>> >> for now.
>>>>> >
>>>>> >  reverting  "ath9k_hw: fix interpretation of the rx KeyMiss flag" does
>>>>> > helps.  i  need to analyze
>>>>> > if it exposes some real issue which need to be fixed.
>>>>> >
>>>>>
>>>>> this seems to be a problem in WEP alone, where the key miss is always
>>>>> set for this case and RX_FLAG_DECRYPTED is not set. mac80211 trys to
>>>>> decrypt,  but fails due to ICV mismatch.
>>>>
>>>> OK...any way to differentiate this case at that point in the code?
>>>>
>>>> John
>>> Please try this patch:
>>>
>>> ---
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -823,6 +823,15 @@ static bool ath9k_rx_accept(struct ath_c
>>>                (ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
>>>                 ATH9K_RXERR_KEYMISS));
>>>
>>> +       /*
>>> +        * First 4 slots are reserved for WEP, and for packets using them,
>>> +        * ATH9K_RXERR_KEYMISS can be reported even though decryption was
>>> +        * successful, since no MAC address based key cache lookup was
>>> +        * performed.
>>> +        */
>>> +       if (rx_stats->rs_keyix < 4)
>>> +               rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
>>> +
>>>        if (!rx_stats->rs_datalen)
>>>                return false;
>>>         /*
>>
>>
>> unfortunately as the rx_keyix is always 'INVALID' (as obtained from
>> the descriptor) this check does not seems to help
> You're right. I read up on what the other codebases do here, and I have
> a better patch here:
>
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -823,6 +823,14 @@ static bool ath9k_rx_accept(struct ath_c
>                (ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
>                 ATH9K_RXERR_KEYMISS));
>
> +       /*
> +        * Key miss events are only relevant for pairwise keys where the
> +        * descriptor does contain a valid key index. This has been observed
> +        * mostly with CCMP encryption.
> +        */
> +       if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
> +               rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
> +
>        if (!rx_stats->rs_datalen)
>                return false;
>         /*
>
