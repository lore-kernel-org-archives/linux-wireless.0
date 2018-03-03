Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:59943 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbeCCIBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Mar 2018 03:01:48 -0500
Date: Sat, 3 Mar 2018 09:01:42 +0100
In-Reply-To: <5319c18f-ce39-0d4c-e140-50b48b73803f@virtuozzo.com>
References: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain> <151990380915.5011.5476607741974762054.stgit@localhost.localdomain> <9a826ac0-1354-567b-ec4c-ac8511bf89f6@uni-rostock.de> <5319c18f-ce39-0d4c-e140-50b48b73803f@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: Re: [PATCH net-next 1/2] mac80211_hwsim: Make hwsim_netgroup IDA
To: Kirill Tkhai <ktkhai@virtuozzo.com>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Message-ID: <BDC4B82F-94DD-4580-B216-7F75AF189C3A@uni-rostock.de> (sfid-20180303_090405_355168_4562F7CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 2=2E M=C3=A4rz 2018 12:37:25 MEZ schrieb Kirill Tkhai <ktkhai@virtuozzo=
=2Ecom>:
>destroy_radio() may be executed in parallel with everything above you
>wrote,
>doesn't it? There may be several network namespaces, and
>destroy_radio()
>queued from one net namespace may race with mac80211_hwsim_new_radio()
>or hwsim_del_radio_nl() for another net namespace=2E I don't see, how
>netlink
>locking can act on synchronization with a work=2E This is what I mention=
=2E
>
I see, you are right=2E Nonetheless, this value is pretty uncritical, sinc=
e the user (the netlink dump) only checks whether it changes within a dump =
and even if there would be race conditions, e=2Eg=2E some generations would=
 be skipped caused by parallel writing, it would also set the dump interrup=
ted flag, and the user space program knows, if it needs exact results, it n=
eeds to dump again=2E I'm unsure about things like caching of this variable=
=2E Maybe it needs a volatile flag to work always as expected=2E

Unfortunately, currently the code triggers a dump interrupted also when th=
e interfaces of the current namespace didn't change, but I think that is ac=
ceptable=2E Otherwise we need a per namespace generation and I think all th=
is happens really rare and it's not worth the effort=2E


>Thanks,
>Kirill

--=20
M=2ESc=2E Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotec=
hnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin=2EBeichler@uni-rostock=2Ede
www: http://www=2Eimd=2Euni-rostock=2Ede/
