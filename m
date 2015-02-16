Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47080 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbbBPHI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 02:08:29 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so24033888wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2015 23:08:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vbj3gqa3.fsf@kamboji.qca.qualcomm.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
	<87vbj3gqa3.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 16 Feb 2015 08:08:28 +0100
Message-ID: <CA+BoTQmtxLzHfuZ3NgwnH=ijwG=fm+oA2oCLoeo20HAD=TG9vg@mail.gmail.com> (sfid-20150216_080833_176530_94DC213E)
Subject: Re: [PATCH 0/4] ath10k: implement fw stats for wmi-tlv
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 February 2015 at 16:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
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
> I think we could just drop the warning and leave a comment. That
> shouldn't break anything, right?

We end up performing a few extra wmi exchanges but this is harmless.
Having an extra condition to handle this cleanly with wmi-tlv/qca6174
seems a bit of an overkill.

The warning was just an explicit way of specifying what we expected of
the fw stats exchange logic. The assertion is no longer valid so it
can go away.


Michał
