Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbeDMNsk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 09:48:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: akolli@codeaurora.org, Marek Lindner <mareklindner@neomailbox.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        ath10k@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] ath10k: Implement get_expected_throughput callback
References: <1521814034-17880-1-git-send-email-akolli@codeaurora.org>
        <2322769.sx4MhzsvNg@bentobox>
        <7428dc3685e146dca147805b6a1bc5d2@codeaurora.org>
        <1580002.5HauTVtcdp@bentobox>
Date: Fri, 13 Apr 2018 16:48:34 +0300
In-Reply-To: <1580002.5HauTVtcdp@bentobox> (Sven Eckelmann's message of "Wed,
        28 Mar 2018 08:37:57 +0200")
Message-ID: <87lgdrqkst.fsf@kamboji.qca.qualcomm.com> (sfid-20180413_154844_715421_E576F4EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> On Mittwoch, 28. M=C3=A4rz 2018 11:41:51 CEST akolli@codeaurora.org wrote:
> [...]
>> The rate average and throughput are relative. no?
>
> In the sense that rate has a tendency to affect the expected throughput -=
 yes.=20
> But it is not like the expected throughput perfectly correlates with the =
rate=20
> and you only have to multiply with a factor X (which seems to be missing =
in=20
> your code) to get from rate to expected throughput. The average packet lo=
ss=20
> for this selected rate, interframe spacing and the aggregation are import=
ant=20
> factors here too.

I doubt we can get that information from the firmware so should we just
go with the "multiple with X" method? What would be good X?

> But of course, I cannot say much about how the rate control from QCA work=
s and=20
> in which form these information are already available.
>
> If you want to know the average PHY rate then wouldn't it be better to re=
port=20
> the rates to one of the upper layers and let them to the averaging? Simil=
ar to=20
> what there already is for NL80211_STA_INFO_CHAIN_SIGNAL=20
> (NL80211_STA_INFO_CHAIN_SIGNAL_AVG) just for NL80211_STA_INFO_TX_BITRATE/
> NL80211_STA_INFO_RX_BITRATE. Not sure whether this makes sense or whether=
=20
> someone has an use-case for it.

Sounds like a good idea, but I don't see it preventing to apply this
patch. We can always change the implementation later as this is just
communication between ath10k and mac80211, right?

--=20
Kalle Valo
