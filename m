Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64359 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHHDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 03:03:16 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so6433187wiv.12
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 00:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ob0cmhwp.fsf@kamboji.qca.qualcomm.com>
References: <1396610305-5229-1-git-send-email-michal.kazior@tieto.com>
	<87y4zgmifa.fsf@kamboji.qca.qualcomm.com>
	<87ob0cmhwp.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Apr 2014 09:03:15 +0200
Message-ID: <CA+BoTQkWjr9pxTN0AgqDXLzXqTjJ1a=Zepss5UdDw7tpOQLOAw@mail.gmail.com> (sfid-20140408_090321_446004_B9151EA9)
Subject: Re: [PATCH] ath10k: refactor monitor code
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 08:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> It was possible to create/delete/start/stop
>>> monitor vdev from a few places that were not
>>> exclusively protected against each other. This
>>> resulted in monitor vdev being stopped/removed by
>>> one call origin while another one was expecting it
>>> to continue running.
>>>
>>> For example if CAC was started and interface's
>>> promiscuous mode was toggled monitor vdev was
>>> removed from the driver meaning no radar would be
>>> detected. In additional a warning would be printed
>>> upon CAC completion complaining it tried to stop
>>> non-running monitor vdev.
>>>
>>> The patch simplifies monitor code by removing
>>> IEEE80211_HW_WANT_MONITOR_VIF (which wasn't really
>>> ever needed) and improves state tracking. It also
>>> unifies prints.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Thanks, applied.
>
> Actually there were two checkpatch warnings which I had missed:
>
> drivers/net/wireless/ath/ath10k/mac.c:2587: WARNING: line over 80 characters
> drivers/net/wireless/ath/ath10k/mac.c:2852: WARNING: line over 80 characters
>
> I amended it like this:
>

[...]

Sorry for the trouble and thanks!


Michał
