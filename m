Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab1KOQ2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 11:28:08 -0500
Received: by fagn18 with SMTP id n18so566615fag.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 08:28:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC28ABC.70307@neratec.com>
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
 <1320770044-12271-3-git-send-email-zefir.kurtisi@neratec.com>
 <CAD2nsn1a7rgvGGNYGjVsCdfGXVVzOYK-dM6ojV1+P5dsL6yYvA@mail.gmail.com> <4EC28ABC.70307@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 15 Nov 2011 08:27:45 -0800
Message-ID: <CAB=NE6UtVye0JbZCi1bhFHy-gSQoETvhn70vs0Jd_5=0q_YiwQ@mail.gmail.com> (sfid-20111115_172824_210668_4ECC3F79)
Subject: Re: [PATCH 2/2] ath9k: integrate initial DFS module
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2011 at 7:52 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 11/15/2011 04:24 PM, Mohammed Shafi wrote:
>> Hi Zefir,
>>
>> just few doubt, sorry for the late reply
>>
>> On Tue, Nov 8, 2011 at 10:04 PM, Zefir Kurtisi
>> <zefir.kurtisi@neratec.com> wrote:
>>> This patch integrates the DFS module into ath9k, including
>>>  * build the module into ath9k_hw
>>>  * set up DFS debugfs
>>> @@ -1855,11 +1858,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>>                if (sc->sc_flags & SC_OP_RXFLUSH)
>>>                        goto requeue_drop_frag;
>>>
>>> -               retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
>>> -                                                rxs, &decrypt_error);
>>> -               if (retval)
>>> -                       goto requeue_drop_frag;
>>> -
>>>                rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
>>>                if (rs.rs_tstamp > tsf_lower &&
>>>                    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
>>> @@ -1869,6 +1867,17 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>>                    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
>>>                        rxs->mactime += 0x100000000ULL;
>>>
>>> +               if ((rs.rs_status & ATH9K_RXERR_PHY) &&
>>> +                   (rs.rs_phyerr == ATH9K_PHYERR_RADAR)) {
>>> +                       /* DFS: check for radar pulse */
>>> +                       ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
>>> +               }
>>> +
>>> +               retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
>>> +                                                rxs, &decrypt_error);
>>> +               if (retval)
>>> +                       goto requeue_drop_frag;
>>
>> does the above fixes any bug related to mactime displayed in sniffer
>>
>>
>
> Hi Mohammed,
>
> no, like all other modifications within this patch the above does not fix anything (at least not intentionally) ;)
>
> What it does is moving the calculation of rxs->mactime before ath9k_rx_skb_preprocess(), since the mactime is needed to stamp the radar event. So, the five lines marked as removals are actually moved further down which shouldn't have any side effects.

Zefir, can you split the patch so that the move of
ath9k_rx_skb_preprocess() call can clearly be marked as a separate
change, if a regressions should be introduced by the move the move
itself would be single regression instead of the entire DFS patch.

  Luis
