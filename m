Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbcCQOoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 10:44:20 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Jandy Gou <qingsong.gou@ck-telecom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: r8723au: This patch tries to fix some byte order issues that is found by sparse check.
References: <1458201839-7007-1-git-send-email-qingsong.gou@ck-telecom.com>
	<CAGRGNgXEfvSuxLZ3Qrb3hj7DK89qBKX3Bh2+0Ov9FZX+4_PqOw@mail.gmail.com>
Date: Thu, 17 Mar 2016 10:44:19 -0400
In-Reply-To: <CAGRGNgXEfvSuxLZ3Qrb3hj7DK89qBKX3Bh2+0Ov9FZX+4_PqOw@mail.gmail.com>
	(Julian Calaby's message of "Thu, 17 Mar 2016 20:18:59 +1100")
Message-ID: <wrfjmvpxp3jw.fsf@redhat.com> (sfid-20160317_154445_644550_82ABDBA5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jandy,
>
> On Thu, Mar 17, 2016 at 7:03 PM, Jandy Gou <qingsong.gou@ck-telecom.com> wrote:
>> make C=1 M=drivers/staging/rtl8723au/
>>
>> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:96:38: warning: cast to
>> restricted __le16
>> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:100:27: warning: cast to
>> restricted __le32
>>
>> Signed-off-by: Jandy Gou <qingsong.gou@ck-telecom.com>
>
> I'm not sure your change is correct. Perhaps you should add temporary
> variables for h2c_cmd_ex and h2c_cmd while they're cpu-endian?
>
> Jes,
>
> I'm pretty sure this isn't the first time this has come up. Do you
> have any ideas for a solution? Or should we ignore this as this driver
> will eventually be going away?

Temp variables as you suggest would be a clean way to accomplish this.

Technically this might work, but esthetically this is so gross I wish I
had never seen it. There is a reason why we have the byteorder specific
types, and le{16,32}_to_cpus() violates that.

I am surprised we still have these macros around, tbh I didn't even know
they existed. A quick search for le16_to_cpus() shows that it's really
very old drivers and some more recent Intel Ethernet drivers that use
them - maybe this would be a good time to get rid of them completely.

Cheers,
Jes
