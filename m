Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753304AbdKIKyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 05:54:37 -0500
Date: Thu, 9 Nov 2017 11:54:36 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
Message-ID: <20171109105435.GA2875@redhat.com> (sfid-20171109_115500_553517_6454A1C2)
References: <1509983829.10974.2.camel@gmail.com>
 <20171107085327.GA11380@redhat.com>
 <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
 <20171107101320.GA12140@redhat.com>
 <1510052483.24015.1.camel@gmail.com>
 <20171108103729.GA2641@redhat.com>
 <1510139235.10467.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510139235.10467.1.camel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 08, 2017 at 12:07:15PM +0100, Richard Genoud wrote:
> (maybe if there was more than one CPU on the board, I could do
> something, but that's not the case)

I reproduced the problem with nosmp option. I think we need
to check also for ENOENT error (not only for ENODEV).
Will post the fix in a second.

Thanks for reporting and debugging
Stanislaw 
