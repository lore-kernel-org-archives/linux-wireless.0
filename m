Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:34160 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727665AbeHFXyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 19:54:04 -0400
Received: from mr6.cc.vt.edu (mr6.cc.vt.edu [IPv6:2607:b400:92:8500:0:af:2d00:4488])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w76Lh2O9015913
        for <linux-wireless@vger.kernel.org>; Mon, 6 Aug 2018 17:43:02 -0400
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com [209.85.216.197])
        by mr6.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w76LgvWJ025160
        for <linux-wireless@vger.kernel.org>; Mon, 6 Aug 2018 17:43:02 -0400
Received: by mail-qt0-f197.google.com with SMTP id k21-v6so11587561qtj.23
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2018 14:43:02 -0700 (PDT)
From: valdis.kletnieks@vt.edu
To: YueHaibing <yuehaibing@huawei.com>
Cc: pkshih@realtek.com, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        colin.king@canonical.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: btcoex: Fix if == else warnings in halbtc8723b2ant.c
In-Reply-To: <20180806045440.11920-1-yuehaibing@huawei.com>
References: <20180806045440.11920-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1533591774_2560P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Mon, 06 Aug 2018 17:42:55 -0400
Message-ID: <63216.1533591775@turing-police.cc.vt.edu> (sfid-20180806_234308_889615_9C218B7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1533591774_2560P
Content-Type: text/plain; charset=us-ascii

On Mon, 06 Aug 2018 12:54:40 +0800, YueHaibing said:
> Fix following coccinelle warning:
>
> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2952:2-4: WARNING: possible condition with no effect (if == else)

>  	/* sw mechanism */
>  	if (BTC_WIFI_BW_HT40 == wifi_bw) {
> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
> -						  false, false);
> -		} else {
> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
> -						  false, false);
> -		}
> +		btc8723b2ant_sw_mechanism(btcoexist, true, true,
> +					  false, false);
>  	} else {

Rather than blindly fixing this, perhaps a bit of thought needs to be
applied to why this code looks like this in the first place.

See commit c6821613e653a  (which looks like the bletcherous "do too many
things at once" commit indeed), although the actual diff appears to be a
"no harm, no foul" against this commit, where the issue already existed.

commit aa45a673b291fd761275493bc15316d79555ed55
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Fri Feb 28 15:16:43 2014 -0600

    rtlwifi: btcoexist: Add new mini driver

Larry? Can you reach back to 2014 and remember why this code
looked like this in the first place?


--==_Exmh_1533591774_2560P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBW2jA3o0DS38y7CIcAQJ/jAf/XmviMxCyZhpbRc1fx3+jtXSa4o7GqWGZ
TK1ifksSAuGpytynZM6izSYTnwhHR68SSNflqpyhsDrT3ebNgYAtQHIDitMNtNQB
XWeNyL2OLoMsMX2F/ifU6UfO5jclfi/0bBdpHqM7IJaHfU42kjrvCqlRu5CqH/BD
a/K/c62EmGnR8LSy5em1P/39KePU22xEHylw3cq92uunKg5mhm3/TDOvzRyJGuqE
52D2RCrgJRrNqfZpDaxOC5QZTsLdC8XvQLwYiWzO6Hb3/LGZtuX4ZC8yOCIkeVfU
Jkgjf+D18Y9wBc5F/B8GwzvTebKfgepyZerK4YMgOuitE/ReR+byCA==
=0wn3
-----END PGP SIGNATURE-----

--==_Exmh_1533591774_2560P--
