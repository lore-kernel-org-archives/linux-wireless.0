Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56731 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2IOAvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 20:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WBLusFkQP-a9mCxM2Hu-NyWvUiF8iALY6YvvbV81eKNg@mail.gmail.com>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com> <CAB=NE6WBLusFkQP-a9mCxM2Hu-NyWvUiF8iALY6YvvbV81eKNg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Sep 2012 17:51:13 -0700
Message-ID: <CAB=NE6XYjYrRSA8Xupu21GWoCd-jv63ic32Q3rP7YiVHajTWTg@mail.gmail.com> (sfid-20120915_025141_021688_0FAF6D87)
Subject: Re: [PATCH 1/4] compat-drivers: update pending-stable patches.
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2012 at 3:28 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Fri, Sep 14, 2012 at 8:40 AM, Bala Shanmugam
> <bkamatch@qca.qualcomm.com> wrote:
>> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
>> ---
>
> Thanks but these patches do not apply on to the branch
> origin/origin/linux-3.6.y. They do however apply on top of the branch
> origin/linux-3.5.y... did you intend for these patches to be applied
> on top of that branch?
>
> Please be sure to do to be on top of commit
> 4f298ae180e84c6857af803177f82724ba6cf97c from the origin/linux-3.6.y
> branch if you want to send patches for that branch.
>
> Also, we now have a new mailing list, backports@vger.kernel.org,
> please subscribe and send future patches there.

After reviewing company e-mails I see you sent me there a note about
these being applicable to the linux-3.5.y branch. I applied them and
test compiled against ckmake. Compilation was OK except for the -sn
release and it fails at:

/home/mcgrof/staging/v3.5.3/compat-wireless-3.5.3-1-sn/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3974:3:
error: ‘AR_PHY_65NM_CH1_RXTX4’ undeclared (first use in this function)
/home/mcgrof/staging/v3.5.3/compat-wireless-3.5.3-1-sn/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3974:3:
note: each undeclared identifier is reported only once for each
function it appears in
/home/mcgrof/staging/v3.5.3/compat-wireless-3.5.3-1-sn/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3977:3:
error: ‘AR_PHY_65NM_CH2_RXTX4’ undeclared (first use in this function)
make[5]: *** [/home/mcgrof/staging/v3.5.3/compat-wireless-3.5.3-1-sn/drivers/net/wireless/ath/ath9k/ar9003_eeprom.o]
Error 1
make[5]: *** Waiting for unfinished jobs....

Now these guys are added through your crap/ patch.. but if you think
about this.. this means that you had AR_PHY_65NM_CH1_RXTX4 and the
other define used in code not yet upstream... I'm going to post that
patch to uncrap it and to fix these releases. I will also throw in
this patch into pending:

https://patchwork.kernel.org/patch/1441611/

  Luis
