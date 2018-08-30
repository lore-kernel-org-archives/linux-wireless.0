Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51800 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbeH3NJL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 09:09:11 -0400
Message-ID: <1535620072.5215.51.camel@sipsolutions.net> (sfid-20180830_110804_549138_E10C7767)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is
 set to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 30 Aug 2018 11:07:52 +0200
In-Reply-To: <20180830090725.GE9867@localhost.localdomain> (sfid-20180830_110729_327984_B8136566)
References: <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
         <1535570007.5215.34.camel@sipsolutions.net>
         <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
         <1535616192.5215.37.camel@sipsolutions.net>
         <20180830083115.GA9867@localhost.localdomain>
         <1535618382.5215.44.camel@sipsolutions.net>
         <20180830085054.GB9867@localhost.localdomain>
         <1535619189.5215.47.camel@sipsolutions.net>
         <20180830090045.GC9867@localhost.localdomain>
         <1535619812.5215.49.camel@sipsolutions.net>
         <20180830090725.GE9867@localhost.localdomain>
         (sfid-20180830_110729_327984_B8136566)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-30 at 11:07 +0200, Lorenzo Bianconi wrote:
> 
> I do not think so since for nfrags we have:
> nfrags = 1 + skb_shinfo(skb)->nr_frags;
> nfrags += 1 + skb_shinfo(head)->nr_frags;
> 
> and even if frag_tail is NULL we will have nfrags = 2.
> 
> Agree?

Yeah, I misread those two lines.

johannes
