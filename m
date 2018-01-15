Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64879 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965130AbeAOO2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 09:28:37 -0500
Subject: Re: [PATCH v3 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
 <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de>
 <1516018121.410.13.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <3c846ba5-a017-1993-79c6-2e33d78dfcf4@uni-rostock.de> (sfid-20180115_152855_251094_AFA761B0)
Date: Mon, 15 Jan 2018 15:28:33 +0100
MIME-Version: 1.0
In-Reply-To: <1516018121.410.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.01.2018 um 13:08 schrieb Johannes Berg:
> On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
>>  Change the dump iteration to be independent from
>> increasing radio indices on radio list.
> You can't do that, data structures can be deleted while the dump is
> ongoing.
That's what I try to address with this patch. In the past there were
corner cases, which might have failed while deletion.

Nonetheless, the radio count is in the current version strictly
monotonic, maybe the description is misleading. :-)
So in the inner loop there is no deletion possible because of the
spinlock, and multiple calls of nl=5Fdump check the generation count and
cancel if it have changed.

>
> johannes
>

-- 
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotechnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
