Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaBLOFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 09:05:16 -0500
Date: Wed, 12 Feb 2014 15:04:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: Re: [RFC] iwlwifi: refactor the TX / RX ampdu override
Message-ID: <20140212140420.GA3379@redhat.com> (sfid-20140212_150522_492888_985D847D)
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
 <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com>
 <20140212121314.GE1315@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D66597@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D66597@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 12:27:05PM +0000, Grumbach, Emmanuel wrote:
> > I think we can keep IWL_DISABLE_HT_ALL option. I should be possible to
> > make some per-device type default settings and if disable_11n == 0 use
> > them. Otherwise use settings from module parameter. Will that work ?
> 
> I'd prefer to have the default based on the iwldvm vs. iwlmvm instead of adding yet another per-HW field. But yeah - it is possible.

I re-think changing default settings do disable TX AGG and must tell
that this is very odd. I would prefer to stay defaults as they are now.
Users can disable TX aggregation using module option.

I also not sure if that is really a firmware bug, it is rather more
probable that TX aggregation worked pretty fine on 5100 and other older
devices, but some driver changes broke that.
 
Stanislaw
