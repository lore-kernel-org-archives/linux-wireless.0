Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:61773 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeAVOtq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 09:49:46 -0500
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
 <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
 <1516018472.410.16.camel@sipsolutions.net>
 <3dd7a66e-1b55-0300-b04e-489ed1163b96@uni-rostock.de>
 <1516627401.2508.30.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <f9d585eb-2c32-5b54-9615-48f9f36c6647@uni-rostock.de> (sfid-20180122_154950_627652_0284353E)
Date: Mon, 22 Jan 2018 15:49:43 +0100
MIME-Version: 1.0
In-Reply-To: <1516627401.2508.30.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.01.2018 um 14:23 schrieb Johannes Berg:
> On Mon, 2018-01-15 at 15:48 +0100, Benjamin Beichler wrote:
>
>>>> +		if (get=5Fhwsim=5Fdata=5Fref=5Ffrom=5Faddr(
>>>> +				nla=5Fdata(info->attrs[HWSIM=5FATTR=5FPERM=5FADDR]))) {
>>>> +			pr=5Fdebug("mac80211=5Fhwsim: perm MAC already in use\n");
>>>> +			return -EINVAL;
>>>> +		}
>>> This is racy afaict - remove it and return a clash later when you fail
>>> to insert the new radio.
>> Ehm yes, actually exactly this test is already in the rhashtable patch.
>> But maybe I should also change there the error print to a NL=5FERR=5FMSG() =
=3F
> Oh, really=3F I just sent that out, but whatever, we have enough time to
> fix it :-)
Should I sent then the complete patch set again, or should I create a
new one based on your current mac80211next branch, excluding the
accepted patches =3F

> And yes, using netlink extended ack messages here as well would be
> good.
>
> johannes
>
Benjamin

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
