Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51576 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbeH3MyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 08:54:24 -0400
Message-ID: <1535619189.5215.47.camel@sipsolutions.net> (sfid-20180830_105322_066397_B3466A64)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is
 set to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 30 Aug 2018 10:53:09 +0200
In-Reply-To: <20180830085054.GB9867@localhost.localdomain> (sfid-20180830_105058_442284_40CB73B8)
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
         <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
         <1535569548.5215.33.camel@sipsolutions.net>
         <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
         <1535570007.5215.34.camel@sipsolutions.net>
         <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
         <1535616192.5215.37.camel@sipsolutions.net>
         <20180830083115.GA9867@localhost.localdomain>
         <1535618382.5215.44.camel@sipsolutions.net>
         <20180830085054.GB9867@localhost.localdomain>
         (sfid-20180830_105058_442284_40CB73B8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-30 at 10:50 +0200, Lorenzo Bianconi wrote:
> 
> ack, I agree. Do you want I send a patch to fix it?

I have it written now, I'll just commit & send it out.

> > Hmm, not sure I follow? "head" is the A-MSDU, containing the A-MSDU
> > header and the first subframe in skb->data (and/or frags), with the
> > subframes 2..N in the fraglist.
> > 
> > So I think this is right?
> 
> yep, correct. But when we are analyzing the second subframe what is the correct value for 'n'?
> 1 or 2? At the moment I guess it is set to 1 if frag_tail is NULL for head.

Ah. I guess you're right. So basically setting max_subframes to 1
doesn't avoid A-MSDUs completely, since n will still be 1 when we get
here ... good point, care to send a patch?

johannes
