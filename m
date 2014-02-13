Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:37244 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBMPIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 10:08:21 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so8224356lan.39
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 07:08:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ppmr83p4.fsf@kamboji.qca.qualcomm.com>
References: <1392052405-15337-1-git-send-email-marek.puzyniak@tieto.com>
	<CA+BoTQ=q-940AsMfneU5SP8Ke1RxEZE12rrm4Z+KBaTBjrW64w@mail.gmail.com>
	<87ppmr83p4.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 13 Feb 2014 16:08:19 +0100
Message-ID: <CADnKcViJDsL6iTuKJ-QzHp-s1acE=89x6F1OXm1Ja8YAae09ng@mail.gmail.com> (sfid-20140213_160824_923745_8FCE8199)
Subject: Re: [PATCH] ath10k: change simulate_fw_crash to work with 10.1 firmware
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 February 2014 15:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 10 February 2014 18:13, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>>> Wmi command WMI_FORCE_FW_HANG_CMDID is not supported
>>> in firmware 10.1. In order to have firmware crash simulation
>>> functionality also in firmware 10.1 driver can force firmware
>>> crash by performing not allowed operation. Driver can deliberately
>>> crash firmware when setting vdev param for vdev id out of range.
>>>
>>> Command to trigger firmware crash:
>>> echo "crash" > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>>>
>>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>>> ---
>>
>> The 'fw hang assert' crash can be recovered with a warm reset but a
>> real crash can't.
>
> Oh, I didn't know that.
>
>> Thus, I think the two crash methods should be distinguishable
>
> Yeah, I agree.
>
>> by having either two separate debugfs files or two separate trigger
>> keywords.
>
> I think having a keyword would be a better to way differentiate these.
> And if the firmware doesn't support WMI_FORCE_FW_HANG_ASSERT, then just
> return -EOPNOTSUPP.

I will send new version with different keyword for different kind of
firmware crash.

Marek
