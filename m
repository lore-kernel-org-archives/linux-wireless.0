Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51918 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbdINTlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:41:36 -0400
Message-ID: <1505418093.31630.21.camel@sipsolutions.net> (sfid-20170914_214139_624363_BD1F3B7A)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 21:41:33 +0200
In-Reply-To: <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com> (sfid-20170914_213704_661714_E0BFBBE8)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
         <1505414172.31630.13.camel@sipsolutions.net>
         <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
         <1505416964.31630.17.camel@sipsolutions.net>
         <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
         (sfid-20170914_213704_661714_E0BFBBE8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 14:37 -0500, Denis Kenzior wrote:

> > > My earlier point is that software roams need to have the exact
> > > same behavior as well.  And my understanding is that when we try
> > > to Fast-Transition (e.g. issue a CMD_ASSOCIATE), operstate is no
> > > longer UP.

> I'm talking about the kernel behavior, not wpa_s.

Oh.

> My guys discovered that the kernel seems to twiddle operstate
> automagically?  E.g. see description of 
> https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=4d
> 20db05d7c8806749db574e9231bd5d1c476c7f

Well I guess any time that the carrier does in fact go down, you'd also
reset oper state...

And now that I think about it, that does in fact happen in
ieee80211_set_disassoc(), which we even go through for FT roaming.

Sounds like something we should fix?

johannes
