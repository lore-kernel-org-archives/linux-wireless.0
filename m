Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:55267 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754800AbeBOHVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 02:21:33 -0500
Date: Thu, 15 Feb 2018 18:21:18 +1100
From: James Cameron <quozl@laptop.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
Message-ID: <20180215072118.GG17837@us.netrek.org> (sfid-20180215_082136_871250_1789D99A)
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <20180214213025.GB17837@us.netrek.org>
 <87mv0a6brz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mv0a6brz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2018 at 07:51:28AM +0200, Kalle Valo wrote:
> James Cameron <quozl@laptop.org> writes:
> 
> > On Wed, Feb 14, 2018 at 04:26:42PM +0000, Jean Pierre TOSONI wrote:
> >> ath9k returns a wrong RSSI value for frames received in a 30ms time
> >> window after a channel change. The correct value is typically 10dB
> >> below the returned value.
> >
> > How was your correct value determined?
> >
> >> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083
> >> cards), during offchannel scans.
> >> 
> >> Mark the signal value as invalid in this case.
> >
> > Why not adjust by 10dB?
> >
> > Speculating: in a typical card, RSSI is calculated by firmware from
> > readings of ADCs attached to the receiver.  Firmware may average
> > several readings.  Firmware may apply other offsets or calibrations,
> > based on frequency and temperature.  This sounds like a firmware
> > problem.
> 
> ath9k does not have firmware, only ath9k_htc has it.

Heh.  s/firmware/silicon implementation/g

-- 
James Cameron
http://quozl.netrek.org/
