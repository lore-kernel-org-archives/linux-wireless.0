Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:50852 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032730AbeCAQAP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 11:00:15 -0500
Date: Thu, 1 Mar 2018 16:30:10 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180301153006.GJ1233@makrotopia.org> (sfid-20180301_170032_187737_18EDE637)
References: <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
 <20171221142558.GB4655@redhat.com>
 <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180124100316.GB3101@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[forwarding to all other involved players]

On Thu, Mar 01, 2018 at 05:50:51PM +0300, Jamie Stuart wrote:
> Hi Daniel,
> The driver seems much improved after this fix.

it's about those two
[PATCH 1/2] rt2x00: pause almost full queue early
[PATCH 2/2] rt2x00: do not pause queue unconditionally on error path

> Under very heavy load (30 clients downloading multi-GB files from SD card on the server concurrently), wifi dies with errors:
> 
> [ 7794.230376] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010c, type=4
> 
> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] Please file bug report to http://rt2x00.serialmonkey.com
> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] Please file bug report to http://rt2x00.serialmonkey.com
> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] Please file bug report to http://rt2x00.serialmonkey.com
> 
> 
> > On 20 Dec 2017, at 06:00, Daniel Golle <daniel@makrotopia.org> wrote:
> > 
> > Hi Jamie,
> > 
> > there was another round of discussion regarding the queue management
> > problem and Stanislaw Gruszka (the main rt2x00 maintainer) suggested
> > two patches which would be a more correct fix for the
> > rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue
> > message and consecutive problems.
> > 
> > I imported them to my staging tree. Please retest and join the
> > discussion on
> > https://wireless.wiki.kernel.org/en/developers/mailinglists#linux-wireless_online_archives
> > see posts
> > https://marc.info/?l=linux-wireless&m=151368325114059&w=2
> > https://marc.info/?l=linux-wireless&m=151368325914062&w=2
> > and
> > https://marc.info/?l=linux-wireless&m=151368992716169&w=2
> > 
> > 
> > Cheers
> > 
> > 
> > Daniel
> > 
> > 
