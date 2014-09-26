Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54965 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIZLOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 07:14:36 -0400
Received: by mail-vc0-f177.google.com with SMTP id hq11so417464vcb.36
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 04:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871tqy63p9.fsf@kamboji.qca.qualcomm.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	<871tqy63p9.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 26 Sep 2014 13:14:35 +0200
Message-ID: <CA+BoTQmJ-HprccxTO3UrX+NkhOMVt2i2X7p4k0b5bs6TVrKrpw@mail.gmail.com> (sfid-20140926_131440_018209_7AE1717C)
Subject: Re: [PATCH 0/4] ath10k: fix/cleanup fw stats
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 September 2014 13:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>> Hi,
>>
>> This cleans up and fixes fw stats aggregation.
>>
>>
>> Michal Kazior (4):
>>   ath10k: split wmi stats parsing
>>   ath10k: rename fw_stats related stuff
>>   ath10k: request fw_stats once on open
>>   ath10k: fix fw stats processing
>
> I didn't review these yet but I saw new warnings:
>
> drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_fw_stats_fill':
> drivers/net/wireless/ath/ath10k/debug.c:540:5: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t' [-Wformat]

Oh, I didn't see this one. I guess it should be %zu.


> drivers/net/wireless/ath/ath10k/wmi.c:1513: WARNING: else is not generally useful after a break or return

I'm aware of this one but the code looks nicer with the `else` to me though.


Michał
