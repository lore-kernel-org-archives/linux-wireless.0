Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4718 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab3CESW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:22:26 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ath6kl: print firmware capabilities
References: <20130305163842.32118.84598.stgit@localhost6.localdomain6>
	<1362506794.1759.2.camel@joe-AO722>
Date: Tue, 5 Mar 2013 20:19:38 +0200
In-Reply-To: <1362506794.1759.2.camel@joe-AO722> (Joe Perches's message of
	"Tue, 5 Mar 2013 10:06:34 -0800")
Message-ID: <871ubtemkl.fsf@kamboji.qca.qualcomm.com> (sfid-20130305_192230_431593_4B161ED9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Tue, 2013-03-05 at 18:38 +0200, Kalle Valo wrote:
>> Printin the  firmware capabilities during the first firmware boot makes it easier to find out what
>> features firmware supports.
> []
>> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> []
>> +static void ath6kl_init_fw_capas(struct ath6kl *ar, char *buf, size_t buf_len)
>> +{
> []
>> +		if (buf_len - len < 4) {
>> +			ath6kl_warn("firmware capability buffer too small!\n");
>> +			strncpy(buf, "<error>", buf_len);
>
> 4 is an odd size to use.

I have to admit that I was lazy here. I think "< 2" (or "== 1") would be
the correct value to use but I didn't check that and just used 4 to be
on the safe side :)

> It seems weird to overwrite the known bits.

I did that just to make sure that the truncation won't be missed.

> why not just add ...?

You mean to the end of buffer? Like "first,second,th..."? Looks good,
I'll do that.

-- 
Kalle Valo
