Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:39383 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbbBEJV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 04:21:29 -0500
Received: by mail-we0-f182.google.com with SMTP id l61so6442997wev.13
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2015 01:21:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <874mr2uklo.fsf@kamboji.qca.qualcomm.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
	<874mr2uklo.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 5 Feb 2015 10:21:28 +0100
Message-ID: <CA+BoTQmuHASUnvVphBLu0sg-U3c7-GmbVrZ5EsZXZ3_0+RqG0A@mail.gmail.com> (sfid-20150205_102138_423822_A86AC249)
Subject: Re: [PATCH 0/4] ath10k: implement fw stats for wmi-tlv
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2015 at 09:49, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> There are some slight differences in fw stats
>> (sic) in wmi-tlv.
>>
>> Firmware has changed the querying scheme and no
>> longer requires the ping-pong to get all stats.
>> The patchset doesn't change this behaviour so with
>> wmi-tlv it's possible to see the following
>> warnings when reading fw stats:
>>
>>  ath10k_pci 0000:00:06.0: received unsolicited stats update event
>>
>> The logic in ath10k still produces correct results
>> so this is harmless.
>>
>> I wonder how to deal with this in a sane way. An
>> `if (op_ver == WMI_TLV)` is a little bad but
>> having a new ar->fw_feature flag just for a debug
>> facility like this is a bit silly. Or we can just
>> drop the warning and leave a comment. Ideas?
>
> I think we could just remove the warning.
>
>> Michal Kazior (4):
>>   ath10k: add vdev stats processing
>>   ath10k: change request stats command prototype
>>   ath10k: add more wmi fw stat defines
>>   ath10k: implement fw stats for wmi-tlv
>
> There was a conflict in patch 2 but 3-way merge solved it automatically.
> Please check the result in the pending branch.

Looks good, thanks!


Michał
