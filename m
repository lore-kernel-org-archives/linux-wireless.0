Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756615AbdAKKMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 05:12:54 -0500
Date: Wed, 11 Jan 2017 11:10:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ad-hoc in 5GHz
Message-ID: <20170111101031.GA2927@redhat.com> (sfid-20170111_111258_717997_DB65952F)
References: <CAAfyv37ZFHkZWfq_gAB7XiqtDqVeT+SG7jfXxnCq2fyzYEKX_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAfyv37ZFHkZWfq_gAB7XiqtDqVeT+SG7jfXxnCq2fyzYEKX_w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Jan 11, 2017 at 09:36:00AM +0100, Belisko Marek wrote:
> this should be general question. I'm using [0] ralink driver to setup

It's Realtek not Ralink, right ?

> ad-hoc mode. It works fine in 2.4GHz band (channel 1) but when I try
> to setup ad-hoc for 5GHz (channel 50) it seems it's not working at all
> (I tried to scan with other device but I cannot ad-hoc network). So my
> question should ad-hoc mode work in 5GHz band also or there are some
> restrictions? Many thanks.

Depending on regulatory setting IBSS or IR (initialize radiation) can be
prohibited on some 5GHz channels, check "iw phy" to see which 5GHz channels
are allowed to use. If HW hardcoded regulatory do not prohibits IBSS on all
5GHZ channels it can be matter or setting proper regulatory domain
(configure timezone properly and then setregdomain will set domain based
on it).

Regards
Stanislaw
