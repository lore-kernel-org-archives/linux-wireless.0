Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45214 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab2HLHbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 03:31:41 -0400
Received: by obbta17 with SMTP id ta17so5903573obb.8
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 00:31:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120810162810.GB17559@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-3-git-send-email-victorg@ti.com>
	<20120810162810.GB17559@redhat.com>
Date: Sun, 12 Aug 2012 10:31:40 +0300
Message-ID: <CAK80WHa1ae7jA6BxOA+1Xx0bTx2_0+0GuDa=UrJ+qsC9_sYZ7g@mail.gmail.com> (sfid-20120812_093207_617534_A24A0510)
Subject: Re: [PATCH v3 2/7] mac80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 7:28 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Aug 08, 2012 at 02:53:38PM +0300, Victor Goldenshtein wrote:
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -2262,6 +2262,10 @@ enum ieee80211_rate_control_changed {
>>   *   The callback will be called before each transmission and upon return
>>   *   mac80211 will transmit the frame right away.
>>   *   The callback is optional and can (should!) sleep.
>> + *
>> +* @start_radar_detection: Start radar detection on current operational
>> + *   channel, once started it will continuously monitor for radars as long
>> + *   as the channel active.
>>   */
>>  struct ieee80211_ops {
>>       void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
>> @@ -2404,6 +2408,10 @@ struct ieee80211_ops {
>>
>>       void    (*mgd_prepare_tx)(struct ieee80211_hw *hw,
>>                                 struct ieee80211_vif *vif);
>> +
>> +     int (*start_radar_detection)(struct ieee80211_hw *hw,
>> +                                  struct ieee80211_vif *vif,
>> +                                  struct ieee80211_channel *chan);
>
> Why we need new callback? I.e. why this can be done by ->config ?
>

See proposed RFC and previous threads.

-- 
Thanks,
Victor.
