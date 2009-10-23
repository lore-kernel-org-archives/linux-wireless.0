Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f184.google.com ([209.85.212.184]:44886 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZJWP1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 11:27:25 -0400
Received: by vws14 with SMTP id 14so339928vws.33
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 08:27:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
	 <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
	 <20091022161021.GA5532@jm.kir.nu>
	 <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
	 <389827.53102.qm@web51401.mail.re2.yahoo.com>
	 <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com>
Date: Fri, 23 Oct 2009 17:27:27 +0200
Message-ID: <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
	associate with AP
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>, Jouni Malinen <j@w1.fi>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

It seems the problem is a typo in net/mac80211/tx.c that causes
injected frames from hostapd not to be associated with the correct ap
interface before going into ieee80211_tx_h_sequence(). This tiny patch
solves my problems (and looks reasonable to me in any case):

diff -urN compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx.c
compat-wireless-2009-10-21/net/mac80211/tx.c
--- compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx.c
 2009-10-23 17:20:52.000000000 +0200
+++ compat-wireless-2009-10-21/net/mac80211/tx.c        2009-10-23
17:21:28.000000000 +0200
@@ -1445,7 +1445,7 @@
                                if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
                                        continue;
                                if (compare_ether_addr(tmp_sdata->dev->dev_addr,
-                                                      hdr->addr2)) {
+                                                      hdr->addr2) == 0) {
                                        dev_hold(tmp_sdata->dev);
                                        dev_put(sdata->dev);
                                        sdata = tmp_sdata;


/Björn

2009/10/23 Björn Smedman <bjorn.smedman@venatech.se>
>
> Hi all,
> Thanks for your help. I will also keep my tcpdumps to myself for now.
> Is anybody working on a fix? I suspect it's a misunderstanding between hostapd and mac80211 about who should set the sequence number on injected frames, correct? Could you describe the outlines of the appropriate patch so I could experiment and verify that this is my problem?
> /Björn
> On Fri, Oct 23, 2009 at 11:15 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
>>
>> Since Jouni has confirmed my suspicion about the invalid sequence number I will refrain from spamming the list with tcpdumps.
>> Will, thanks for bringing me into the loop of this discussion!
>>
>>  --
>> Regards
>> Joerg
>>
>>
>>
>
>
>
> --
> Venatech AB
> Ideon Innovation
> Ole Römers väg 12
> SE-22370 LUND
> Sweden
>
> +46 (0) 46 286 86 20
> info@venatech.se
> http://www.venatech.se
