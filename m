Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42683 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaCKR4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 13:56:48 -0400
Message-ID: <531F4E3F.3020606@candelatech.com> (sfid-20140311_185651_965388_1F268703)
Date: Tue, 11 Mar 2014 10:56:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
References: <20140303154327.1290.67278.stgit@potku.adurom.net>  <CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>  <8761nv44nd.fsf@kamboji.qca.qualcomm.com>  <87k3c1gf35.fsf@kamboji.qca.qualcomm.com>  <531F49F2.3030408@candelatech.com> <1394559971.20021.1.camel@joe-AO722>
In-Reply-To: <1394559971.20021.1.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2014 10:46 AM, Joe Perches wrote:
> On Tue, 2014-03-11 at 10:37 -0700, Ben Greear wrote:
>> but I would also suggest giving user a clue as to the
>> severity.  Something starting with 'failed' or 'warning' is pretty obvious.
> 
> Isn't that the whole point of KERN_<LEVEL>?
> 
> I think duplicating it is pointless.

Normal users use dmesg or cat /var/log/messages.  The KERN_LEVEL is
not immediately obvious there (at least on my Fedora systems).

And either way, the driver may want to always show some interesting
thing and so put it at KERN_ERR when in fact is not a real error
that the user should be concerned about (think firmware version,
for instance)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

