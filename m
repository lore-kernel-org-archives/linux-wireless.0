Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:19042 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIKFPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 01:15:13 -0400
Received: by rn-out-0910.google.com with SMTP id k40so138922rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2008 22:15:12 -0700 (PDT)
Message-ID: <445f43ac0809102215w2637dff7sa2c60dd8c31ccf6@mail.gmail.com> (sfid-20080911_071526_622156_4BDA7F26)
Date: Wed, 10 Sep 2008 22:15:12 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: sta_info->fail_avg
Cc: "Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221091198.3804.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221091198.3804.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Wed, Sep 10, 2008 at 4:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Luis,
>
> Can you explain what you're using this for in the mesh code?

It is used to estimate the average retransmissions that will be
required to send a nominal frame over a given peer link.
That's one component of the airtime link metric.

> I do know that neither ath9k's nor Intel's rate
> control algorithms ever set it so it'll always be zero.

In that case transmission failures will not be taken into account and
nodes with that hardware will report a lower (better) link metric than
what they should.  In other words, those nodes will attract mesh
traffic, which will provide a strong incentive for the driver
maintainers to set that value correctly :)

Cheers,

Javier
-- 
Javier Cardona
cozybit Inc.
