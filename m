Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f184.google.com ([209.85.212.184]:55947 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZJXDMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 23:12:23 -0400
Received: by vws14 with SMTP id 14so509455vws.33
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 20:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091023163001.GA4911@jm.kir.nu>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
	 <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
	 <20091022161021.GA5532@jm.kir.nu>
	 <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
	 <389827.53102.qm@web51401.mail.re2.yahoo.com>
	 <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com>
	 <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
	 <20091023163001.GA4911@jm.kir.nu>
Date: Sat, 24 Oct 2009 05:12:27 +0200
Message-ID: <133e8d7e0910232012g718dae3kf297bf5d2301b48@mail.gmail.com>
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
	associate with AP
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Jouni Malinen <j@w1.fi>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/23 Jouni Malinen <j@w1.fi>:
> On Fri, Oct 23, 2009 at 05:27:27PM +0200, Björn Smedman wrote:
>
>> It seems the problem is a typo in net/mac80211/tx.c that causes
>> injected frames from hostapd not to be associated with the correct ap
>> interface before going into ieee80211_tx_h_sequence(). This tiny patch
>> solves my problems (and looks reasonable to me in any case):
>
> Thanks! Would you be able to make the same patch against the
> wireless-testing.git repository and add a Signed-off-by line to meet the
> kernel submission requirements?

It's time i learn. :) I'll give it a shot tomorrow.

>
>> diff -urN compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx.c
>> compat-wireless-2009-10-21/net/mac80211/tx.c
>> @@ -1445,7 +1445,7 @@
>>                                 if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
>>                                         continue;
>>                                 if (compare_ether_addr(tmp_sdata->dev->dev_addr,
>> -                                                      hdr->addr2)) {
>> +                                                      hdr->addr2) == 0) {
>>                                         dev_hold(tmp_sdata->dev);
>>                                         dev_put(sdata->dev);
>>                                         sdata = tmp_sdata;
>
> This does indeed look like a typo. Though, I'm not sure how this would
> have caused a regression between compat-wireless-2009-06-02 and
> compat-wireless-2.6.32-rc1. The incorrect compare_ether_addr() use seems
> to be there in the original commit that added this code
> (25d834e16294c8dfd923dae6bdb8a055391a99a5 from September 12, 2008)..

Interesting puzzle. :) It looks like there was a complementary bug
(the pointer hdr was set to point len_rthdr * sizeof(struct
ieee80211_hdr) bytes into the skbuff) in that commit:
...
+		len_rthdr = ieee80211_get_radiotap_len(skb->data);
+		hdr = (struct ieee80211_hdr *)skb->data + len_rthdr;
...
So the frame source address used to be compared with random data which
was likely to result in inequality, causing the first ap interface to
be "found" and the code to work as expected. I guess the pointer bug
was fixed somewhere between 2006-06-02 and now "causing" the sequence
number problem.

/Björn
