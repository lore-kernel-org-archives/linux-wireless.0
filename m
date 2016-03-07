Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37573 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcCGGER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 01:04:17 -0500
Received: by mail-wm0-f52.google.com with SMTP id p65so57398028wmp.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 22:04:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ziubvfzm.fsf@kamboji.qca.qualcomm.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-8-git-send-email-michal.kazior@tieto.com>
	<87ziubvfzm.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 7 Mar 2016 07:04:16 +0100
Message-ID: <CA+BoTQm=vskz3WhSZjQcMLscWEs4NVoM37hpoYHMiaQb0fYyAw@mail.gmail.com> (sfid-20160307_070421_255783_FDF8AD10)
Subject: Re: [PATCH v2 07/11] ath10k: implement wake_tx_queue
From: Michal Kazior <michal.kazior@tieto.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2016 at 15:27, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This implements very basic support for software
>> queueing. It also contains some knobs that will be
>> patched later.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Oddly this patch introduces a new warning:
>
> drivers/net/wireless/ath/ath10k/mac.c: In function ath10k_mac_op_tx:
> drivers/net/wireless/ath/ath10k/mac.c:3949:29: warning: is_mgmt may be used uninitialized in this function [-Wuninitialized]
>
> But I think that's just a false warning, most likely because my gcc is
> ancient. Do you agree?

Yes, I agree. It must be the fact is_mgmt is set/used across two
is_htt condition branches.


> gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3

gcc (Debian 4.9.2-10) 4.9.2 -- no warning for me.


Michał
