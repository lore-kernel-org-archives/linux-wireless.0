Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESTmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:42:07 -0400
Date: Mon, 19 May 2014 12:41:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to disable beacon filtering in iwlwifi in 3.13 and 3.14
Message-ID: <20140519194156.GA5991@kroah.com> (sfid-20140519_214212_210482_61726F86)
References: <CANUX_P2MSK_rUMyN2xa8A9dZwuPSKh+eiOr10KG6PocCQdVhvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P2MSK_rUMyN2xa8A9dZwuPSKh+eiOr10KG6PocCQdVhvA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 01:40:34PM +0300, Emmanuel Grumbach wrote:
> Hi,
> 
> I need to disable a feature on 3.13 and 3.14. But I don't have any
> patch upstream that I can point to as the patch that needs to be
> backported.
> We have a feature that is buggy in 3.13 and 3.14. We refactored (and
> fixed) this feature in 3.15 but the refactor is really not stable
> material, so basically, I can't backport the fix to 3.13 / 3.14. A
> user reported that disabling the feature solved (part of) his issues:
> https://bugzilla.kernel.org/show_bug.cgi?id=72601.
> OTOH, I don't have any patch in linux.git that could be backported to
> do what I want in 3.13 / 3.14 - i.e. disable the feature.
> What is the right process here? I understand that this isn't covered
> by the "stable rules". So what should I do here?

Get the maintainer's approval to apply this patch and I can queue it up.

> 
> FYI: this is the patch:
> 
> commit 31e56634bea6ab23817faa069663af3103da0609
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Sun May 18 19:05:23 2014 +0300
> 
>     iwlwifi: mvm: disable beacon filtering
> 
>     This feature has been causing trouble - disable it for now.
>     Fixes are available, but they are too big to be backported.
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=72601
> 
>     Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also, sending it in a format that I can apply it in would be nice :)

thanks,

greg k-h
