Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50864 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdIFKjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 06:39:05 -0400
Message-ID: <1504694343.13457.11.camel@sipsolutions.net> (sfid-20170906_123908_616925_3E4641A5)
Subject: Re: [PATCH] iw: Null check before accessing n_mcs variable
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nitin Jhanwar <nitin.j@samsung.com>
Date: Wed, 06 Sep 2017 12:39:03 +0200
In-Reply-To: <20170901061008epcms5p5fdd787910f9698c511e01a134afe90ea@epcms5p5>
References: <CGME20170901061008epcms5p5fdd787910f9698c511e01a134afe90ea@epcms5p5>
         <20170901061008epcms5p5fdd787910f9698c511e01a134afe90ea@epcms5p5>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-01 at 06:10 +0000, Amit Khatri wrote:
> From: Amit Khatri <amit.khatri@samsung.com>
> Date: Thu, 24 Aug 2017 00:16:26 -0700
> Subject: [PATCH] iw: Null check before accessing n_mcs variable
> 
> If all cases will fail n_mcs variable fail to get any assignement
> and remain NULL. so better to check NULL before dereference.
> 

This is wrong - you can't get into S_HT state unless n_mcs was also
assigned, and if you can't get into S_HT state then you can't
dereference n_mcs either.

johannes
