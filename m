Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:55371 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032915AbeCARWa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 12:22:30 -0500
Subject: Re: [PATCH net-next 1/2] mac80211_hwsim: Make hwsim_netgroup IDA
To: Kirill Tkhai <ktkhai@virtuozzo.com>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
 <151990380915.5011.5476607741974762054.stgit@localhost.localdomain>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <9a826ac0-1354-567b-ec4c-ac8511bf89f6@uni-rostock.de> (sfid-20180301_182239_275280_49D7FEA9)
Date: Thu, 1 Mar 2018 18:22:26 +0100
MIME-Version: 1.0
In-Reply-To: <151990380915.5011.5476607741974762054.stgit@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 01.03.2018 um 12:30 schrieb Kirill Tkhai:

> Out of bounds of this patch, just as a report to wireless subsystem
> maintainer, destroy_radio() increaments hwsim_radios_generation
> without hwsim_radio_lock, so this may need one more patch to fix.
>
The lock is here implicit, because the value only could change at init
(where netlink callbacks are deactivated and always happens sequential)
or in netlink callbacks. The only reader of this variable is the dump
callback, and the only other writers are also netlink callbacks and
because they are implicitly not parallel (because the parallel flag is
not set), there could be no race condition. Maybe this should be
documented somehow, especially if somebody got the idea to allow
parallel callbacks :-)

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
