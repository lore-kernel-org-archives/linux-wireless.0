Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58378 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2A0KUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 05:20:01 -0500
Message-ID: <4F227A4D.80701@openwrt.org> (sfid-20120127_112007_558783_92BE06B8)
Date: Fri, 27 Jan 2012 11:19:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Milan Bouchet-Valat <nalimilan@club-internet.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232> <4F22646E.1010507@broadcom.com>
In-Reply-To: <4F22646E.1010507@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-27 9:46 AM, Arend van Spriel wrote:
> On 01/24/2012 11:31 AM, Milan Bouchet-Valat wrote:
>> [  297.365453] wlan0: Wrong control channel in association response: configured center-freq: 2437 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
> 
> Hi Felix,
> 
> My guess is that this message is coming from minstrel_ht. Could you
> explain what it means?
It's not minstrel_ht, it's this piece of code from net/mac80211/mlme.c:

    if (enable_ht) {
        hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
                               sband->band);
        /* check that channel matches the right operating channel */
        if (local->hw.conf.channel->center_freq != hti_cfreq) {
            /* Some APs mess this up, evidently.
             * Netgear WNDR3700 sometimes reports 4 higher than
             * the actual channel, for instance.
             */
            printk(KERN_DEBUG
                   "%s: Wrong control channel in association"
                   " response: configured center-freq: %d"
                   " hti-cfreq: %d  hti->control_chan: %d"
                   " band: %d.  Disabling HT.\n",
                   sdata->name,
                   local->hw.conf.channel->center_freq,
                   hti_cfreq, hti->control_chan,
                   sband->band);
            enable_ht = false;
        }
    }


- Felix
