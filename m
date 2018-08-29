Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728237AbeH2OXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 10:23:55 -0400
Date: Wed, 29 Aug 2018 12:27:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
Message-ID: <20180829102737.GA20763@redhat.com> (sfid-20180829_122753_889597_87F1D09B)
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sid

On Wed, Aug 29, 2018 at 02:26:44AM +0000, Sid Hayn wrote:
> Thanks for working on this, I have a small stack of different devices
> covered by this driver which I'm excited to test with.
> 
> I'm running wireless-testing which may or may not be fully up to date
> on the patches you have sent (head is at
> c9cd161770dd1866207b70d41ec03c9a26eea94f from Aug 13th), so please
> tell me if this has already been fixed.  I have a script that attempts
> to connect to 16 differently configured SSIDs using 33 different (yet
> compatible) wpa_supplicant.conf files and reports failures to me.
> It's hardly perfect, but it gives me an idea if something is obviously
> broken and needs a deeper dive.  When I run this script against a
> device supported by mt76x2 or mt76x0 I get an unusual error.
> Everything goes fine, connect, dhcp, disconnect, connect, dhcp,
> disconnect, but after about 5 or 6 connections I start getting errors
> like this during wpa_supplicant:
> 
> Could not set interface t2uh flags (UP): No space left on device
> nl80211: Could not set interface 't2uh' UP
> nl80211: deinit ifname=t2uh disabled_11b_rates=0
> t2uh: Failed to initialize driver interface
> 
> and then this with dhcpcd:
> 
> dhcpcd_prestartinterface: t2uh: No space left on device
> t2uh: waiting for carrier
> 
> the same happens with just ifconfig up:
> 
> SIOCSIFFLAGS: No space left on device

This looks like some memory leak, not sure where, but it quite probable
that is in the m76x{0,2} driver. You can check periodically using 'free'
command (or in more details by 'cat /proc/meminfo') if memory is
leaking. Then compile kernel with CONFIG_DEBUG_KMEMLEAK to see where
the leak happen.

Regards
Stanislaw
