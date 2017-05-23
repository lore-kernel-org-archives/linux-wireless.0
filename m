Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34675 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966321AbdEWHYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 03:24:55 -0400
Received: by mail-pf0-f173.google.com with SMTP id 9so105981632pfj.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 May 2017 00:24:55 -0700 (PDT)
Subject: Re: 4.12-RC2 BUG: scheduling while atomic: irq/47-iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>,
        Sander Eikelenboom <linux@eikelenboom.it>
References: <a54f3f4f-2365-2154-ad18-82e4cd572aac@eikelenboom.it>
 <1495450628.2653.14.camel@sipsolutions.net>
 <764a929c-ce8a-c859-a49e-2f20cb05ae44@broadcom.com>
 <532c257e-52a0-18c1-1afe-04d37c28e072@broadcom.com>
 <1495487095.26008.7.camel@sipsolutions.net>
 <09ddb018-7093-2e2a-c84b-148889f7f06d@broadcom.com>
 <1495524153.2464.2.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ff02b9a1-94e1-8bbd-c48e-c2d05b0b75ec@broadcom.com> (sfid-20170523_092522_809273_9899372E)
Date: Tue, 23 May 2017 09:24:49 +0200
MIME-Version: 1.0
In-Reply-To: <1495524153.2464.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-5-2017 9:22, Johannes Berg wrote:
> On Tue, 2017-05-23 at 09:19 +0200, Arend Van Spriel wrote:
>>
>>> 	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
>>
>> Thought about something like this after sending the email. So there
>> are two call sites. One for scheduled scan results notification and
>> one in scheduled scan stop scenario. So for the latter it is not
>> needed to use the rcu_read_lock() as it should have RTNL lock hence
>> the two checks above?
> 
> Right. The latter can't even really use rcu_read_lock() since it also
> wants to modify the list, and that's not sufficient protection for
> modifying.

Hence the name ;-)

Regards,
Arend
