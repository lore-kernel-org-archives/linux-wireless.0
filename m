Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56516 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2GSBlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 21:41:06 -0400
Received: by wgbdr13 with SMTP id dr13so1895071wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 18:41:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342612598.5006a476022c6@mail.bluebottle.com>
References: <1342612598.5006a476022c6@mail.bluebottle.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 19 Jul 2012 03:40:44 +0200
Message-ID: <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com> (sfid-20120719_034110_905937_F1EE6101)
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
To: Bastian Bittorf <bittorf@bluebottle.com>
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 18, 2012 at 1:56 PM, Bastian Bittorf <bittorf@bluebottle.com> wrote:
> hi devs!
>
> yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
> hanging wifi and bad performance[5], but the workaround is easy: now it's up to
> you to fix the rootcause.
>
> our testsetup, where we could _reproduce_ reliably a stopping TX is like this:
>
> laptop ---lan--- "A"-wrt54g/adhoc ~~~   air  ~~~ "B"-anyrouter/adhoc
>
> now make a testdownload with the laptop from B.
> wireless will stop working after ~10 seconds.
>
> wifi up will reanimate and our freifunk-cron.minutely-check
> will do this automagically. (read further, this is not the solution)
>
> we tried to limit the rateset to e.g. lower rates, but this does NOT change
> the behaviour. what works is: define a rateset on BOTH router which makes
> it impossible to change the band, e.g.:
>
> iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11
> OR
> iw dev $WIFIDEV set bitrates legacy-2.4 6 9 12 18 24 36 48 54
>
> now we had a great performance, 10 Gigabytes of wireless transfer,
> no stopping TX anymore and an empty box of beer. three things to do now:
>
> 1) why does a band change (can be seen through minstrel) is a problem?

Because IIRC b43 doesn't support anything other than 2.4GHz at all.

>
> 2) we have to make in config-option to force a band, or a rateset:
>         e.g. uci set wireless.radio0.hwmode=11g
>         e.g. uci set wireless.radio0.bitrates='6 9 12 18 24 36 48 54'
>
> 3) spread to word:
>    there is a great frustration in the community about b43,
>    but the old drivers _have_ to die, it's about time - really.
>
> thanks for your work,
> bye storchi, andi, bastian + m18 crew
>
> [1] http://blog.maschinenraum.tk/
> [2] http://blog.maschinenraum.tk/2012/07/15/bitcoin-vending-machine-exchange-euro-coins-for-bitcoin-wallets/
> [3] http://wireless.subsignal.org
> [4] http://wireless.subsignal.org/index.php?title=Main_Page_en
> [5] https://dev.openwrt.org/ticket/7552
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
