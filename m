Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:64710 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753419AbeAOOjg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 09:39:36 -0500
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
 <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
 <1516018169.410.14.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <59cebd66-44ca-4bfd-0be2-a6d37c0bfa75@uni-rostock.de> (sfid-20180115_153940_499679_96A2B585)
Date: Mon, 15 Jan 2018 15:39:33 +0100
MIME-Version: 1.0
In-Reply-To: <1516018169.410.14.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.01.2018 um 13:09 schrieb Johannes Berg:
> On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
>
>> To do not break the operation with legacy software using hwsim, the ne=
w
>> address is set twice. The problem here is, the netlink call backs use
>> wiphy->addresses[1] as identification of a radio and not the proposed
>> permanent address (wiphy->addresses[0]). This design decision is not
>> documented in the kernel repo, therefore this patch simply reproduces =
this,
>> but with the same address.
> It's weird to have the same address twice - perhaps we can XOR 0x40 or
> so?
I really don't know, why there were 2 addresses introduced in the first
place, and why the netlink operations for receiving only check against
the second address and not the first address (see
get_hwsim_data_ref_from_addr). My suggestion would be, only allocate one
mac address and check against this one. I don't know, whether really any
user of hwsim rely on the structure, that an adapter needs two mac
addresses. Since this is part of the initial commit, this decision is
not documented in git ...
> johannes
>
>

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
