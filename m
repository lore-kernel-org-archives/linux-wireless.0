Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbeBOFve (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 00:51:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: James Cameron <quozl@laptop.org>
Cc: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel\@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received during channel setup
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
        <20180214213025.GB17837@us.netrek.org>
Date: Thu, 15 Feb 2018 07:51:28 +0200
In-Reply-To: <20180214213025.GB17837@us.netrek.org> (James Cameron's message
        of "Thu, 15 Feb 2018 08:30:26 +1100")
Message-ID: <87mv0a6brz.fsf@kamboji.qca.qualcomm.com> (sfid-20180215_065138_231141_29004B9D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Cameron <quozl@laptop.org> writes:

> On Wed, Feb 14, 2018 at 04:26:42PM +0000, Jean Pierre TOSONI wrote:
>> ath9k returns a wrong RSSI value for frames received in a 30ms time
>> window after a channel change. The correct value is typically 10dB
>> below the returned value.
>
> How was your correct value determined?
>
>> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083
>> cards), during offchannel scans.
>> 
>> Mark the signal value as invalid in this case.
>
> Why not adjust by 10dB?
>
> Speculating: in a typical card, RSSI is calculated by firmware from
> readings of ADCs attached to the receiver.  Firmware may average
> several readings.  Firmware may apply other offsets or calibrations,
> based on frequency and temperature.  This sounds like a firmware
> problem.

ath9k does not have firmware, only ath9k_htc has it.

-- 
Kalle Valo
