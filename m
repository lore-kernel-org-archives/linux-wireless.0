Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:1993 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754851AbeDTMle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 08:41:34 -0400
Message-ID: <1524228089.21176.469.camel@linux.intel.com> (sfid-20180420_144138_767109_3DC500D6)
Subject: Re: [RESEND][PATCH 4/4] NFC: fdp: Fix possible buffer overflow in
 WCS4000 NFC driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Apr 2018 15:41:29 +0300
In-Reply-To: <1524045904-7005-5-git-send-email-amit.pundir@linaro.org>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
         <1524045904-7005-5-git-send-email-amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-04-18 at 15:35 +0530, Amit Pundir wrote:

> +			if (phy->next_read_size >
> FDP_NCI_I2C_MAX_PAYLOAD) {

> +				dev_dbg(&client->dev, "%s: corrupted
> packet\n",
> +					__func__);

If Android people would follow the kernel in reasonable time they may
have noticed Dynamic Debug functionality and how it works.

In this case the __func__ is superfluous.

> +				phy->next_read_size = 5;
> +				goto flush;
> +			}
>  		} else {
>  			phy->next_read_size =
> FDP_NCI_I2C_MIN_PAYLOAD;
>  

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
