Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2HXJBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:09 -0400
Date: Fri, 24 Aug 2012 10:59:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Li Chaoming <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 4/6] rtlwifi: Add changes for new vendor driver version
Message-ID: <20120824085921.GB2982@redhat.com> (sfid-20120824_110114_507006_0EF41033)
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
 <1345561255-10349-5-git-send-email-Larry.Finger@lwfinger.net>
 <20120822105010.GB6082@redhat.com>
 <503660D3.5040703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503660D3.5040703@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry

On Thu, Aug 23, 2012 at 11:56:51AM -0500, Larry Finger wrote:
> >Could Realsil/Realtek post small patches please?
> >
> >See "Separate your changes." from Documentation/SubmittingPatches.
> >
> >You must have separate patches in repositories already. Life is strange,
> >but I don't believe Realsil/Realtek develops driver without source
> >control :-)
> 
> Sorry for making the patch so large.
> 
> I have no idea what Realtek uses for version control, but I have no
> access to it. What I get from them is a complete new version of a
> driver. To discover what changes have been made, I diff the new
> version against the old and prepare the necessary patches for the
> in-kernel versions, which have diverged from the vendor version.
> Most of the changes are cosmetic, but not all of them fit that
> category. When patches are submitted, I mark them as from Realtek
> authors when that is appropriate. If the change is something that I
> instituted, then I claim authorship. In either case, I am the one
> that prepared the patch.

Ok, I thought/hoped that Realtek is involved into that patch submission.
But if that is only your work, based on vendor driver release, I don't
want you to separate patches into smaller paces, since that is very
tedious work.

> >How this is suppose to work, this variable will be overwritten by
> >any ->pci_probe ? In general this buddy/glabal_var stuff is very
> >fishy, but I did not looked in detail at that. Does all of
> >that actually work ?
> 
> The question of whether it works will need to be deferred to
> Chaoming. The situation is that the device has both a 2.4 GHz part
> and a 5 GHz part that register as two separate devices; however,
> each driver instance needs to have access to some of the private
> variables of the other. Can you point me to an example of a safe way
> to do this without using a global variable?

Global variable is fine for that, but this need to be done carefully.

Thanks
Stanislaw
