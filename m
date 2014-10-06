Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35089 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaJFMnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:43:19 -0400
Received: by mail-ob0-f171.google.com with SMTP id va2so3785897obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 05:43:19 -0700 (PDT)
Date: Mon, 6 Oct 2014 07:43:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Message-ID: <20141006124307.GB131459@ubuntu-hedt> (sfid-20141006_144325_504556_09171D1D)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
 <20141006123314.GA131459@ubuntu-hedt>
 <0BA3FCBA62E2DC44AF3030971E174FB31B53CBD4@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B53CBD4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2014 at 12:35:46PM +0000, Grumbach, Emmanuel wrote:
> > Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
> > 
> > On Sun, Oct 05, 2014 at 04:57:12PM +0300, Emmanuel Grumbach wrote:
> > > +	if (vif)
> > > +		scd_queues &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
> > 
> > I'm backporting this to 3.13, and this part doesn't work unless
> > 77be2c54c5bd26279abc13807398771d80cda37a is also backported. Is this
> > critical, or can it be omitted in the backport?
> > 
> 
> 77be2c54c5bd26279abc13807398771d80cda37a isn't really critical, but it is a dependency, and it is safe IMO.
> But I'd wait for a bit more testing :) The patch isn't even in my tree yet :)

My backport is for testing too. Most of our bugs are against Ubuntu
14.04, which uses 3.13. Seems better to have them test this change in
isolation rather than also testing everything which has changed up to
3.17.

I agree the patch is safe, but I'd also prefer to have it tested in the
form which would eventually get applied to the 3.13 extended stable
tree. So I take it for stable you would advocate applying both patches?
