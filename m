Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36781 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbcGUHgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 03:36:43 -0400
Received: by mail-it0-f68.google.com with SMTP id j124so691640ith.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 00:36:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160721070938.GA2658@redhat.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com> <20160721070938.GA2658@redhat.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 21 Jul 2016 10:36:42 +0300
Message-ID: <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com> (sfid-20160721_093659_291841_10DEB5C6)
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 21, 2016 at 10:09 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Jul 19, 2016 at 03:00:37PM +0200, Michal Kazior wrote:
>> Firmware files are versioned to prevent older
>> driver instances to load unsupported firmware
>> blobs. This is reflected with a fallback logic
>> which attempts to load several firmware files.
>>
>> This however produced a lot of unnecessary
>> warnings sometimes confusing users and leading
>> them to rename firmware files making things even
>> more confusing.
>
> This happens on kernels configured with
> CONFIG_FW_LOADER_USER_HELPER_FALLBACK and cause not only ugly warnings,
> but also 60 seconds delay before loading next firmware version.
> For some reason RHEL kernel needs above config option, so this
> patch is very welcome from my perspective.
>

Sorry for my ignorance but how does the firmware loading work if not
with udev's help? As you can imagine, iwlwifi is suffering from the
same problem and I would be interested in applying the same change,
but I'd love to understand a bit more :)
