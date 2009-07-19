Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:49101 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZGSNiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 09:38:11 -0400
Received: by yxe14 with SMTP id 14so2929486yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 06:38:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A612514.4050708@redfish-solutions.com>
References: <4A612514.4050708@redfish-solutions.com>
Date: Sun, 19 Jul 2009 09:38:11 -0400
Message-ID: <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 9:27 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:
> + modprobe ath5k
> ath5k phy0: Atheros AR5413 chip found (MAC: 0xa4, PHY: 0x61)
>
> + iw dev wlan0 interface add ap0 type managed
> + ip link set ap0 up
> + iw dev ap0 connect xxxx
> command failed: Operation not supported (-95)

Why are you adding another interface?  Should be able to use "iw dev wlan0..."

> pbx ~ # iw phy phy0 info
> command failed: No buffer space available (-105)

Means the netlink buffer was exceeded.  In the past this was because there
were too many channels -- are you sure you're loading the compat-wireless
ath5k instead of the .29 one (and not using all_channels modparam)?

-- 
Bob Copeland %% www.bobcopeland.com
