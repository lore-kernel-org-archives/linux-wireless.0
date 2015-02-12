Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40018 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbBLHQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 02:16:22 -0500
Received: by mail-we0-f169.google.com with SMTP id k48so8167271wev.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 23:16:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423660672.4847.15.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	<1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	<1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com>
	<1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
	<1422926330.21689.138.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQkMikA8wxm1ce2DkKhPB0HiKeAqT7f+sQ=91W40z=X0Rg@mail.gmail.com>
	<1422973660.907.10.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQmvUuFdfYF=wVMYxrf_nQZB5GCV=LvDZVvfs-3hAE4WKw@mail.gmail.com>
	<1423051045.907.108.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=BDcQ779uKCuX+f40=4npXVF4MTQnpjKimNYAxPsxBoQ@mail.gmail.com>
	<1423053531.907.115.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=qmCZz4CmSOvCOzMLowrDEG12XBffkTcYxjGqVD9604g@mail.gmail.com>
	<1423055810.907.125.camel@edumazet-glaptop2.roam.corp.google.com>
	<1423056591.907.130.camel@edumazet-glaptop2.roam.corp.google.com>
	<1423084303.31870.15.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=u_xPuqTVOVaFTQNRrJ+UTXe89SY+=+7Y1LpxxrkRDfg@mail.gmail.com>
	<1423574079.28434.21.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQkRp38nttSJgKs4dzQrn-TXpPbh4i-01YCF0BJQWrFi=Q@mail.gmail.com>
	<1423660672.4847.15.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Thu, 12 Feb 2015 08:16:20 +0100
Message-ID: <CA+BoTQn6ane-jSFxVhQd5BDCNUrATohCbtrD9zUJBMxnN6Zy6w@mail.gmail.com> (sfid-20150212_081644_713174_950D0ADF)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Eyal Perry <eyalpe@dev.mellanox.co.il>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 February 2015 at 14:17, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2015-02-11 at 09:33 +0100, Michal Kazior wrote:
>
>> If I set tcp_limit_output_bytes to 700K+ I can get ath10k w/ cushion
>> w/ aggregation to reach 600mbps on a single flow.
>
> You know, there is a reason this sysctl exists in the first place ;)
>
> The first suggestion I made to you was to raise it.
>
> The default setting must stay as is as long default Qdisc is pfifo_fast.
>
> I believe I already mentioned skb->truesize tricks for drivers willing
> to adjust the TSQ given their constraints.

Right. truesize didn't help in my early tests and once the cushion
thing came about I had assumed that it's not relevant anymore.

I just checked:

@@ -2620,6 +2621,12 @@ static void ath10k_tx(struct ieee80211_hw *hw,
        if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
                ath10k_dbg(ar, ATH10K_DBG_MAC,
"IEEE80211_TX_CTL_NO_CCK_RATE\n");

+       if (skb->sk) {
+               u32 trim = skb->truesize - (skb->truesize / 8);
+               skb->truesize -= trim;
+               atomic_sub(trim, &skb->sk->sk_wmem_alloc);
+       }

With this I get 600mbps on a single flow. The /2 wasn't enough (it
barely made a difference, 250->300mbps). The question is how do I know
how much of trimming is too much? Could the tx completion delay be
used to compute the trim factor, hmm..

Maybe this should be done in mac80211 as well?


Michał
