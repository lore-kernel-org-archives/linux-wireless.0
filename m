Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54259 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbaJFMfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:35:51 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Date: Mon, 6 Oct 2014 12:35:46 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B53CBD4@hasmsx107.ger.corp.intel.com> (sfid-20141006_143554_401170_999649A7)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
 <20141006123314.GA131459@ubuntu-hedt>
In-Reply-To: <20141006123314.GA131459@ubuntu-hedt>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
> 
> On Sun, Oct 05, 2014 at 04:57:12PM +0300, Emmanuel Grumbach wrote:
> > +	if (vif)
> > +		scd_queues &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
> 
> I'm backporting this to 3.13, and this part doesn't work unless
> 77be2c54c5bd26279abc13807398771d80cda37a is also backported. Is this
> critical, or can it be omitted in the backport?
> 

77be2c54c5bd26279abc13807398771d80cda37a isn't really critical, but it is a dependency, and it is safe IMO.
But I'd wait for a bit more testing :) The patch isn't even in my tree yet :)
