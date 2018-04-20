Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:38882 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbeDTMju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 08:39:50 -0400
Message-ID: <1524227986.21176.467.camel@linux.intel.com> (sfid-20180420_144004_488034_1A1270D7)
Subject: Re: [RESEND][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak
 issues in connectivity events handler
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
Date: Fri, 20 Apr 2018 15:39:46 +0300
In-Reply-To: <1524045904-7005-3-git-send-email-amit.pundir@linaro.org>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
         <1524045904-7005-3-git-send-email-amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-04-18 at 15:35 +0530, Amit Pundir wrote:

>  		if (skb->data[transaction->aid_len + 2] !=
> -		    NFC_EVT_TRANSACTION_PARAMS_TAG)
> +		    NFC_EVT_TRANSACTION_PARAMS_TAG ||
> +		    skb->len < transaction->aid_len + transaction-
> >params_len + 4) {

> +			devm_kfree(dev, transaction);

Oh, no.

This is not memory leak per se, this is bad choice of devm_ API where it
should use plain kmalloc() / kfree().

>  			return -EPROTO;
> +		}

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
