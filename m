Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751594AbeAWNUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 08:20:18 -0500
Date: Tue, 23 Jan 2018 14:20:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180123132016.GB2520@redhat.com> (sfid-20180123_142130_292453_473FFBFB)
References: <20171218152142.GA15414@redhat.com>
 <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
 <20171219125431.GB2672@redhat.com>
 <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
 <20171221142558.GB4655@redhat.com>
 <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 11, 2018 at 05:00:14PM +0100, Tom Psyborg wrote:
> does not help as expected. there was even a crash:

You mean the kernel hangs ? There is a WARNING at the end of the logs
but it's from ath9k not from rt2800. 

> [   92.559018] ieee80211 phy1: rt2800mmio_txstatus_is_spurious: Warning - 4
> spurious TX_FIFO_STATUS interrupt(s)

This is suspicious, we should not get spurious interrupts. Perhaps there
is something wrong on platform lever, maybe with pinmux ? 

> for an empty queue 2, dropping
> [  176.019555] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning -
> Frame received with unrecognized signal, mode=0x0001, signal=0x010f, type=4
> [  176.025456] ieee80211 phy1: rt2x00lib_rxdone_read_signal: Warning -

and this indicate that HW/FW do not provide correct frames to 
the driver any longer.

Again - I think we do something that make device no longer possible to
function normally. Changing queue stop/start thresholds will not help
with that.

Cheers
Stanislaw 
