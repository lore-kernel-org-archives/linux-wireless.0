Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56006 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1KPEQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 23:16:33 -0500
Received: by wyh11 with SMTP id 11so29559wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 20:16:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC28ABC.70307@neratec.com>
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
	<1320770044-12271-3-git-send-email-zefir.kurtisi@neratec.com>
	<CAD2nsn1a7rgvGGNYGjVsCdfGXVVzOYK-dM6ojV1+P5dsL6yYvA@mail.gmail.com>
	<4EC28ABC.70307@neratec.com>
Date: Wed, 16 Nov 2011 09:46:31 +0530
Message-ID: <CAD2nsn2jA6sHh5m-3fpOYddpm9Rm2WXNkTZBHqnGeT572XCiVw@mail.gmail.com> (sfid-20111116_051636_688012_F67720E4)
Subject: Re: [PATCH 2/2] ath9k: integrate initial DFS module
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

sure, thanks a lot for your explanation ;)

>
>
> Thanks
> Zefir
>



-- 
shafi
