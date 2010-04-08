Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55535 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041Ab0DHVYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:24:15 -0400
Received: by pwj9 with SMTP id 9so2351923pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 14:24:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270761488.16012.11.camel@mj>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	<1270754858-26266-8-git-send-email-lrodriguez@atheros.com>
	<1270761488.16012.11.camel@mj>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Apr 2010 14:23:54 -0700
Message-ID: <j2o43e72e891004081423w5d5076dy5077bb3fab2548f8@mail.gmail.com>
Subject: Re: [PATCH 007/102] ath9k_hw: AR9003 does not have AR_RC_AHB skip its
	setting
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 8, 2010 at 2:18 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-04-08 at 15:26 -0400, Luis R. Rodriguez wrote:
>> AR9003 does not have a reset control for AHB.
> ...
>> +                     val = AR_RC_HOSTIF;
>> +                     if (!AR_SREV_9300_20_OR_LATER(ah))
>> +                             val |= AR_RC_AHB;
>
> Perhaps AR_RC_AHB could be defined to 0 for AR9300 in the header?  Just
> an idea.

Hm, I rather be explicit for now. A larger goal we have after all this
will be to unify our code with the Atheros HAL. That itself should be
easier for review if we are explicit about some things for review
purposes. But that's just me thinking out loud.

  Luis
