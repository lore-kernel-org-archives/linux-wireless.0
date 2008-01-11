Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYAKCGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 21:06:38 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Date: Thu, 10 Jan 2008 17:42:58 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com> (sfid-20080111_020642_606418_1C2F79A5)
In-Reply-To: <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>
References: <11998765481610-git-send-email-joonwpark81@gmail.com> <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com> <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thursday, January 10, 2008 5:25 PM, Joonwoo Park  wrote:

> 2008/1/11, Chatre, Reinette <reinette.chatre@intel.com>:
>> 
>> Could synchronize_irq() be moved into iwl_disable_interrupts() ? I am
> 
> At this time, iwl_disable_interrupts() can be called with irq
> disabled, so for do that I think additional modification would be
> needed. 

If this is the case where iwl_disable_interrupts() is called while in
the ISR (where interrupts are disabled), then this behavior may be what
we want as synchronize_irq() (as I understand) waits for the handler to
complete irrespective of irq enable/disable. 

What modification are you considering?

>> also wondering if we cannot call tasklet_kill() before
>> iwl_disable_interrupts() ... thus preventing it from being scheduled
>> when we are going down.
> 
> Thanks for your catch, it seems tasklet can re-enable interrupts.
> I'll handle and make an another patch for them at this weekend :)

Please think it through also as I am exploring with you ...

Reinette

