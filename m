Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaBMHwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 02:52:08 -0500
Date: Thu, 13 Feb 2014 08:54:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: Re: [RFC] iwlwifi: refactor the TX / RX ampdu override
Message-ID: <20140213075427.GA1774@redhat.com> (sfid-20140213_085212_937908_84B04B3A)
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
 <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com>
 <20140212121314.GE1315@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D66597@HASMSX103.ger.corp.intel.com>
 <20140212140420.GA3379@redhat.com>
 <52FBD950.7080204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FBD950.7080204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 10:28:00PM +0200, Emmanuel Grumbach wrote:
> On 02/12/2014 04:04 PM, Stanislaw Gruszka wrote:
> > On Wed, Feb 12, 2014 at 12:27:05PM +0000, Grumbach, Emmanuel wrote:
> >>> I think we can keep IWL_DISABLE_HT_ALL option. I should be possible to
> >>> make some per-device type default settings and if disable_11n == 0 use
> >>> them. Otherwise use settings from module parameter. Will that work ?
> >>
> >> I'd prefer to have the default based on the iwldvm vs. iwlmvm instead of adding yet another per-HW field. But yeah - it is possible.
> > 
> > I re-think changing default settings do disable TX AGG and must tell
> > that this is very odd. I would prefer to stay defaults as they are now.
> > Users can disable TX aggregation using module option.
> 
> I disagree. We have bugs there - it is pretty much obvious. I remember a
> tracing from 2.6.39 which was before the re-architecture I made in the
> driver with clear FW bugs. I don't remember what device though.
> This is why I want to disable this by default.

Sure, it's up to you. But anyway, disabling feature because it buggy,
after having it run for 5 years or so, it's odd :-) 

Stanislaw
