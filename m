Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KPQCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 11:02:06 -0500
Received: by ywt32 with SMTP id 32so4971667ywt.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 08:02:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116153929.GA5490@redhat.com>
References: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
	<20111116153929.GA5490@redhat.com>
Date: Wed, 16 Nov 2011 17:02:05 +0100
Message-ID: <CAGXE3d8ojJ-COy+UYrav9=EA7toVi7rEOBHMnC1EvOpRvGjF7g@mail.gmail.com> (sfid-20111116_170211_417843_30BA1840)
Subject: Re: [PATCH 1/3] mac80211: Minor optimization in minstrel_ht tx status path
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 4:39 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Nov 14, 2011 at 03:28:18PM +0100, Helmut Schaa wrote:
>> @@ -421,8 +421,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
>>               mi->sample_packets += info->status.ampdu_len;
>>
>>       for (i = 0; !last; i++) {
>> -             last = (i == IEEE80211_TX_MAX_RATES - 1) ||
>> -                    !minstrel_ht_txstat_valid(&ar[i + 1]);
>> +             last = !minstrel_ht_txstat_valid(&ar[i + 1]) ||
>> +                    (i == IEEE80211_TX_MAX_RATES - 1);
> This make possible that we read outsite from ar[] border. Normally
> that should not couse any troubles, but I think it could confuse
> something like kmemcheck. Perhaps whould be better to just add
> unlikely(i == IEEE80211_TX_MAX_RATES - 1) ?

Indeed, you're right. John, please drop this patch. The other two are
still fine.

Thanks,
Helmut
