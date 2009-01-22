Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:38989 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398AbZAVTln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 14:41:43 -0500
Received: by ey-out-2122.google.com with SMTP id 22so866576eye.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 11:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87priffb95.fsf@litku.valot.fi>
References: <87priffb95.fsf@litku.valot.fi>
Date: Thu, 22 Jan 2009 20:41:41 +0100
Message-ID: <2d0a357f0901221141k7e0c3979y1e42561b2e8636ec@mail.gmail.com> (sfid-20090122_204149_310147_2ED49164)
Subject: Re: iwl3945 regression: associates but no data is transfered
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I noticed the same regression here with iwl3945 and static-IP with
wl.git master 2009-01-21.

I tried to apply the iwlwifi-updates from 20-Jan-2009 (5 patches,
without the iwl3945-rfkill one, see below).
As far as I can see the patchset as of 19-Jan-2009 (15 patches) seem
to be all included in latest master.

There were two patches specially for 2.6.29 [1], but they were not
applicable in my case, so I took the ones from the older patchset.
But no luck here.

Johannes and Mohamed are discussing mac80211 disassociation on [2].

Hope these infos help.

Kind Regards,
Sedat

[1] http://marc.info/?l=linux-wireless&m=123256418517083&w=2
[2] http://marc.info/?l=linux-wireless&m=123264308904962&w=2


----- BEGIN series -----

# 00xx-series: All patches against wireless-testing (master-2009-01-21)
0000-patches-against-wl-v2.6.29-rc2-11925-g88e5942
#
# 01xx-series: Patches from <kernel.org>
0100-patch-2.6.29-rc2-git1
#
# 02xx-series: Patches from wl-mailing-list
0200-0_5-iwlwifi-driver-updates-01_20_2009.patch
0201-1_5-iwlwifi-fix-rs_get_rate-WARN_ON.patch
0202-2_5-iwlwifi-allow-user-to-set-max-rate.patch
0203-3_5-iwlagn-fix-agn-rate-scaling.patch
# Disabled - included in wl (master-2009-01-21)
#0204-4_5-iwl3945-Use-iwl-rfkill-v2.patch
0205-5_5-iwl3945-fix-deep-sleep-when-removing-the-driver.patch

----- END series -----

On Thu, Jan 22, 2009 at 7:26 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Hello,
>
> I upgraded to the latest wireless-testing and my iwl3945 is now
> broken. It can associate but no data is transfered after that. Tried
> with open and wep modes. With dhcp I cannot get ip and with static ip
> ping to the gateway doesn't work.
>
> Any hints?
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
