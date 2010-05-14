Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35186 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab0ENGjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 02:39:53 -0400
Received: by pzk42 with SMTP id 42so1190739pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 23:39:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimgcy5UV-snifCoduVOyhooS_1X7tn_HxKTXQ6w@mail.gmail.com>
References: <AANLkTimgcy5UV-snifCoduVOyhooS_1X7tn_HxKTXQ6w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 13 May 2010 23:39:33 -0700
Message-ID: <AANLkTilzdQ-lf_CFu9PbtHHUSHtzwJa_TskcGQ0JM2HW@mail.gmail.com>
Subject: Re: Architecture for wireless driver development in the Linux
	environment
To: Madhavi Manchala <madhavi.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 11:23 PM, Madhavi Manchala
<madhavi.linux@gmail.com> wrote:
> Dear Experts,
>
> I am new to the wireless driver development in the Linux environment.
> I have gone through the http://wireless.kernel.org/ link about the
> wireless driver development in the Linux environment. However, I did
> not find any architecture or skeleton driver like usb-skeleton.c file
> either in the drivers/Documentation or in the mentioned link. I want
> to develop a driver for USB WIFI device for x86 architecture. Please
> let me where can find the USB WIFI driver development architecture in
> the Linux environment.

You can look at:

drivers/net/wireless/mac80211_hwsim.c

> http://wireless.kernel.org/en/developers/Documentation/cfg80211
> What is cfg80211? Are we need to follow this configuration method for
> developing the drivers in the Linux environment?

Its what defines the generic data structure for all 802.11 devices,
both FullMAC and SoftMAC, it also defines the new API for 802.11 for
Linux, you register your struct wiphy device to cfg80211, your driver
has cfg80211_ops and you use nl80211 to communicate to cfg80211 from
userspace for a wiphy device or just generally to cfg80211 (for iw reg
get/set).

  Luis
