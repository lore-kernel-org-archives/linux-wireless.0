Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46115 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750972AbeDTQpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 12:45:10 -0400
Date: Fri, 20 Apr 2018 09:45:07 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amit Pundir <amit.pundir@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RESEND][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak
 issues in connectivity events handler
Message-ID: <20180420164507.GA22666@animalcreek.com> (sfid-20180420_184525_646234_F77B4F73)
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
 <1524045904-7005-3-git-send-email-amit.pundir@linaro.org>
 <1524227986.21176.467.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524227986.21176.467.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 20, 2018 at 03:39:46PM +0300, Andy Shevchenko wrote:
> On Wed, 2018-04-18 at 15:35 +0530, Amit Pundir wrote:
> 
> >  		if (skb->data[transaction->aid_len + 2] !=
> > -		    NFC_EVT_TRANSACTION_PARAMS_TAG)
> > +		    NFC_EVT_TRANSACTION_PARAMS_TAG ||
> > +		    skb->len < transaction->aid_len + transaction-
> > >params_len + 4) {
> 
> > +			devm_kfree(dev, transaction);
> 
> Oh, no.
> 
> This is not memory leak per se, this is bad choice of devm_ API where it
> should use plain kmalloc() / kfree().

Also, there is no check to see if the allocation worked at all.

Mark
--
