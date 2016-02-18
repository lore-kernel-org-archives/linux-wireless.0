Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946703AbcBRTJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 14:09:36 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] staging: rtl8723au: use list_for_each_entry*() and cleaning
References: <cover.1455804404.git.geliangtang@163.com>
Date: Thu, 18 Feb 2016 14:09:34 -0500
In-Reply-To: <cover.1455804404.git.geliangtang@163.com> (Geliang Tang's
	message of "Thu, 18 Feb 2016 22:19:28 +0800")
Message-ID: <wrfjbn7dzvgx.fsf@redhat.com> (sfid-20160218_201036_791840_F111829F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@163.com> writes:
> On Wed, Feb 17, 2016 at 12:28:33PM -0500, Jes Sorensen wrote:
>> kbuild test robot <lkp@intel.com> writes:
>> > All errors (new ones prefixed by >>):
>> >
>> >    drivers/staging/rtl8723au/core/rtw_recv.c: In function 'rtw_free_recvframe23a_queue':
>> >>> drivers/staging/rtl8723au/core/rtw_recv.c:203:2: error: 'plist' undeclared (first use in this function)
>> >      plist = phead->next;
>> >      ^
>> 
>> This doesn't work, you cannot break interim builds. Your patch 2 needs
>> to go before patch 1, and you must always check that they compile for
>> each patch you apply.
>> 
>> NACK
>
> Sorry for the trouble caused. I updated my patchs to fix this problem.
>
> - Geliang
>
> This patch set uses list_for_each_entry*() instead of
> list_for_each*(), removes useless codes, and cleans
> whitespaces and blank lines.

No worries, I much prefer taking a few rounds to get it right.

This set looks good to me.

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
