Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34241 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab3GWVgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 17:36:54 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so2157135wgh.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 14:36:53 -0700 (PDT)
Message-ID: <51EEF771.7030102@free.fr> (sfid-20130723_233656_907232_709F8AB3)
Date: Tue, 23 Jul 2013 23:36:49 +0200
From: Etienne Champetier <etienne.champetier@free.fr>
Reply-To: etienne.champetier@free.fr
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: Re: authsae, 'ath9k nohwcrypt=1' & AR9100
References: <800088722.345614075.1374079656592.JavaMail.root@zimbra65-e11.priv.proxad.net>
In-Reply-To: <800088722.345614075.1374079656592.JavaMail.root@zimbra65-e11.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Le 17/07/2013 18:47, etienne.champetier@free.fr a écrit :
> Hi
>
> I'm making some test with authsae on openrwt and for wr1043nd router (AR9100 wireless) i still need 'ath9k nohwcrypt=1'
> for the secure mesh to work when on another router (AR9280 wireless) i don't need it.
> Is it a drivers bug? or is it hardware?
>
> -Router A: wr1043nd (need nohwcrypt=1 option)
>   -AR9100 wireless
>   -authsae - 2013-06-25-e2f67612101dc83f2c459d8ddc75c34bc83e1e83 (https://github.com/cozybit/authsae/tree/e2f67612101dc83f2c459d8ddc75c34bc83e1e83)
>   -kmod-ath9k - 3.10.1+2013-06-27-1 (backports-20130617-4-ge3220f5)
>   -openwrt BB r37364
>
> -Router B: ubnt rspro
>   -AR9280 wireless
it's an AR9220 wireless (Mikrotik RB R52Hn), recognized as AR9280
>   -openwrt BB r37369 (same authsae/ath9k)
>
> Thanks in advance
> Etienne

This patch http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=a549459c96ba99a691aa1cafeabdd327a7a2bfcf
make AR9160 and previous (AR9100) run in promiscuous mode (in order to catch all frames), does this influence hardware encryption (hwcrypt)?

Thanks in advance
Etienne

