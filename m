Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466Ab1CDO2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 09:28:30 -0500
Date: Fri, 4 Mar 2011 15:28:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: jpo234 <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k:  Put hardware in PROMISC mode if there is more
 than 1 stations.
Message-ID: <20110304142814.GA3899@redhat.com>
References: <1299191945-13257-1-git-send-email-greearb@candelatech.com>
 <loom.20110304T110306-345@post.gmane.org>
 <4D70F3CD.3040009@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D70F3CD.3040009@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 04, 2011 at 06:14:37AM -0800, Ben Greear wrote:
> On 03/04/2011 02:04 AM, jpo234 wrote:
> >| From: Ben Greear<greearb@...>
> >|
> >| It seems ath5k has issues receiving broadcast packets (ARPs) when
> >| using multiple STA interfaces associated with multiple APs.
> >| This patch ensures the NIC is always in PROMISC mode if there
> >| are more than 1 stations associated.
> >
> >Is this a band aid or a real fix?
> 
> I don't know.  It definitely makes things work, but it smells
> like a hack.  Considering ath9k works fine, it must be something
> in the ath5k driver, but I can't see any other problems.

In opposite to ath9k, there is no possibility to set multiple sta
addresses in the ath5k hw. I'm not sure if multiple station virtual
interfaces have sense is such case.

Stanislaw
