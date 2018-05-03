Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:57937 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751701AbeECKUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 06:20:48 -0400
Message-ID: <1525342843.21176.635.camel@linux.intel.com> (sfid-20180503_122106_891331_71A1B20C)
Subject: Re: [PATCH v2 3/3] NFC: fdp: Fix possible buffer overflow in
 WCS4000 NFC driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Date: Thu, 03 May 2018 13:20:43 +0300
In-Reply-To: <1525283288-7027-4-git-send-email-amit.pundir@linaro.org>
References: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org>
         <1525283288-7027-4-git-send-email-amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-02 at 23:18 +0530, Amit Pundir wrote:
> From: Suren Baghdasaryan <surenb@google.com>
> 
> Possible buffer overflow when reading next_read_size bytes into
> tmp buffer after next_read_size was extracted from a previous packet.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> v2:
> Remove redundant __func__ from dev_dgb().
> 
>  drivers/nfc/fdp/i2c.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
> index c4da50e..b80d1ad 100644
> --- a/drivers/nfc/fdp/i2c.c
> +++ b/drivers/nfc/fdp/i2c.c
> @@ -176,6 +176,15 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy
> *phy, struct sk_buff **skb)
>  		/* Packet that contains a length */
>  		if (tmp[0] == 0 && tmp[1] == 0) {
>  			phy->next_read_size = (tmp[2] << 8) + tmp[3]
> + 3;
> +			/*
> +			 * Ensure next_read_size does not exceed
> sizeof(tmp)
> +			 * for reading that many bytes during next
> iteration
> +			 */
> +			if (phy->next_read_size >
> FDP_NCI_I2C_MAX_PAYLOAD) {
> +				dev_dbg(&client->dev, "corrupted
> packet\n");

> +				phy->next_read_size = 5;

Shouldn't be this magic replaced by

	phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;

? 

> +				goto flush;
> +			}
>  		} else {
>  			phy->next_read_size =
> FDP_NCI_I2C_MIN_PAYLOAD;
>  

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
