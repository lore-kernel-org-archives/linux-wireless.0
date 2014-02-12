Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbaBLJWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:22:45 -0500
Date: Wed, 12 Feb 2014 10:21:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
Message-ID: <20140212092150.GC1315@redhat.com> (sfid-20140212_102250_317172_8E2B13C3)
References: <52FB360D.2060502@gmail.com>
 <1392195269-5514-1-git-send-email-egrumbach@gmail.com>
 <20140212091008.GB1315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140212091008.GB1315@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 10:10:08AM +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 12, 2014 at 10:54:29AM +0200, Emmanuel Grumbach wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > We have had a bug in TX AMPDU in iwldvm for a very long
> > time. This bug has been raised in many bugzillas and threads
> > on linux-wireless mailing list.
> > 
> > The bug is in firmware and we won't be able to fix it in the
> > near future. Hence, we prefer to disable TX AMPDU by default
> > in iwldvm. This doesn't affect iwlmvm which supports 7160 /
> > 3160 and up.
> 
> ...
> 
> >  #define IWL_DISABLE_HT_ALL	BIT(0)
> > -#define IWL_DISABLE_HT_TXAGG	BIT(1)
> 
> Whouln't simple change, by setting disable_11=2 by default, make
> the same effect, and allow easly to enable TX aggregation (without
> kernel recompile) ?

Also, does the bug affect all iwldvm devices ? They have different
firmware images, so I wonder if this is needed for all DVM devices.

Stanislaw 
