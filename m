Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751043AbeFHNC7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 09:02:59 -0400
Date: Fri, 8 Jun 2018 15:02:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Subject: Re: WARNING: drivers/net/wireless/mediatek/mt7601u/phy.c:989
Message-ID: <20180608130255.GA12620@redhat.com> (sfid-20180608_150302_810130_BC77F6E7)
References: <20180608104323.vaw6vtbmxdut6yld@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180608104323.vaw6vtbmxdut6yld@angband.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2018 at 12:43:23PM +0200, Adam Borowski wrote:
> Hi!
> In mid-merge-window kernel I'm getting this warning in mt7601.  My tree,
> skipping certainly irrelevant extra patches, has merge-base with master at
> 289cf155d95df07ac1e692dfaa7036f10235c77c.
> 
> static void mt7601u_agc_tune(struct mt7601u_dev *dev)
> {
>         u8 val = mt7601u_agc_default(dev);
>         long avg_rssi;
> 
>         if (test_bit(MT7601U_STATE_SCANNING, &dev->state))
>                 return;
> 
>         /* Note: only in STA mode and not dozing; perhaps do this only if
>          *       there is enough rssi updates since last run?
>          *       Rssi updates are only on beacons and U2M so should work...
>          */
>         spin_lock_bh(&dev->con_mon_lock);
>         avg_rssi = ewma_rssi_read(&dev->avg_rssi);
> ====>   WARN_ON_ONCE(avg_rssi == 0);

This WARNING by added by my commit
b305a6ab02475f52ef604b36e4cecd3bf4aa5eb7
I assumed that we will never run calibration code without receiving
some frames that will provide us RSSI. This turned out not to be true.
I will post the fix - just remove warning and return from the function
if avg_rssi == 0.

Thanks
Stanislaw 
