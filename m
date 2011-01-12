Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48465 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALRG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 12:06:29 -0500
Received: by iwn9 with SMTP id 9so708416iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 09:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
Date: Wed, 12 Jan 2011 18:06:28 +0100
Message-ID: <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
Subject: Re: [RFC] ath9k: Handle interface changes properly
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> The commit ""ath9k: Add change_interface callback" was failed
> to update of hw opmode, ani and interrupt mask. This leads
> to break p2p functionality on ath9k. And the existing add and
> remove interface functions are not handling hw opmode and
> ANI properly.
>
> This patch combines the common code in interface callbacks
> and also takes care of multi-vif cases.

How does your patch handle the race condition between the interface
change done in process context and the beacon tasklet triggered by
SWBA?

Also, perhaps more applicable to the commit log than the patch, how
can opmode be properly handled in multi-vif cases? I mean let's say I
have two AP vifs and then change one into STA, is the opmode then STA?
Compare that to the case where I have two STA vifs and change one into
AP; so again I have one AP and one STA vif but this time opmode is AP,
right? I can see how I can be wrong about these examples but I can't
really see how the opmode concept can be properly handled in multi-vif
cases.

/Björn
