Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36615 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbL2OTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 09:19:31 -0500
Received: by mail-lb0-f172.google.com with SMTP id oh2so104075313lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2015 06:19:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
Date: Tue, 29 Dec 2015 16:19:30 +0200
Message-ID: <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com> (sfid-20151229_151934_874371_AB02648C)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 29, 2015 at 3:01 PM, Cedric VONCKEN
<cedric.voncken@acksys.fr> wrote:
> Hi,
>
> My test plateform is:
> 2 equipements
> Both equipment used compat version 2015-07-21 from openwrt.
> Both equipment used security WPA2
>
> The equipment #1 is an AP.
>         The Group rekey interval is set to 3601s
>         The Pair rekey interval set to 50s (I reduced this value to show
> the issue often)
>         The Master rekey interval is set to 86400 s.
>
> The equipment #2 is a sta+wds
>
> I used a 5GHz channel to have a free channel (without other AP)
> I connected a computer on each equipment.
>
> To reproduce the issue:
>         I ran iperf udp@50Mbps from computer connected to the AP to the
> computer connected to the sta. After several WPA2 rekeying, iperf server
> side didn't received any frame.
>
> I investigated in the driver. All packets are dropped in sta side,
> because the function ieee80211_crypto_ccmp_decrypt return
> Rx_DROP_UNUSABLE. This function return this code because the test
> if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=0) return
> true.
>
> Have you any idea to fix this issue?
>

I don't remember exactly what we had, but you may look at
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/137742
