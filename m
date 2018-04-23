Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbeDWJQi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 05:16:38 -0400
Date: Mon, 23 Apr 2018 11:16:31 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RESEND][PATCH 4/4] NFC: fdp: Fix possible buffer overflow in
 WCS4000 NFC driver
Message-ID: <20180423091631.GA14322@kroah.com> (sfid-20180423_111642_088553_A952079E)
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
 <1524045904-7005-5-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524045904-7005-5-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2018 at 03:35:04PM +0530, Amit Pundir wrote:
> From: Suren Baghdasaryan <surenb@google.com>
> 
> Possible buffer overflow when reading next_read_size bytes into
> tmp buffer after next_read_size was extracted from a previous packet.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
>  drivers/nfc/fdp/i2c.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
> index c4da50e07bbc..08a4f82a2965 100644
> --- a/drivers/nfc/fdp/i2c.c
> +++ b/drivers/nfc/fdp/i2c.c
> @@ -176,6 +176,16 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
>  		/* Packet that contains a length */
>  		if (tmp[0] == 0 && tmp[1] == 0) {
>  			phy->next_read_size = (tmp[2] << 8) + tmp[3] + 3;
> +			/*
> +			 * Ensure next_read_size does not exceed sizeof(tmp)
> +			 * for reading that many bytes during next iteration
> +			 */
> +			if (phy->next_read_size > FDP_NCI_I2C_MAX_PAYLOAD) {
> +				dev_dbg(&client->dev, "%s: corrupted packet\n",
> +					__func__);

As Andy points out, no need for __func__ in any dev_dbg() call.

thanks,

greg k-h
