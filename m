Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0EWSRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 14:17:33 -0400
Received: by fxm5 with SMTP id 5so1927640fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 May 2010 11:17:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTim1i3oB10rydr8ezyCjher1yctqKcVt9Ct1Bze0@mail.gmail.com>
	<AANLkTinYZ-_DkNZweDFfdf_DdDJGMNhgQwppDnVo_Duj@mail.gmail.com>
	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>
	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>
	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>
	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 23 May 2010 20:17:12 +0200
Message-ID: <AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: Weedy <weedy2887@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/23 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2010/5/23 Weedy <weedy2887@gmail.com>:
>> 2010/5/17 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> What about cutting down the kernel to the absolute minimum required by
>>> your machine?
>>>
>>> Also, Kbuild supports incremental builds as long as you do not "make
>>> clean" before builds.
>>>
>> I just finished the cycle (told you it would take forever on this
>> crapbook) and this  is what I got. To be sure I have done multiple
>> boots with vmlinuz-2.6.31-rc5fffffffff-01634-geadac6b and
>> vmlinuz-2.6.31-rc5fffffffff-01635-g56d1de0 and confirmed it broken.
>> Patching todays compat-wireless tar with the output of "git diff
>> 56d1de0a21db28e41741cfa0a66e18bc8d920554
>> 56d1de0a21db28e41741cfa0a66e18bc8d920554^ >fffffffff.diff " restores
>> expected functionality (Does this mean I get my name in the kernel
>> log? :D ).
>>
>> $ git bisect bad
>> 56d1de0a21db28e41741cfa0a66e18bc8d920554 is the first bad commit
>> commit 56d1de0a21db28e41741cfa0a66e18bc8d920554
>> Author: Bob Copeland <me@bobcopeland.com>
>> Date:   Mon Aug 24 23:00:30 2009 -0400
>>
>>    ath5k: clean up filter flags setting
>>
>>    The maze of if() statements in configure_filter is confusing.
>>    Reorganizing it as a switch statement makes it more apparent what
>>    is going on and reveals several suspicious settings.  This has no
>>    functional changes, though it does remove some redundant flags
>>    that are set earlier.
>>
>>    Also now that we can sleep, protect sc->filter_flags with the
>>    sc lock.
>>
>>    Signed-off-by: Bob Copeland <me@bobcopeland.com>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> :040000 040000 1ca00241b99b379f192c1ade63c082955c7dda69
>> 1a19187e11210e3c66c224dba62a1896c46d0114 M      drivers
>>
>
> Certainly a possible cause. Chances are some of the "redundant" flags
> weren't so redundant at all...
>
> However, the original code was wrong too - I highly doubt we can rely
> on sc->opmode to set monitor mode filter flags. I will look into this
> when I get to my Linux box again.
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>

In the meantime, one thing to test: Add a printk of sc->opmode. If I
am right, this will never be set to NL80211_IFTYPE_MONITOR... That
would mean the promisc flag would never be set. Prior to the patch,
this was taken care by the following code:
       if (sc->opmode != NL80211_IFTYPE_AP &&
               sc->opmode != NL80211_IFTYPE_MESH_POINT &&
               test_bit(ATH_STAT_PROMISC, sc->status))
               rfilt |= AR5K_RX_FILTER_PROM;


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
