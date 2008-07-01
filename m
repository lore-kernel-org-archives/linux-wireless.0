Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:57491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYGAJR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 05:17:29 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2149265rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 02:17:29 -0700 (PDT)
Message-ID: <1ba2fa240807010217i1f420bc1n72da90b752bb52c6@mail.gmail.com> (sfid-20080701_111733_378414_88985780)
Date: Tue, 1 Jul 2008 12:17:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: add bar capability
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1214902332.7763.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
	 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
	 <1214899385.7763.9.camel@johannes.berg>
	 <1ba2fa240807010130t7641ec90o2ce95ec985b63125@mail.gmail.com>
	 <1214902332.7763.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2008 at 11:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >> + * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
>> >> + *   so consider using block ack request (BAR).
>> >
>> > This flag I don't understand. When does the driver set this? And what
>> > does mac80211 do to "consider", it seems to always just try to set up a
>> > block-ack session.
>>
>> This is required during BA session. BAR solicited Block ACK for the SN
>> and on specified in BAR. Driver will send it if it doesn't hear BACK.
>> Iwlwifi uses this BAR just says to the recipient that we were not able
>> to transmit the frame and we won't retransmit. This immediately shifts
>> recipient reordering buffer not waiting for high SN numbers of the
>> next traffic otherwise there will be visible deep in the throughput as
>> packets are not released to upper layer till all are received.
>
> Hm, ok, I don't think I understand the subtleties of the protocol. So
> when you have a BA session you have to send a BAR if you can't transmit
> a frame for some reason? When would that happen?

Driver should send BAR when it doesn't hear BACK. Iwlwifi requests
this only  when both aggregation and single frame retries are
exhausted.  See some APs sends this more often.

>
>> >> +     bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
>> >
>> > ??
>> >
>> >> +     bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
>> >> +     bar_control |= (u16)(tid << 12);
>> >> +     bar->control = cpu_to_le16(bar_control);
>> >> +     bar->start_seq_num = cpu_to_le16(ssn);
>> >> +
>> >> +     /* must be sent through voice AC */
>> >> +     skb->priority = 3;
>> >
>> > Does that actually work? The current wme.c code will still call
>> > classify_1d() and that will use the IP TOS unless you set the priority
>> > to 256..263.
>>
>> Good point. Have to look at this again we might missed this point when
>> moving this out from the driver to the mac8011.
>> Not sure this is classified at all as this is a control frame.
>
> Oh, hmm, yeah those work differently, non-data frames aren't classified
> at all and always go out on AC_VO regardless of what you set there so
> you can just remove that.

..okay I will remove this
Tomas
