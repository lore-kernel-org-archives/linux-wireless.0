Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52251 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaBLU2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 15:28:04 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4557821eei.7
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 12:28:02 -0800 (PST)
Message-ID: <52FBD950.7080204@gmail.com> (sfid-20140212_212808_654604_93E4D9CF)
Date: Wed, 12 Feb 2014 22:28:00 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: Re: [RFC] iwlwifi: refactor the TX / RX ampdu override
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com> <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com> <20140212121314.GE1315@redhat.com> <0BA3FCBA62E2DC44AF3030971E174FB303D66597@HASMSX103.ger.corp.intel.com> <20140212140420.GA3379@redhat.com>
In-Reply-To: <20140212140420.GA3379@redhat.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/12/2014 04:04 PM, Stanislaw Gruszka wrote:
> On Wed, Feb 12, 2014 at 12:27:05PM +0000, Grumbach, Emmanuel wrote:
>>> I think we can keep IWL_DISABLE_HT_ALL option. I should be possible to
>>> make some per-device type default settings and if disable_11n == 0 use
>>> them. Otherwise use settings from module parameter. Will that work ?
>>
>> I'd prefer to have the default based on the iwldvm vs. iwlmvm instead of adding yet another per-HW field. But yeah - it is possible.
> 
> I re-think changing default settings do disable TX AGG and must tell
> that this is very odd. I would prefer to stay defaults as they are now.
> Users can disable TX aggregation using module option.

I disagree. We have bugs there - it is pretty much obvious. I remember a
tracing from 2.6.39 which was before the re-architecture I made in the
driver with clear FW bugs. I don't remember what device though.
This is why I want to disable this by default.
You asked me to do this with a module parameter and not with a Kconfig
option - I agreed.
Now - if you want to ship with a different settings, you can... but we
both know the risk.

> 
> I also not sure if that is really a firmware bug, it is rather more
> probable that TX aggregation worked pretty fine on 5100 and other older
> devices, but some driver changes broke that.

Frankly, I don't really remember that... I have to say that I might not
have been in the business at that period...
