Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60874 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbcHBLwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:52:46 -0400
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <87ziov772h.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <a549f589-8678-d721-9c35-5695fa87359c@nbd.name> (sfid-20160802_135731_193229_4332AA00)
Date: Tue, 2 Aug 2016 13:24:36 +0200
MIME-Version: 1.0
In-Reply-To: <87ziov772h.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-02 13:18, Valo, Kalle wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
> 
>> Firmware files are versioned to prevent older
>> driver instances to load unsupported firmware
>> blobs. This is reflected with a fallback logic
>> which attempts to load several firmware files.
>>
>> This however produced a lot of unnecessary
>> warnings sometimes confusing users and leading
>> them to rename firmware files making things even
>> more confusing.
>>
>> Hence use request_firmware_direct() which does not
>> produce extra warnings. This shouldn't really
>> break anything because most modern systems don't
>> rely on udev/hotplug helpers to load firmware
>> files anymore.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> 
> Nice. These "firmware not found" messages have been confusing ath10k
> users for ages and should be properly fixed. I hope we find a solution.
> 
> But I talked with Felix about this and he made a good point about board
> and calibration files. Calibration files might be created runtime, for
> example retrieved from NAND etc, and this might break the use case when
> ath10k is statically linked to kernel. Is the combination used in real
> life and should we care, that I do not know, but I'm worried of possible
> regressions. I guess LEDE/openwrt always loads ath10k as a module and
> after the calibration file is created?
ath10k is always loaded as a module, and the calibration file is created
by a script that's triggered by the firmware uevent.

- Felix
