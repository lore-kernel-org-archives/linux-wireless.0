Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45596 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0LASXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 13:23:30 -0500
Received: by qyk12 with SMTP id 12so9315320qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 10:23:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin3G2=T_qMSQdvXgUShtVSpg+MeH4EZX10QU9OQ@mail.gmail.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
 <1291169919-3867-2-git-send-email-javier@cozybit.com> <AANLkTin3G2=T_qMSQdvXgUShtVSpg+MeH4EZX10QU9OQ@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 1 Dec 2010 10:23:07 -0800
Message-ID: <AANLkTikNQitSrcj4Zn++BRAKp46hYTFb0tw61oD_bGVx@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: Fix beaconing in mesh mode
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob,

On Wed, Dec 1, 2010 at 5:16 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Nov 30, 2010 at 9:18 PM, Javier Cardona <javier@cozybit.com> wrote:
>> This patch fixes the oops below when attempting to bring up a mesh
>> interface on ath5k hardware.
>>
>> [  128.933099] kernel BUG at drivers/net/wireless/ath/ath5k/base.c:197!
>> [  128.933099] invalid opcode: 0000 [#1]
>> (...)
>> [  128.933099] Call Trace:
>> [  128.933099]  [<c83b77fa>] ? ath5k_beacon_update+0x57/0x1f8 [ath5k]
>> [  128.933099]  [<c02d9a40>] ? __sysfs_add_one+0x28/0x76
>> [  128.933099]  [<c83b830e>] ? ath5k_bss_info_changed+0x13f/0x173
>> [ath5k]
>> [  128.933099]  [<c82ff629>] ? ieee80211_config_beacon+0xc0/0x17e
>> [mac80211]
>> [  128.933099]  [<c82f073e>] ?
>> ieee80211_bss_info_change_notify+0x182/0x18b [mac80211]
>> [  128.933099]  [<c83b81cf>] ? ath5k_bss_info_changed+0x0/0x173 [ath5k]
>> [  128.933099]  [<c82ff6d6>] ? ieee80211_config_beacon+0x16d/0x17e
>> [mac80211]
>> [  128.933099]  [<c82ff753>] ? ieee80211_add_beacon+0x34/0x39 [mac80211]
>> [  128.933099]  [<c830a4ed>] ? ieee80211s_init+0xf8/0x10f [mac80211]
>> [  128.933099]  [<c830a5df>] ? ieee80211_mesh_init_sdata+0xdb/0x154 [mac80211]
>> ---
>>  drivers/net/wireless/ath/ath5k/base.c |    8 +++++---
>>  1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>> index a8d380a..73c7118 100644
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -1921,8 +1921,9 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>>                /* NB: hw still stops DMA, so proceed */
>>        }
>>
>> -       /* refresh the beacon for AP mode */
>> -       if (sc->opmode == NL80211_IFTYPE_AP)
>> +       /* refresh the beacon for AP or MESH mode */
>> +       if (sc->opmode == NL80211_IFTYPE_AP ||
>> +                       sc->opmode == NL80211_IFTYPE_MESH_POINT)
>>                ath5k_beacon_update(sc->hw, vif);
>
> Do you need to update the beacon this often or just once?
> Adhoc doesn't need to do this, for example, because it doesn't
> need the TIM; I don't know about mesh.

Currently power save mode is not implemented for mesh interfaces, so
the TIM is not really updated or used.  But yes, in principle mesh
beacons should include the TIM.  So it's better to use AP style
beaconing to pave the way for someone implementing proper traffic info
maps and power save for mesh.

Thanks for reviewing.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
