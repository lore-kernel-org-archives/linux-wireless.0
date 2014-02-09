Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43023 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbaBIN1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Feb 2014 08:27:03 -0500
Date: Sun, 9 Feb 2014 15:26:54 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
Message-ID: <20140209132653.GA8352@localhost> (sfid-20140209_142707_877513_34709864)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
 <20140123200045.GA4064@localhost>
 <52E17698.9070607@gmail.com>
 <20140123202142.GC4064@localhost>
 <20140207214054.GB7167@localhost>
 <52F67313.1030706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52F67313.1030706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-02-08 20:10:27, Emmanuel Grumbach wrote:
> 
> There is no problem to be fixed. When I said that I found the issue, I meant that you are using a NIC which is not supposed to work on 5GHz on 
> these channels and this leads to the issues.

Right, wireless-N 7260 is not advertised as 5GHz card.  I just got over my laziness and searched the net.

> The fact that it doesn't work for you with -8.ucode proves that I am correct.

This is something i'd rather not comment on. :P

> I sent a patch that will disable 5GHz band for you from the driver level so that you won't suffer from firmware asserts.

Sweet.

> You told me you could work on 5GHz with this NIC - good for you. Conclude whatever you want from this, this is none of my business - but for 
> sure, the "issues" you are seeing are related to the fact that your NIC isn't supposed to be working on 5GHz, and hence, there is no bug to be 
> fixed.

Now that's funny.  Intel made an effort to put 5GHz radio on this card.  They even released firmware that can actually make use of this band.  I 
am pretty sure you won't answer these, but i'll ask why is that anyway:

	a) is the 'A' band implementation so buggy that you/Intel decided to disable it altogether?
	b) it is on sale too cheap to give it's customers the 'A' band;
	c) a mix of both (or none) of the above;

I kind of doubt it is a) since my laptop would happily stay connected to the router (on AN band) for days.  Were it not for the ugly 'dmesg' i'd 
never know there is a problem.  I have no idea of the device internals, but blowing up the workqueue (or whatever) is a bit too much.  With or 
without the A band functionality. ;)

Thanks for taking the time to look at my 'problem'.


		Petko
