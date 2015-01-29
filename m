Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:43756 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbA2M7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 07:59:41 -0500
Received: by mail-we0-f180.google.com with SMTP id m14so23342291wev.11
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 04:59:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87r3ud21tq.fsf@kamboji.qca.qualcomm.com>
References: <1422534273-18427-1-git-send-email-michal.kazior@tieto.com>
	<87r3ud21tq.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 29 Jan 2015 13:59:39 +0100
Message-ID: <CA+BoTQk=rY6gsc6vUXnJ+me=o5ZHOLVLqxVRcDddQXY2utvL0g@mail.gmail.com> (sfid-20150129_135945_832049_9647D7F8)
Subject: Re: [PATCH] ath10k: enable qca6174 hw3.2
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 January 2015 at 13:44, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The 3.2 revision has a different target BMI
>> version so it wasn't recognized by ath10k (despite
>> the chip_id rev being on the supported list
>> already).
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> But uses the same binaries as hw3.0?

Correct.


[...]
> I added this in pending branch to avoid people wondering why it uses 3.0
> binaries:
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 36a8fcf349fa..310e12bc078a 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -91,6 +91,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>                 .patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
>                 .uart_pin = 6,
>                 .fw = {
> +                       /* uses same binaries as hw3.0 */

Good point. Thanks!


Michał
