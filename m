Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48246 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaHSHqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 03:46:08 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so4829977wiv.7
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 00:46:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y4uuqhip.fsf@kamboji.qca.qualcomm.com>
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	<87y4uuqhip.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 19 Aug 2014 09:46:07 +0200
Message-ID: <CA+BoTQmTvcLDWeKnRXKnAVh27DGrvk+xgr_9DFmuZ3gA6yedYw@mail.gmail.com> (sfid-20140819_094612_863749_DE4F142F)
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2014 09:44, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The 10.x and main firmware branches have
>> conflicting WMI service bitmap definitions.
>>
>> This also fixes WMI services parsing on big-endian
>> hosts and changes debugfs output to be more human
>> friendly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Thanks, applied.

Your tree has wmi_10x_svc_map() and wmi_main_svc_map() swapped[1][2].
This results in invalid wmi service mappings. Did you have a conflict
on this patch?

[1] https://github.com/kvalo/ath/commit/cff990ce7ddd6a43f86757867399a8a64aa29af9#diff-d74831f35d359092fadf570b3d4efa90R2117
[2] https://github.com/kvalo/ath/commit/cff990ce7ddd6a43f86757867399a8a64aa29af9#diff-d74831f35d359092fadf570b3d4efa90R2187


Michał
