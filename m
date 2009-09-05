Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33632 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751152AbZIEUco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 16:32:44 -0400
Message-ID: <4AA2CAEC.3000908@gmx.de>
Date: Sat, 05 Sep 2009 22:32:44 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath,ar9170: move CTL_ defines into regd.h
References: <4AA270AF.2010902@gmx.de> <43e72e890909051233s3df12787oa1c59a8b9728c271@mail.gmail.com>
In-Reply-To: <43e72e890909051233s3df12787oa1c59a8b9728c271@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2009 09:33 PM, Luis R. Rodriguez wrote:
> On Sat, Sep 5, 2009 at 7:07 AM, Joerg Albert<jal2@gmx.de> wrote:
>> The ar9170 driver needs the defines for conformance test limit groups
>> and cannot include regd_common.h
>>
>> Signed-off-by: Joerg Albert <jal2@gmx.de>
> 
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Just please test compilation of ath5k and ath9k as well.

They compile fine.

Sometime we should IMHO unify the CTL_* defines in the driver below ath/.
Currently ath5k, ath9k and regd.h have separate definitions for the modes, e.g.

~/src/wireless.gits/wireless-testing/drivers/net/wireless/ath$ fgrep -r --include=*.h CTL_11A *
ath5k/eeprom.h: AR5K_CTL_11A = 0,
ath9k/eeprom.h:#define CTL_11A                 0
ath9k/eeprom.h:#define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
regd.h:#define CTL_11A                 0

Regards,
Joerg.
