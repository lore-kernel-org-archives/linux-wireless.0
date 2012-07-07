Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40047 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2GGLqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 07:46:30 -0400
Received: by obbuo13 with SMTP id uo13so16704416obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 04:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE93A7E.9050908@qca.qualcomm.com>
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
	<1340633579-7514-2-git-send-email-mohammed@qca.qualcomm.com>
	<20456.40340.61005.543469@gargle.gargle.HOWL>
	<4FE93A7E.9050908@qca.qualcomm.com>
Date: Sat, 7 Jul 2012 17:16:28 +0530
Message-ID: <CAD2nsn3HcGUovViDoPf==Vixvdz-yTMqCBSJNUYfzj9Pv=3-Tg@mail.gmail.com> (sfid-20120707_134709_506593_B785C9E7)
Subject: Re: [PATCH v3 01/10] ath9k_hw: Add register definitions for WoW support
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	vadivel@qca.qualcomm.com, rhu@qca.qualcomm.com,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 9:58 AM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> Hi Sujith,
>
>
> On Monday 25 June 2012 10:49 PM, Sujith Manoharan wrote:
>>
>> Mohammed Shafi Shajakhan wrote:
>>>
>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>
>>> *MAC WoW registers
>>>
>>> back-off shift, MAC interrupt enable, magic packet enable,
>>> pattern match enable, aifs, slot wait period, keep alive
>>> frame failure count, beacon fail enable, beacon timeout,
>>> keep alive timeout, auto keep alive disable,
>>> keep alive fail disable and their corresponding
>>> status registers. keep alive frame delay,
>>> pattern end/byte offsets, transmit buffers for
>>> keep alive frames and storing the user patterns
>>>
>>> *Power Management Control registers
>>>
>>> pme_d3cold_vaux, host_pme_enable, aux_pwr_detect,
>>> power_state_mask, wow_pme_clear
>>
>>
>> The commit log could be trimmed to just say "various WoW registers".
>>
>>> +/* AR_WOW_PATTERN register values */
>>> +#define AR_WOW_BACK_OFF_SHIFT(x)       ((x&  0xf)<<  28) /* in usecs */
>>>
>>> +#define AR_WOW_MAC_INTR_EN             0x00040000
>>> +#define AR_WOW_MAGIC_EN                        0x00010000
>>> +#define AR_WOW_PATTERN_EN(x)           (x&  0xff)
>>> +#define AR_WOW_PAT_FOUND_SHIFT 8
>>> +#define AR_WOW_PATTERN_FOUND(x)                (x&  (0xff<<
>>> AR_WOW_PAT_FOUND_SHIFT))
>>>
>>> +#define AR_WOW_PATTERN_FOUND_MASK      ((0xff)<<
>>> AR_WOW_PAT_FOUND_SHIFT)
>>> +#define AR_WOW_MAGIC_PAT_FOUND         0x00020000
>>> +#define AR_WOW_MAC_INTR                        0x00080000
>>> +#define AR_WOW_KEEP_ALIVE_FAIL         0x00100000
>>> +#define AR_WOW_BEACON_FAIL             0x00200000
>>> +
>>> +#define AR_WOW_STATUS(x)               (x&  (AR_WOW_PATTERN_FOUND_MASK |
>>> \
>>>
>>> +                                             AR_WOW_MAGIC_PAT_FOUND    |
>>> \
>>> +                                             AR_WOW_KEEP_ALIVE_FAIL    |
>>> \
>>> +                                             AR_WOW_BEACON_FAIL))
>>> +#define AR_WOW_CLEAR_EVENTS(x)         (x&  ~(AR_WOW_PATTERN_EN(0xff) |
>>> \
>>>
>>> +                                              AR_WOW_MAGIC_EN | \
>>> +                                              AR_WOW_MAC_INTR_EN | \
>>> +                                              AR_WOW_BEACON_FAIL | \
>>> +                                              AR_WOW_KEEP_ALIVE_FAIL))
>>> +
>>
>>
>> Indentation is off in many places, please fix it.
>>
>

Lindent seems to complain about few of the comments after macros,
fixing them causes above 80 line stuff
will check this out if there is anything else missing

>
> --
> thanks,
> shafi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
