Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37335 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcGTMWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 08:22:31 -0400
Received: by mail-wm0-f54.google.com with SMTP id i5so66131182wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 05:22:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <900ae7541c5a4194a2f73479e1dd8bb2@aphydexm01b.ap.qualcomm.com>
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
 <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
 <CA+BoTQnUvF2Zy7_WuEi0V+KjByRghVmoeR6yrs6hu6ag=KmBqQ@mail.gmail.com>
 <20160627143600.GA5292@atheros-ThinkPad-T61> <CA+BoTQn+HeishCMf4hjpWjLBmvFG2r0gosBv77RTyk7+uOAvPA@mail.gmail.com>
 <20160629094754.GA8867@atheros-ThinkPad-T61> <CAD2nsn3TOSaOCmm5YT6_D+aaoH9=pagQamDDz2VT+nKrFH0K8g@mail.gmail.com>
 <900ae7541c5a4194a2f73479e1dd8bb2@aphydexm01b.ap.qualcomm.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 20 Jul 2016 14:22:29 +0200
Message-ID: <CA+BoTQmHW=uYompSLXUv2d+-Nr=11KYuA=VrmUz6X2T+D=-=Ag@mail.gmail.com> (sfid-20160720_142235_098470_C43DD12E)
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2016 at 13:43, Shajakhan, Mohammed Shafi (Mohammed Shafi)
<mohammed@qti.qualcomm.com> wrote:
> Michal,
>
> Can you please let me know if this change is fine or not ?
> I am waiting infinitely for  your reply long time

Sorry. I was absent for a while and this email slipped by.

Quoting your other email:

> is this patch is good to go (or) should i re-work  ?
> I had replied to Michal's comment of introducing a new firmware
> feature flag will not address the issue in older firmware / code.
> Let me know if i had missed something very obvious.

I couldn't really find any conclusion to this thread in my inbox.

The hw_params approach is definitely wrong. The ACK problem is
firmware-specific, not hardware-specific.

I'm fine with removing the workaround completely if 636 is guaranteed
to not be broken, including AP and P2P GO operation. The client
operation will probably work since wmi-roam event is used for HW
connection monitoring.

Nullfunc tx-status ack/noack reports could be probably fixed up using
sta kickout events (with short timeouts) as a fallback. This would
make it easier for users because otherwise they'd need to enable
disassoc_low_ack in hostapd (which is probably impossible with
wpa_supplicant for p2p, no?).


Michał
