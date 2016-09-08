Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbcIHSBU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 14:01:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Petri Gynther <pgynther@google.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] mwifiex: fix unaligned read in mwifiex_config_scan()
References: <1471057200-58166-1-git-send-email-pgynther@google.com>
        <1471057200-58166-2-git-send-email-pgynther@google.com>
        <CAGXr9JFSUFr+mhyRnPk0pCeVsde4PUudZW+AZ44mKdT1iEpV6A@mail.gmail.com>
        <63fa0bf1951945bebc1d620c39a7c6e8@SC-EXCH04.marvell.com>
Date: Thu, 08 Sep 2016 21:01:13 +0300
In-Reply-To: <63fa0bf1951945bebc1d620c39a7c6e8@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Thu, 8 Sep 2016 16:10:14 +0000")
Message-ID: <8737laclue.fsf@purkki.adurom.net> (sfid-20160908_200124_963346_26895CFF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> > --- a/drivers/net/wireless/marvell/mwifiex/scan.c
>> > +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
>> > @@ -883,7 +883,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>> >                        sizeof(scan_cfg_out->specific_bssid));
>> >
>> >                 if (adapter->ext_scan &&
>> > -                   !is_zero_ether_addr(scan_cfg_out->specific_bssid))
>> {
>> > +                   !is_zero_ether_addr_unaligned(
>> > +                               scan_cfg_out->specific_bssid)) {
>> 
>> Any comments? Is this approach of adding
>> is_zero_ether_addr_unaligned() fine? We already have similar routine
>> ether_addr_equal_unaligned().
>> 
>> I don't see much benefit making a local, aligned copy here. It would
>> have to use memcpy w/ byte operations anyways and then still run
>> is_zero_ether_addr().
>> 
>> Amitkumar -- Is it possible to modify struct mwifiex_scan_cmd_config {}
>> and align specific_bssid field to u16 boundary?
>> 
>
> We can’t change the structure. The reason is firmware at receiving end
> expects the variables in the same order.
> is_zero_ether_addr_unaligned() should be fine.

If I understood correctly Dave doesn't like
is_zero_ether_addr_unaligned() so we can't use that either.

-- 
Kalle Valo
