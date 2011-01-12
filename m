Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43387 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab1ALTAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 14:00:04 -0500
Received: by iwn9 with SMTP id 9so818942iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 11:00:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19757.58191.865301.805439@gargle.gargle.HOWL>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
	<AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
	<19757.58191.865301.805439@gargle.gargle.HOWL>
Date: Wed, 12 Jan 2011 20:00:03 +0100
Message-ID: <AANLkTimK2AkRYnZk70TNt5YWEzNPCoPHpT=pu1B6JZPN@mail.gmail.com>
Subject: Re: [RFC] ath9k: Handle interface changes properly
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Sujith <m.sujith@gmail.com>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/12 Sujith <m.sujith@gmail.com>:
> Björn Smedman wrote:
>> Also, perhaps more applicable to the commit log than the patch, how
>> can opmode be properly handled in multi-vif cases? I mean let's say I
>> have two AP vifs and then change one into STA, is the opmode then STA?
>> Compare that to the case where I have two STA vifs and change one into
>> AP; so again I have one AP and one STA vif but this time opmode is AP,
>> right? I can see how I can be wrong about these examples but I can't
>> really see how the opmode concept can be properly handled in multi-vif
>> cases.
>
> The opmode should be calculated every time an interface is created/destroyed.
>
> If an AP vif is already present when a STA is added, the opmode remains as AP.
> if a STA vif is changed into AP mode, then the opmode should be changed to AP,
> along with disabling PS for other STA interfaces.
> If an AP is present and a STA is added, the beacon interval can't be different.
> And there are a few other conditions as well...

Thank you Sujith for the clarification. When you lay out the cases it
makes more sense. But there are still border cases, like e.g. adding
first a STA and then an AP interface. If I read main.c correctly the
opmode will then be STA and the AP vif will be broken, right?

Wouldn't it be better to keep counts of number of vifs by type and
e.g. activate SWBA if (adhocvifs > 0 || apvifs > 0) and similar? Then
it wouldn't mater in which order vifs are added, removed and changed.

/Björn
