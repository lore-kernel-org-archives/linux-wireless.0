Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3IOIbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 04:31:39 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] [RFC 0/5] mac80211/iwlwifi: quiesce before restart hw
Date: Sun, 15 Sep 2013 08:31:34 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DAF383@HASMSX103.ger.corp.intel.com> (sfid-20130915_103201_023557_CDE0EAE0)
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Here is continuation of short discussion I started here:
> http://marc.info/?l=linux-wireless&m=137724899704012&w=2
> 
> I made patches which do quiesce and that can be used by iwlwifi restart
> procedure to avoid calling iwlwifi methods by mac80211 while firmware is not
> alive.
> 
> But honestly, I'm not happy with that work. It does not fix root of the
> problem (microcode errors/hangs) and seems to be just to much
> complication to avoid warnings, which are consequence of firmware
> malfunction. So I just prefer to remove WARN_ONCE(trans->state !=
> IWL_TRANS_FW_ALIVE) and replace it by ordinary IWL_WARN(), which does
> not generate auto bug reports.
> 
> Regarding firmware problems debugging, perhaps ftrace can be used for
> that. iwlwifi has already tracing capabilities. Allow to gather log using trace-
> cmd and call tracing_off() when firmware error will happen, perhaps will
> allow to debug firmware problems efficiently.
> If you think that's right we could add WARN_ONCE on firmware error to have
> automatic bug reports. Then we could ask user for the trace to debug and
> solve the issue. Would that work for you?
> 

Yes - definitely. We have enough debug information in place in other places. Patch is coming (will go through regular tunnel).
BTW - I guess a dump_stack doesn't trigger the abrt, does it?

