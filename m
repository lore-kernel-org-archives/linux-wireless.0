Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34850 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbDQHaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 03:30:52 -0400
Received: by widdi4 with SMTP id di4so11476730wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 00:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87618v44jv.fsf@kamboji.qca.qualcomm.com>
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	<87618v44jv.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 17 Apr 2015 09:30:51 +0200
Message-ID: <CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com> (sfid-20150417_093056_243142_8FAE7084)
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2015 at 09:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Until now only a single fixed tx rate or nss was
>> allowed to be set.
>>
>> The patch attempts to improve this by allowing
>> most bitrate masks. The limitation is VHT MCS
>> rates cannot be expressed separately using
>> existing firmware interfaces and only the
>> following VHT MCS ranges are supported: none, 0-7,
>> 0-8, and 0-9.
>>
>> This keeps the old behaviour when requesting
>> single tx rate or single nss. The new bitrate mask
>> logic is only applied to other cases that would
>> return -EINVAL until now.
>>
>> Depending on firmware revisions some combinations
>> may crash firmware so use with care, please.
>>
>> This depends on "ath10k: don't use reassoc flag".
>> Without it key cache would effectively be
>> invalidated upon bitrate change leading to
>> communication being no longer possible.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> To reduce support questions from the users it would be nice to give few
> good examples how to use this with iw. And also it makes it easier to
> test the patch. If you could send something I can add it to the commit
> log.

Should work:

  iw wlan0 set bitrates legacy 1 6 12 ht-mcs 1 2 3
  iw wlan0 set bitrates legacy-5 mcs-5 7 8 9
  iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9

Won't work:

  iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
  iw wlan0 set bitrates vht-mcs-5 2:7-9

(note the invalid VHT MCS ranges)

Generally the patch removes a lot of limitations from 'set bitrates'
ath10k had. Before it was possible to do only things as described in
51ab1a0a09a8 ("ath10k: add set_bitrate_mask callback").


[...]
>> +             default:
>> +                     /* see ath10k_mac_can_set_bitrate_mask() */
>> +                     WARN_ON(1);
>> +                     /* fall through */
>> +             case -1:
>> +                     mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED; break;
>> +             case 7:
>> +                     mcs = IEEE80211_VHT_MCS_SUPPORT_0_7; break;
>> +             case 8:
>> +                     mcs = IEEE80211_VHT_MCS_SUPPORT_0_8; break;
>> +             case 9:
>> +                     mcs = IEEE80211_VHT_MCS_SUPPORT_0_9; break;
>> +             }
>
> I moved the breaks into their own lines, I think that just easier to
> read. This is the diff:
[snip]

I'm okay with this.


Michał
