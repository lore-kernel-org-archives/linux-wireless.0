Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0CKGkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 01:40:55 -0500
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	 <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 15:59:57 -0800
Message-ID: <1268265597.4192.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-10 at 16:20 +0100, Stanislaw Gruszka wrote:
> On Tue, Mar 09, 2010 at 02:21:14PM +0100, Stanislaw Gruszka wrote:
> > Problem is that we enable QoS queues, when AP do not send us any QoS
> > parameters. I think when AP not support QoS and does not tell anything
> > about that, we should not enable QoS in H/W. I prepared a draft patch,
> > it fixes the issue. However I'm not sure if this is right approach,
> > perhaps we should find something better.
> 
> I divide my fix into two patches. I'll send them in next emails.
> If no one have objections I'll post them "officially" with -stable cc.

I have objections. Or maybe not, but I don't think this makes a whole
lot of sense since the BE queue should be programmed in the "qos turned
off" way normally. That may be broken right now, but to me your patches
seem like a workaround rather than a solution which would require an
analysis of what's really going on.

johannes

