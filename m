Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:47729 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763302AbYBOWkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 17:40:37 -0500
Received: by fg-out-1718.google.com with SMTP id e21so614549fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 14:40:35 -0800 (PST)
Message-ID: <47B614DE.1050305@gmail.com> (sfid-20080215_224101_883578_71309E19)
Date: Fri, 15 Feb 2008 23:40:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1] WDEV: ath5k, test single chip before reset
References: <1203107827-27632-1-git-send-email-jirislaby@gmail.com> <40f31dec0802151353l2d03fdaam23d4f731a6c7bddc@mail.gmail.com>
In-Reply-To: <40f31dec0802151353l2d03fdaam23d4f731a6c7bddc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2008 10:53 PM, Nick Kossifidis wrote:
> 2008/2/15, Jiri Slaby <jirislaby@gmail.com>:
>> Move ath5k_hw_nic_wakeup after ah_single_chip being set, because we
>>  test the value in there and decides whether reset or not.
>>
>>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>>  ---
>>   drivers/net/wireless/ath5k/hw.c |   21 ++++++++++-----------
>>   1 files changed, 10 insertions(+), 11 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>>  index 3a4bf40..9cdd27f 100644
>>  --- a/drivers/net/wireless/ath5k/hw.c
>>  +++ b/drivers/net/wireless/ath5k/hw.c
[...]
>>  @@ -210,12 +205,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>>         }
>>
>>         /* Identify single chip solutions */
>>  -       if((srev <= AR5K_SREV_VER_AR5414) &&
>>  -       (srev >= AR5K_SREV_VER_AR2424)) {
>>  -               ah->ah_single_chip = true;
>>  -       } else {
>>  -               ah->ah_single_chip = false;
>>  -       }
>>  +       ah->ah_single_chip = srev >= AR5K_SREV_VER_AR2424 &&
>>  +                       srev <= AR5K_SREV_VER_AR5414;
>>  +
>>  +       /* Bring device out of sleep and reset it's units */
>>  +       ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
>>  +       if (ret)
>>  +               goto err_free;
>>
>>         /* Single chip radio */
>>         if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
>>
> 
> NACK, single chip flag is going out since only needed check is for
> 5424/2424 during nic_wakeup, 5413/2413 behave like the rest
> 5211/5212-combatible cards.

Ok, thanks.

> Sorry for delaying the relevant patches, i'm working with the 2413
> card i got from Mike to make it work and it'll take some time (not as
> easy as i thought, i probably miss something)...

No problem, if I could do anything for you in this area, don't hesitate to drop 
a message.
