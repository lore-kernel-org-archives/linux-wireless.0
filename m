Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35992 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbZDOKpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 06:45:19 -0400
Received: by bwz17 with SMTP id 17so2830187bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 03:45:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
Date: Wed, 15 Apr 2009 11:45:17 +0100
Message-ID: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com> (sfid-20090415_124529_804957_7A2EAE95)
Subject: =?windows-1252?Q?net=2Fwireless=2Freg=2Ec=3A1196=3A_warning=3A_=91channel=5Fafter?=
	=?windows-1252?Q?=92_may_be_used_uninitialised_in_this_function?=
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguz@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/10/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> Thanks pavel, please try this patch:
>
> From 94505af850bd0961a86e2786238ac0bbe0c44615 Mon Sep 17 00:00:00 200=
1
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date: Fri, 10 Apr 2009 11:07:43 -0700
> Subject: [PATCH] cfg80211: fix bug while trying to process obeacon hi=
nts on
> init
>
> During initialization we would not have received any beacons
> so skip processing reg beacon hints, also adds a check to
> reg_is_world_roaming() for last_request before accessing its
> fields.

Hi again

I'm building wireless-testing to test the rfkill-rewrite patches on
top of.  I need to apply the patch referenced above as well.

When I applied the above patch, I noticed this unrelated warning

net/wireless/reg.c: In function =91wiphy_update_regulatory=92:
net/wireless/reg.c:1196: warning: =91channel_after=92 may be used
uninitialised in this function
net/wireless/reg.c:1196: note: =91channel_after=92 was declared here
net/wireless/reg.c:1196: warning: =91channel_before=92 may be used
uninitialised in this function
net/wireless/reg.c:1196: note: =91channel_before=92 was declared here

Looking at the code, I think it does need fixing.  There's even a
comment which says "this finds them (or not)" - and if they're not
found, channel_before / channel_after will be unset.

Regards
Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
