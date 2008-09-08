Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYIHViq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 17:38:46 -0400
Subject: Re: [PATCH] libertas: clear current command on card removal
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, cjb@laptop.org, stable@kernel.org
In-Reply-To: <20080908210110.GD24557@tuxdriver.com>
References: <1220906080.1618.20.camel@localhost.localdomain>
	 <20080908210110.GD24557@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 17:39:17 -0400
Message-Id: <1220909957.9427.7.camel@localhost.localdomain> (sfid-20080908_233849_160399_C4F055F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-08 at 17:01 -0400, John W. Linville wrote:
> On Mon, Sep 08, 2008 at 04:34:40PM -0400, Dan Williams wrote:
> > If certain commands were in-flight when the card was pulled or the
> > driver rmmod-ed, cleanup would block on the work queue stopping, but the
> > work queue was in turn blocked on the current command being canceled,
> > which didn't happen.  Fix that.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> > ---
> > John, this is 2.6.27 material if there's still time.
> 
> I have to remind you of the new "regressions only" policy.  Is this a
> problem that we introduced in old code during the 2.6.27 merge window?

True :)  It is not a regression from 2.6.26, but a fairly serious bug
that has existed for some time.  Thus, treat it as you like to avoid
getting flamed by Linus & Dave.

I'll post to stable after 2.6.27 comes out then.

Dan


