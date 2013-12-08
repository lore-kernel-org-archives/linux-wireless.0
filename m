Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:50647 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3LHSJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 13:09:40 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so2589845wes.10
        for <linux-wireless@vger.kernel.org>; Sun, 08 Dec 2013 10:09:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A46B10.6030104@candelatech.com>
References: <5294E4C5.4050301@cs.kuleuven.be> <52950812.20001@rempel-privat.de>
 <5295EF41.8040709@cs.kuleuven.be> <CANiGF999jHN3+5QuNVAkVk_hHxZ6LkPxWB3jW9yoJGbfno7M9A@mail.gmail.com>
 <52972749.70200@gmail.com> <20131206162919.GE13285@tuxdriver.com>
 <CAFXAJYzO5ifSYbiN7xqV5Sr+3CFrZsaqc2dg0bt-JB0EUxFRdQ@mail.gmail.com>
 <52A35189.7010804@rempel-privat.de> <52A46B10.6030104@candelatech.com>
From: Mathy <vanhoefm@gmail.com>
Date: Sun, 8 Dec 2013 19:09:18 +0100
Message-ID: <CAFXAJYyOrd_ybL=roYqdjF_eK81kP1sEBHbjSsXL8y0P_oR38w@mail.gmail.com> (sfid-20131208_191000_847783_907BB39F)
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
To: Ben Greear <greearb@candelatech.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pau Koning <paukoning@gmail.com>,
	linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vthiagar@qti.qualcomm.com, senthilb@qti.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The common->macaddr field is also updated in the ath9k driver
(function ath9k_calculate_iter_data in main.c).

I just did a quick test. When using macchanger to assign a random MAC
address, the original (permanent) MAC address is still retrieved
properly. So there is no need to reload the module, macchanger can
simply restore the permanent MAC. I assume the permanent MAC address
is saved elsewhere?

On Sun, Dec 8, 2013 at 1:50 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 12/07/2013 08:49 AM, Oleksij Rempel wrote:
>>
>> I have only one doubt in this patch.
>> It will overwrite original MAC. If you wont to restore it, then you need
>> to reload module.
>>
>> If no body against it, i can live it too.
>
>
> I believe ethtool allows an API to read the eeprom-MAC addr.  Maybe
> add support for that API to the ath9k_htc driver so that the original
> MAC can be read that way?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
