Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:50037 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbcBKP3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 10:29:46 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] codel: add forgotten inline to functions in header file
Date: Thu, 11 Feb 2016 15:29:41 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA0E809@hasmsx107.ger.corp.intel.com> (sfid-20160211_162958_321090_00C770D2)
References: <1455199701-25767-1-git-send-email-emmanuel.grumbach@intel.com>
 <1455201038.19473.12.camel@edumazet-glaptop2.roam.corp.google.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA0E6FD@hasmsx107.ger.corp.intel.com>
 <1455203555.19473.14.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/11/2016 05:12 PM, Eric Dumazet wrote:
> On Thu, 2016-02-11 at 15:05 +0000, Grumbach, Emmanuel wrote:
>
>
>> Yeah :) codel_should_drop seemed very long indeed... I wanted to use the
>> codel_get_time and associated utils (_before, _after) in iwlwifi.
>> They're better than jiffies... So maybe I can just copy that code to
>> iwlwifi.
>
> You certainly can submit a patch adding the inline, but not on all
> functions present in this file ;)
>
> Thanks !
>

Actually... All I need *has* the inline, but if I include codel.h,
codel_dequeue is defined but not used and you definitely don't want to
inline that one. So I guess the only other option I have is to split
that header file which I don't think is really worth it. So, unless you
object it, I'll just copy the code.

