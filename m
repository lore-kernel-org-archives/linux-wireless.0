Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9111 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3KMNXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 08:23:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove htt rx amsdu clear retry bit hack
References: <20131113112810.5221.69685.stgit@localhost6.localdomain6>
	<CA+BoTQkLsbwEAX6RomC_ZA-rtL6q1Q871=9n-Mgry=AZgrKs6Q@mail.gmail.com>
Date: Wed, 13 Nov 2013 15:23:18 +0200
In-Reply-To: <CA+BoTQkLsbwEAX6RomC_ZA-rtL6q1Q871=9n-Mgry=AZgrKs6Q@mail.gmail.com>
	(Michal Kazior's message of "Wed, 13 Nov 2013 12:38:04 +0100")
Message-ID: <87bo1o77w9.fsf@kamboji.qca.qualcomm.com> (sfid-20131113_142341_611263_61555900)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> -       /* FIXME: Hopefully this is a temporary measure.
>> -        *
>> -        * Reporting individual A-MSDU subframes means each reported frame
>> -        * shares the same sequence number.
>> -        *
>> -        * mac80211 drops frames it recognizes as duplicates, i.e.
>> -        * retransmission flag is set and sequence number matches sequence
>> -        * number from a previous frame (as per IEEE 802.11-2012: 9.3.2.10
>> -        * "Duplicate detection and recovery")
>> -        *
>> -        * To avoid frames being dropped clear retransmission flag for all
>> -        * received A-MSDUs.
>> -        *
>> -        * Worst case: actual duplicate frames will be reported but this should
>> -        * still be handled gracefully by other OSI/ISO layers. */
>> -       hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_RETRY);
>> -
>>         first = skb;
>>         while (skb) {
>>                 void *decap_hdr;
>>
>
> You're missing RX_FLAG_AMSDU_MORE. All subframes (except the last one)
> from an A-MSDU that are reported separately must have the bit set in
> status->flag. Only then mac80211 can apply retransmission/duplication
> check properly.

I'll send v2, thanks for the review.

-- 
Kalle Valo
