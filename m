Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab0CKJ6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 04:58:50 -0500
Date: Thu, 11 Mar 2010 10:56:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
Message-ID: <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268265597.4192.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 03:59:57PM -0800, Johannes Berg wrote:
> I have objections. Or maybe not, but I don't think this makes a whole
> lot of sense since the BE queue should be programmed in the "qos turned
> off" way normally. That may be broken right now, but to me your patches
> seem like a workaround rather than a solution which would require an
> analysis of what's really going on.

I looked at this on the air. Everything is fine until device send QoS
NULL frame (even with default parameters: normal ACK, TXOP request). 
Then AP send two strange Probe Response frames and Disassociate frame
with "Micheal MIC failure" error.

So I think problem is with that, when WMM is configured device send
QoS frames, which AP do not expect. So when AP does not support WMM, we
should have QoS disabled. Currently in mac80211 there is no such option,
so I add it. In kernels before 2.6.31 everything works fine, because
drivers use own tx queue defaults with QoS disabled.

I guess we can do something better with that, for example change
ieee80211_set_wmm_default() to do:

if (data->vif.type == NL80211_IFTYPE_AP || data->vif.type ==  NL80211_IFTYPE_ADHOC)
	set_default_tx_queues();
else
	disable_qos();

But I wrote fix to do not affect other drivers, which I'm unable
to test and which may relay on current mac80211 behaviour. Fix is
intended to be backported. During next development cycle I plan
revise my patch and maybe send some more code changes related with
that area.

Stanislaw
