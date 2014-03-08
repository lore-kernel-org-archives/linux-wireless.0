Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:37057 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbaCHXBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2014 18:01:20 -0500
Message-ID: <531BA13F.2060205@ispras.ru> (sfid-20140309_000140_417567_EF949C5E)
Date: Sun, 09 Mar 2014 03:01:19 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: Re: [PATCH] p54usb: fix leaks at failure path in p54u_probe()
References: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru> <CABPxzYLzMvtWShP_PFdyTzV8P1P177yPZh=xAO=3tiy97UfEmQ@mail.gmail.com>
In-Reply-To: <CABPxzYLzMvtWShP_PFdyTzV8P1P177yPZh=xAO=3tiy97UfEmQ@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09.03.2014 02:44, Krishna Chaitanya wrote:
> On Sat, Mar 8, 2014 at 2:41 AM, Alexey Khoroshilov
> <khoroshilov@ispras.ru> wrote:
>> If p54u_load_firmware() fails, p54u_probe() does not deallocate
>> already allocated resources. The patch adds proper failure handling.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>>  drivers/net/wireless/p54/p54usb.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
>> index 6e635cfa24c8..5df74503fd4f 100644
>> --- a/drivers/net/wireless/p54/p54usb.c
>> +++ b/drivers/net/wireless/p54/p54usb.c
>> @@ -1053,6 +1053,10 @@ static int p54u_probe(struct usb_interface *intf,
>>                 priv->upload_fw = p54u_upload_firmware_net2280;
>>         }
>>         err = p54u_load_firmware(dev, intf);
>> +       if (err) {
>> +               usb_put_dev(udev);
>> +               p54_free_common(dev);
>> +       }
>>         return err;
>>  }
> The load_firmware puts down the reference
> in case of error. Only free is required here.
No, p54u_load_firmware() puts down reference that was got up by itself.
So we still have to put down reference got up in p54u_probe().

--
Alexey


